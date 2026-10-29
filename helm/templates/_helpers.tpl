{{- define "ecom-polyglot-platform.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "ecom-polyglot-platform.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "ecom-polyglot-platform.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ecom-polyglot-platform.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{ include "ecom-polyglot-platform.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end}}

{{- define "ecom-polyglot-platform.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ecom-polyglot-platform.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}