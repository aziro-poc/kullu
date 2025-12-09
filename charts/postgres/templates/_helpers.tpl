{{- define "postgres.name" -}}
postgres
{{- end -}}

{{- define "postgres.fullname" -}}
{{ .Release.Name }}-postgres
{{- end -}}

{{- define "postgres.labels" -}}
app.kubernetes.io/name: {{ include "postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
{{- end }}