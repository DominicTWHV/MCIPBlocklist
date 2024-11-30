#!/bin/bash

#colorful echo!
RED='\033[0;31m'    # red
GREEN='\033[0;32m'  # green
YELLOW='\033[0;33m' # yellow
BLUE='\033[0;34m'   # blue
NC='\033[0m'        # no color

#function to check and install a package
install_if_missing() {
    if ! dpkg -l | grep -q "$1"; then
        echo -e "${YELLOW}Installing $1...${NC}"
        sudo apt-get install -y -qq "$1"
        echo -e "${GREEN}$1 installed successfully.${NC}"
    else
        echo -e "${BLUE}$1 is already installed.${NC}"
    fi
}

echo -e "${BLUE}Starting script...${NC}"

#check for and install required packages
install_if_missing "ipset"
install_if_missing "iptables"
install_if_missing "iptables-persistent"
install_if_missing "git"

#clone dependency repo
if [ ! -d "Anti_Server_Scanner" ]; then
    echo -e "${YELLOW}Cloning Anti_Server_Scanner repository...${NC}"
    git clone https://github.com/DominicTWHV/Anti_Server_Scanner.git
    echo -e "${GREEN}Anti_Server_Scanner repository cloned.${NC}"
else
    echo -e "${BLUE}Anti_Server_Scanner repository already exists.${NC}"
fi

# Make scripts in Anti_Server_Scanner executable
echo -e "${YELLOW}Setting permissions for scripts in Anti_Server_Scanner...${NC}"
sudo chmod +x Anti_Server_Scanner/*.sh
echo -e "${GREEN}Permissions set.${NC}"

# Copy the block.sh script
cp Anti_Server_Scanner/block.sh block.sh

# Execute block.sh with sudo
echo -e "${RED}Executing block.sh...${NC}"
echo
sudo ./block.sh
echo

#set up systemd and reload
echo -e "${YELLOW}Setting up a service to persist ipset rules...${NC}"
sudo bash -c 'cat << EOF > /etc/systemd/system/ipset-restore.service
[Unit]
Description=restore ipset rules
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/bin/bash -c "/sbin/ipset destroy && /sbin/ipset restore < /etc/ipset.rules"
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF'

echo -e "${GREEN}Service file created at /etc/systemd/system/ipset-restore.service.${NC}"

echo -e "${YELLOW}Reloading systemd daemon and enabling services...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable ipset-restore.service
sudo systemctl enable netfilter-persistent
sudo systemctl start ipset-restore.service
sudo systemctl start netfilter-persistent

echo -e "${GREEN}Setup completed.${NC}"
