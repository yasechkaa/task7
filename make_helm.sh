#!/bin/bash
mkdir -p helm-charts/{app,db,monitoring}/templates

# --- 1. APP CHART ---
cat << 'EOF' > helm-charts/app/Chart.yaml
apiVersion: v2
name: flask-app
version: 0.1.0
EOF

cat << 'EOF' > helm-charts/app/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
        - name: app
          image: aosoos/flask-app:v1
          ports:
            - containerPort: 8080
          env:
            - name: DATABASE_URL
              value: "postgresql://user:password@db-postgresql:5432/crud_db"
---
apiVersion: v1
kind: Service
metadata:
  name: flask-app
spec:
  selector:
    app: flask-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
EOF

# --- 2. DB CHART ---
cat << 'EOF' > helm-charts/db/Chart.yaml
apiVersion: v2
name: database
version: 0.1.0
EOF

cat << 'EOF' > helm-charts/db/templates/database.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: db-postgresql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: postgres:15
          env:
            - name: POSTGRES_USER
              value: user
            - name: POSTGRES_PASSWORD
              value: password
            - name: POSTGRES_DB
              value: crud_db
          ports:
            - containerPort: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: db-postgresql
spec:
  selector:
    app: postgres
  ports:
    - protocol: TCP
      port: 5432
      targetPort: 5432
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
        - name: redis
          image: redis:7-alpine
          ports:
            - containerPort: 6379
---
apiVersion: v1
kind: Service
metadata:
  name: redis
spec:
  selector:
    app: redis
  ports:
    - protocol: TCP
      port: 6379
      targetPort: 6379
EOF

# --- 3. MONITORING CHART ---
cat << 'EOF' > helm-charts/monitoring/Chart.yaml
apiVersion: v2
name: monitoring
version: 0.1.0
EOF

cat << 'EOF' > helm-charts/monitoring/templates/prometheus.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
        - name: prometheus
          image: prom/prometheus:latest
          ports:
            - containerPort: 9090
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
spec:
  selector:
    app: prometheus
  ports:
    - protocol: TCP
      port: 9090
      targetPort: 9090
EOF

echo "Чарты созданы в папке helm-charts/"