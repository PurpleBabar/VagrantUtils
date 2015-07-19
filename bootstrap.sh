#!/usr/bin/env bash

echo "checking updates"
apt-get update
echo "updates checked"

PKG="php5"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
        sudo apt-get --force-yes --yes install $PKG
fi

PKG="apache2"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	sudo apt-get --force-yes --yes install $PKG
	sudo apt-get --force-yes --yes install php-apc
	sudo apt-get --force-yes --yes install php5-curl
	sudo apt-get --force-yes --yes install php5-memcache
	sudo apt-get --force-yes --yes install php5-xsl
    sudo apt-get --force-yes --yes install php5-intl    
fi

PKG="mysql-server"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
	sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
	sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'
	sudo apt-get --force-yes --yes install $PKG
fi

PKG="php5-gd"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt-get --force-yes --yes install $PKG
fi

PKG="phpmyadmin"
DBPASSWD="123"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
    sudo apt-get --force-yes --yes install $PKG
    sudo chmod 666 /etc/apache2/apache2.conf
    echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
    sudo chmod 644 /etc/apache2/apache2.conf
    sudo a2enmod rewrite
    sudo /etc/init.d/apache2 restart
fi

PKG="git"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt-get --force-yes --yes install $PKG
fi

PKG="emacs"
if [ $(dpkg-query -W -f='${Status}' $PKG 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    sudo apt-get --force-yes --yes install $PKG
fi

if [ $(node -v 2>/dev/null | grep -c "v") -eq 0 ];
then
    sudo apt-get --force-yes --yes install python g++ wget libssl-dev
    mkdir /tmp/nodejs && cd /tmp/nodejs
    wget http://nodejs.org/dist/node-latest.tar.gz
    tar xzvf node-latest.tar.gz && cd node-v*
    ./configure
    make
    make install
    cd ~
    rm -rf /tmp/nodejs
fi

if [ $(aptitude show php5-xdebug 2> /dev/null | grep -c "Description") -eq 0 ];
then
    sudo apt-get install -y php-gear php5-dev
    sudo /usr/bin/pecl install xdebug
    sudo /bin/echo "zend_extension=/usr/lib/php5/20060613/xdebug.so" | sudo /usr/bin/tee /etc/php5/conf.d/xdebug.ini
    sudo /etc/init.d/apache2 restart
fi

sudo apt-get --force-yes --yes install imagemagick
sudo apt-get --force-yes --yes install openjdk-7-jre
sudo apt-get --force-yes --yes install pstotext
sudo apt-get install supervisor

sudo rm -rf /var/www
sudo ln -fs /home/vagrant/share /var/www