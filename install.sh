#!/bin/sh
#installation docker
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release    
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker && sudo usermod -aG docker $USER
#install minikube
#install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.26.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
#install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
minikube start --driver=docker
minikube status
#install ctf-platform
kubectl create namespace ctfd
kubectl create namespace pwn
kubectl create namespace web
kubectl apply -f ctfd-mysql-deployment.yaml 
kubectl apply -f ctfd-redis-deployment.yaml 
kubectl apply -f ctfd-deployment.yaml 
#apply web tasks
kubectl apply -f headache.yml 
kubectl apply -f who.yml 
kubectl apply -f monitor.yml
#apply pwn tasks
kubectl apply -f fsb.yml 
kubectl apply -f fripe.yaml 
kubectl apply -f simon.yml 
kubectl apply -f misalign.yaml 

kubectl apply -f fsb.yml 
