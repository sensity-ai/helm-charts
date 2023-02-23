{{/*
Create the shared environment configuration by all chart using the
configuration provided in the individual chart values
*/}}
{{- define "sensity-api.config" -}}
PREM_COUNT_TASK_ENDPOINT: "https://europe-west1-sensity-350013.cloudfunctions.net/license-server-count"

# API Related configuration
{{- with .Values.config.apiRootPath }}
API_ROOT_PATH: {{ . }}
{{- end }}
{{- end }}
