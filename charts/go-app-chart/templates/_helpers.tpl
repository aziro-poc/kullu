{{- define "go-app-chart.name" -}}
{{ include "go-app-chart.fullname" . }}
{{- end -}}

{{- define "go-app-chart.fullname" -}}
{{ .Chart.Name }}
{{- end -}}