#!/bin/bash

# This is based on the docs at 
### https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-plus/#installing-nginx-plus-on-debian-or-ubuntu
### https://docs.nginx.com/nginx-app-protect-dos/deployment-guide/learn-about-deployment/

# This script assumes you are running ubuntu 20.04 have created directory /etc/ssl/nginx
### and have added these two files there: 'nginx-repo.key', 'nginx-repo.crt'

# Quit Nginx in case it is running

# Install prerequisites packages
sudo apt-get update
sudo apt-get install apt-transport-https lsb-release ca-certificates wget gpgv ubuntu-keyring

# Download and add NGINX signing key and App Protect security updates signing key
wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null

# Add the NGINX Plus repository
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list

# Add NGINX App Protect and DOS
printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect.list
printf "deb [signed-by=/usr/share/keyrings/app-protect-security-updates.gpg] https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee -a /etc/apt/sources.list.d/nginx-app-protect.list

# Download the nginx-plus apt configuration to /etc/apt/apt.conf.d:
sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository Information
sudo apt-get update

# Install the nginx-plus package. Any older NGINX Plus package is automatically replaced.
sudo apt-get install -y nginx-plus

# Install NGINX App Protect and its signatures:
sudo apt-get install app-protect app-protect-attack-signatures

# Download and add the NGINX signing key:
sudo wget http://nginx.org/keys/nginx_signing.key && sudo apt-key add nginx_signing.key

# Add NGINX Plus repository and NGINX App Protect DoS repository:
printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
printf "deb https://pkgs.nginx.com/app-protect-dos/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-app-protect-dos.list

# Download the apt configuration to /etc/apt/apt.conf.d:
sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# In case of fresh Installation, update the repository and install the most recent version of the NGINX Plus App Protect DoS package (which includes NGINX Plus):
sudo apt-get update
sudo apt-get install app-protect-dos