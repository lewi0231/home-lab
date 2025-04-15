#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}K3s Agent Node Uninstall Script${NC}"
echo "--------------------------------"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    echo "Please do not run as root. This script will use sudo when needed."
    exit 1
fi

# Confirm uninstallation
echo -e "${RED}Warning: This will completely remove K3s agent and all related configurations.${NC}"
read -p "Are you sure you want to proceed? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Uninstallation cancelled."
    exit 1
fi

# Uninstall K3s agent
echo -e "\n${BLUE}Uninstalling K3s agent...${NC}"
if [ -f /usr/local/bin/k3s-agent-uninstall.sh ]; then
    sudo /usr/local/bin/k3s-agent-uninstall.sh
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
echo -e "1. Uninstalled K3s agent"
echo -e "2. Removed kubeconfig"
echo -e "3. Cleaned up all related files and directories"
echo -e "\n${BLUE}Note: You may need to restart your system for all changes to take effect.${NC}" 