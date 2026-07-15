{{/*
Expand the name of the chart.
*/}}
{{- define "sample.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "sample.releaseName" -}}
{{- default .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sample.fullname" -}}
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
{{- define "sample.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sample.labels" -}}
app.kubernetes.io/app: {{ .Release.Name }}
helm.sh/chart: {{ include "sample.chart" . }}
{{ include "sample.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
backstage.io/kubernetes-id: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sample.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sample.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sample.serviceAccountName" -}}
{{- if or .Values.serviceAccount.enabled (and .Values.istio.enabled .Values.istio.serviceAccount.enabled) }}
{{- default (include "sample.releaseName" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Dynatrace environment variables
*/}}
{{- define "sample.dynatraceEnvs" -}}
- name: DT_RELEASE_VERSION
  value: {{ .Values.image.tag | quote }}
- name: DT_RELEASE_PRODUCT
  value: {{ .Values.project.name }}
- name: DT_RELEASE_STAGE
  value: {{ .Values.project.env }}
{{- end }}

{{/*
podAntiAffinity per hostname and zone
*/}}
{{- define "sample.podAntiAffinityPRD" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
            - key: "app.kubernetes.io/instance"
              operator: In
              values:
                - {{ .Release.Name }}
        topologyKey: "kubernetes.io/hostname"
    - weight: 99
      podAffinityTerm:
        labelSelector:
          matchExpressions:
            - key: "app.kubernetes.io/instance"
              operator: In
              values:
                - {{ .Release.Name }}
        topologyKey: "failure-domain.beta.kubernetes.io/zone"
{{- end }}
