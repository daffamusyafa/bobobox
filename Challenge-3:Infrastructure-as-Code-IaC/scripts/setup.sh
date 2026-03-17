#!/bin/bash
# Update package dan install Nginx
apt-get update -y
apt-get install -y nginx

# Membuat halaman Hello OpenTofu
echo "<html><body><h1>Hello, OpenTofu! Deployed for Bobobox</h1></body></html>" > /var/www/html/index.html

# Pastikan Nginx jalan
systemctl enable nginx
systemctl start nginx
