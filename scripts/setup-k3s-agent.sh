#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}K3s Agent Node Setup Script${NC}"
echo "--------------------------------"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run as root. This script will use sudo when needed."
    exit 1
fi

# Get server information
echo -e "\n${GREEN}Enter K3s server information:${NC}"
read -p "Server IP: " SERVER_IP
read -p "Node Token: " K3S_TOKEN

# Create .kube directory
mkdir -p ~/.kube

# Install k3s agent
echo -e "\n${GREEN}Installing K3s agent...${NC}"
curl -sfL https://get.k3s.io | K3S_URL=https://${SERVER_IP}:6443 K3S_TOKEN=${K3S_TOKEN} sh -

# Wait for k3s to be ready
echo "Waiting for k3s to be ready..."
sleep 10

echo -e "\n${GREEN}Setup Complete!${NC}"
echo -e "Your agent node is now connected to the server at ${BLUE}${SERVER_IP}${NC}"
echo -e "\nTo verify the connection on the server node, run: ${BLUE}kubectl get nodes${NC}" 