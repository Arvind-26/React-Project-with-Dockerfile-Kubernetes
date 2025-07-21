# React Project with Dockerfile & Kubernetes

This project demonstrates how to containerize a React.js application using Docker, push the image to Docker Hub, and deploy it on a Kubernetes cluster using **Deployments**, **Pods**, and **NodePort Service**.

---

## 🌐 Technologies Used

- [React.js](https://reactjs.org/)
- [Docker](https://www.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Kubernetes](https://kubernetes.io/)
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/)
- [Nginx](https://www.nginx.com/)

---

## 📦 Project Structure
<pre lang="nohighlight"><code> React-Project-with-Dockerfile-Kubernetes/ 
  │ 
  ├── Dockerfile --> Docker image build file 
  ├── deployment.yaml --> Kubernetes deployment configuration 
  ├── service.yaml --> Kubernetes NodePort service configuration 
  ├── public/ --> React public assets 
  ├── src/ --> React components and source code 
  ├── package.json --> Project metadata and dependencies 
  └── README.md --> You're reading it! ``` </code></pre>

---

## 🚀 Deployment Overview

This project follows these steps to deploy:

1. **Build the React application**
2. **Containerize the build using Docker**
3. **Push the image to Docker Hub**
4. **Deploy the container on Kubernetes using a Deployment**
5. **Expose the app using a NodePort Service**

---

## 🛠️ Prerequisites

Before proceeding, ensure you have:

- [Node.js](https://nodejs.org/) and npm installed
- Docker installed and running
- An account on Docker Hub
- Kubernetes installed (use [Minikube](https://minikube.sigs.k8s.io/) for local testing)
- `kubectl` command-line tool installed

---

## 📁 Step-by-Step Setup

### 1. Clone the Repository

git clone https://github.com/Arvind-26/React-Project-with-Dockerfile-Kubernetes.git
cd React-Project-with-Dockerfile-Kubernetes

### 2. Build the React App

npm install
npm run build

This step generates an optimized production build in the `/build` directory.

### 3. Create Docker Image

#### Dockerfile Used:

Stage 1: Build React app
FROM node:14-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

#### Build the Docker Image:

docker build -t <your-dockerhub-username>/<image-name>:latest .

### 4. Push Docker Image to Docker Hub

docker login
docker push <your-dockerhub-username>/<image-name>:latest

---

## ☸️ Kubernetes Deployment

### 5. Create Deployment (`deployment.yaml`)

apiVersion: apps/v1
kind: Deployment
metadata:
name: react-app-deployment
spec:
replicas: 2
selector:
matchLabels:
app: react-app
template:
metadata:
labels:
app: react-app
spec:
containers:
- name: react-container
image: <your-dockerhub-username>/<image-name>:latest
ports:
- containerPort: 80

### 6. Create NodePort Service (`service.yaml`)

apiVersion: v1
kind: Service
metadata:
name: react-app-service
spec:
type: NodePort
selector:
app: react-app
ports:
- port: 80
targetPort: 80
nodePort: 30007

### 7. Apply Kubernetes Manifests

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

---

## 🌐 Accessing the App

If you're using **Minikube**, get the cluster IP:

minikube ip

Visit your app in the browser:

http://<minikube-ip>:30007

---

## 🧹 Cleanup Resources (Optional)

kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
---

## 📌 Important Notes

- Replace `<your-dockerhub-username>` and `<image-name>` with your actual Docker Hub username and repository/image name.
- The `nodePort` value must be in the range `30000–32767` if using Minikube or NodePort service on a local cluster.

---

## 🤝 Contribution

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.
