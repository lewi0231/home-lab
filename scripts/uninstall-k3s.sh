#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}K3s Cluster Uninstall Script${NC}"
echo "--------------------------------"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run as root. This script will use sudo when needed."
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Confirm uninstallation
echo -e "${RED}Warning: This will completely remove K3s, Flux, and all related configurations.${NC}"
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r

echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Uninstallation cancelled."
    exit 1
fi

# Uninstall Flux if it exists
if command_exists flux; then
    echo -e "\n${BLUE}Uninstalling Flux...${NC}"
    flux uninstall --silent || true
    sudo rm -f $(which flux)
fi

# Remove flux cache and config
echo -e "\n${BLUE}Removing Flux configurations...${NC}"
rm -rf ~/.flux2
rm -rf ~/.config/flux

# Uninstall K3s
echo -e "\n${BLUE}Uninstalling K3s...${NC}"
if [ -f /usr/local/bin/k3s-uninstall.sh ]; then
    sudo /usr/local/bin/k3s-uninstall.sh
fi

# Clean up kubeconfig
echo -e "\n${BLUE}Cleaning up kubeconfig...${NC}"
rm -rf ~/.kube

# Remove KUBECONFIG from bashrc
echo -e "\n${BLUE}Removing KUBECONFIG from bashrc...${NC}"
sed -i '/export KUBECONFIG/d' ~/.bashrc

# Clean up any remaining k3s files
echo -e "\n${BLUE}Cleaning up remaining K3s files...${NC}"
sudo rm -rf /etc/rancher/k3s
sudo rm -rf /var/lib/rancher/k3s
sudo rm -rf /var/log/k3s

echo -e "\n${GREEN}Uninstallation Complete!${NC}"
echo -e "The following actions have been performed:"
echo -e "1. Uninstalled Flux and removed its configurations"
echo -e "2. Uninstalled K3s"
echo -e "3. Removed kubeconfig"
echo -e "4. Cleaned up all related files and directories"
echo -e "\n${BLUE}Note: You may need to restart your system for all changes to take effect.${NC}"
echo -e "${BLUE}If this was a server node, make sure to run the uninstall script on all agent nodes as well.${NC}" 