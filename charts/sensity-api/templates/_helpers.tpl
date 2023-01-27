{{/*
Expand the name of the chart.
*/}}
{{- define "sensity-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sensity-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sensity-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sensity-api.labels" -}}
helm.sh/chart: {{ include "sensity-api.chart" . }}
{{ include "sensity-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sensity-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sensity-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Creates a secret containing the key sensity.license storing the value licenseKey
*/}}
{{- define "sensity-api.license-secret" -}}
apiVersion: v1
data:
  sensity.license: {{ required "A license key must be available" .Values.licenseKey }}
kind: Secret
metadata:
  name: {{ .Chart.Name }}-license
{{- end }}


{{/*
Create a deployment for a Sensity API service
*/}}
{{- define "sensity-api.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "sensity-api.fullname" . }}
  labels:
    {{- include "sensity-api.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "sensity-api.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "sensity-api.selectorLabels" . | nindent 8 }}
    spec:
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers:
        - name: {{ .Chart.Name }}
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          args: ["--web"]
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: api
              containerPort: 8000
              protocol: TCP
          # TODO: customize further liveness/readinessProbe
          livenessProbe:
            httpGet:
              path: /ping
              port: api
          readinessProbe:
            httpGet:
              path: /ping
              port: api
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          volumeMounts:
            - name: license
              readOnly: true
              mountPath: /app/licenses/sensity.license
              subPath: sensity.license
      volumes:
        - name: license
          secret:
            secretName: {{ .Chart.Name }}-license
{{- end }}
