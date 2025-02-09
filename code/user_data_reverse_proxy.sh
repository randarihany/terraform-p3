#!/bin/bash
apt-get update
apt-get install -y nginx
echo "server {
    listen 80;
    location / {
        proxy_pass http://${module.private_alb.alb_dns_name};
    }
}" > /etc/nginx/sites-available/default
systemctl restart nginx