{{/*
Create a default service that maps to the Rest API of the webserver
*/}}
{{- define "sensity-api.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "sensity-api.fullname" . }}
  labels:
    {{- include "sensity-api.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: api
      protocol: TCP
      name: api
  selector:
    {{- include "sensity-api.selectorLabels" . | nindent 4 }}
{{- end }}
