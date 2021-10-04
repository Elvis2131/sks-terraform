#!/bin/bash
sudo apt update -y && sudo apt upgrade -y
cd /var/www/sokoshopper/sks-backend-api
sudo git checkout master && sudo git pull
pm2 start bin/server.js