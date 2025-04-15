#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}K3s Server Node Setup Script${NC}"
echo "--------------------------------"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run as root. This script will use sudo when needed."
    exit 1
fi

# Prompt for GitHub credentials
echo -e "\n${GREEN}Enter your GitHub credentials:${NC}"
read -p "GitHub Username: " GITHUB_USER
read -sp "GitHub Token: " GITHUB_TOKEN
echo
read -p "GitHub Repository Name: " REPO_NAME

# Prompt for Cluster settings
echo -e "\n${GREEN}Enter namespace...${NC}"
read -p "Namespace: " NAMESPACE


# Install k3s server
echo -e "\n${GREEN}Installing K3s server...${NC}"
curl -sfL https://get.k3s.io | sh -

# Wait for k3s to be ready
echo "Waiting for k3s to be ready..."
sleep 10


# Setup kubeconfig
echo -e "\n${GREEN}Setting up kubeconfig...${NC}"
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config.yaml
sudo chown $USER:$USER ~/.kube/config.yaml
chmod 600 ~/.kube/config.yaml

# Export kubeconfig path
echo 'export KUBECONFIG=~/.kube/config.yaml' >> ~/.bashrc
export KUBECONFIG=~/.kube/config.yaml

# Get node token for agents
NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
export K3S_TOKEN=$NODE_TOKEN
echo -e "\n${GREEN}Node Token for agents:${NC}"
echo $NODE_TOKEN

# Create web namespace
echo -e "\n${GREEN}Creating namespace...${NC}"
kubectl create namespace $NAMESPACE

# Install Flux
echo -e "\n${GREEN}Installing Flux...${NC}"
curl -s https://fluxcd.io/install.sh | sudo bash

# Bootstrap Flux with GitHub
echo -e "\n${GREEN}Bootstrapping Flux with GitHub...${NC}"
export GITHUB_TOKEN=$GITHUB_TOKEN
flux bootstrap github \
    --owner=$GITHUB_USER \
    --repository=$REPO_NAME \
    --branch=main \
    --path=clusters/staging \
    --personal \
    --components-extra=image-reflector-controller,image-automation-controller 

# Create GitHub Container Registry secret
echo -e "\n${GREEN}Creating GitHub Container Registry secret...${NC}"
kubectl create secret docker-registry ghcr-credentials \
    --namespace=$NAMESPACE \
    --docker-server=ghcr.io \
    --docker-username=$GITHUB_USER \
    --docker-password=$GITHUB_TOKEN

# Print useful information
echo -e "\n${GREEN}Setup Complete!${NC}"
echo -e "Your server node is ready. Here's some useful information:"
echo -e "1. Node Token (save this for agent setup): ${BLUE}$NODE_TOKEN${NC}"
echo -e "2. To get your server IP: ${BLUE}ip addr show${NC}"
echo -e "3. Check Flux status: ${BLUE}flux get all${NC}"
echo -e "4. Check pods: ${BLUE}kubectl get pods -A${NC}"
echo -e "5. Namespaces: ${BLUE}kubectl get namespaces${NC}"

# Source bashrc to apply KUBECONFIG changes
source ~/.bashrc 