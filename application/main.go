package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
)

type Config struct {
	ID       int    `json:"id"`
	Host     string `json:"host"`
	Port     int    `json:"port"`
	AppName  string `json:"app_name"`
	LogLevel string `json:"log_level"`
}

var db *sql.DB

func main() {
	// Get DATABASE_URL from environment, fallback if not set
	dbUrl := os.Getenv("DATABASE_URL")
	if dbUrl == "" {
		log.Println("DATABASE_URL not set, using default connection")
		dbUrl = "postgres://admin:admin123@10.88.0.2:5432/configs?sslmode=disable"
	}

	var err error
	db, err = sql.Open("postgres", dbUrl)
	if err != nil {
		log.Fatal("DB connection failed:", err)
	}

	// Create router
	router := mux.NewRouter()

	// Routes
	router.HandleFunc("/ping", pingHandler).Methods("GET")
	router.HandleFunc("/configs", getAllConfigs).Methods("GET")
	router.HandleFunc("/configs/{id}", getConfig).Methods("GET")
	router.HandleFunc("/configs", upsertConfig).Methods("POST")

	log.Println("Server running on port 8080")
	http.ListenAndServe(":8080", router)
}

// Health check
func pingHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("pong"))
}

// Get all configs
func getAllConfigs(w http.ResponseWriter, r *http.Request) {
	rows, err := db.Query("SELECT id, host, port, app_name, log_level FROM configs")
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	defer rows.Close()

	var configs []Config
	for rows.Next() {
		var c Config
		if err := rows.Scan(&c.ID, &c.Host, &c.Port, &c.AppName, &c.LogLevel); err != nil {
			http.Error(w, err.Error(), 500)
			return
		}
		configs = append(configs, c)
	}

	json.NewEncoder(w).Encode(configs)
}

// Get single config by ID
func getConfig(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	var config Config

	err := db.QueryRow("SELECT id, host, port, app_name, log_level FROM configs WHERE id=$1", params["id"]).
		Scan(&config.ID, &config.Host, &config.Port, &config.AppName, &config.LogLevel)

	if err != nil {
		http.Error(w, "Config not found", 404)
		return
	}

	json.NewEncoder(w).Encode(config)
}

// Insert or update config
func upsertConfig(w http.ResponseWriter, r *http.Request) {
	var config Config
	err := json.NewDecoder(r.Body).Decode(&config)
	if err != nil {
		http.Error(w, "Invalid JSON body", 400)
		return
	}

	_, err = db.Exec(`
		INSERT INTO configs (id, host, port, app_name, log_level)
		VALUES ($1, $2, $3, $4, $5)
		ON CONFLICT (id) DO UPDATE SET
			host = EXCLUDED.host,
			port = EXCLUDED.port,
			app_name = EXCLUDED.app_name,
			log_level = EXCLUDED.log_level
	`, config.ID, config.Host, config.Port, config.AppName, config.LogLevel)

	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	w.Write([]byte("Config inserted/updated"))
}