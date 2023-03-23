#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2

sudo ufw enable
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

sudo cat > /var/www/html/index.html << EOF
<html>
<head>
  <title> Test ALB </title>
</head>
<body>
  <p>We are doing our best.</p>
</body>
</html>
EOF