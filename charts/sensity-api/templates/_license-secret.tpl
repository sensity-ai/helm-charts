{{/*
Creates a secret containing the key sensity.license storing the value licenseKey
*/}}
{{- define "sensity-api.license-secret" -}}
apiVersion: v1
data:
  sensity.license: {{ required "A license key must be available" .Values.licenseKey }}
kind: Secret
metadata:
  name: {{ include "sensity-api.fullname" . }}-license
{{- end }}
