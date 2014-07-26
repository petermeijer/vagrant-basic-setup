#!/bin/bash

echo "$(tput setaf 2)---Hi there! Just grab a cup of coffee while I prepare your LAMP stack---$(tput sgr 0)"

echo "$(tput setaf 2)---Updating operating system---$(tput sgr 0)"
apt-get update 
apt-get upgrade 

echo "$(tput setaf 2)---Installing basic applications---$(tput sgr 0)"
apt-get install python-software-properties build-essential debconf-utils vim curl htop -y 

echo "$(tput setaf 2)---Installing MySQL---$(tput sgr 0)"
debconf-set-selections <<< "mysql-server mysql-server/root_password password development"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password development"
apt-get install mysql-server -y 

echo "$(tput setaf 2)---Adding the bleeding edge of PHP to the repository---$(tput sgr 0)"
apt-get install python-software-properties build-essential -y 
add-apt-repository ppa:ondrej/php5 -y 
apt-get update 

echo "$(tput setaf 2)---Installing Apache2, PHP5.5 and PHP specific packages---$(tput sgr 0)"
apt-get install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql -y 

# enable error reporting by default
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "$(tput setaf 2)---Enabling mod-rewrite---$(tput sgr 0)"
sudo a2enmod rewrite

echo "ServerName localhost" | sudo tee -a /etc/apache2/apache2.conf

echo "$(tput setaf 2)---Syncing the vhost---$(tput sgr 0)"
sudo cp /vagrant/provision/apache2/vhost.conf /etc/apache2/sites-available/000-default.conf
sudo rm -rf /var/www/html

# restart apache2 to load the new settings
sudo service apache2 restart

echo "$(tput setaf 2)---Installing Xdebug, every developer needs debugging tools!---$(tput sgr 0)"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "$(tput setaf 2)---Installing Composer. You will love it!---$(tput sgr 0)"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "$(tput setaf 2)---Finished provisioning. Now go build something awesome!---$(tput sgr 0)"