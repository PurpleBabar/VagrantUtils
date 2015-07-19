#!/bin/bash

# Defining variables
host="dev.$1"

host_name="$1"

host_file="vhosts/$1.conf"

conf_file="$1.conf"

# Testing if host exists
if [ -f $host_file ];
then
   echo "Host $host_file already exists"
   exit
else
   echo "Creating new host : $host_name..."
fi

# Testing if projects directory exists
if [ -d "projects" ];
then
   echo "Projects directory ok..."
else
   mkdir projects
   chmod 777 projects
fi


# Starting creation
printf "\n192.168.42.42 $host" >> /etc/hosts
echo "New host added : $host..."

# Creating Host File in vhosts
touch $host_file

chmod 777 $host_file

printf "# This tells Apache that you will be using name-based vhosts on port 80" >> $host_file
printf "\n# Note: Only required when using Apache version 2.2.x or lower" >> $host_file
echo "Writing comments..."
echo "Init..."
echo "Creating Virtual Host"
printf "\n<VirtualHost *:80>" >> $host_file
echo "Creating Virtual Host..."
# Init ServerAdmin
echo "Please enter ServerAdmin mail:"
read server_admin
printf "\n  ServerAdmin $server_admin" >> $host_file
echo "Writing ServerName : $host..."
printf "\n  ServerName $host" >> $host_file
# Init Project Path
project_path="/home/vagrant/share/$host_name"

echo "Writing DocumentRoot : $project_path..."
# Completing Project Path
echo "Kind of project [Symfony, Twiger]:"
read $kind
if [[ "$kind" = "Symfony" ]];
then
  project_path="$project_path/web"
fi
printf "\n  DocumentRoot $project_path" >> $host_file
printf "\n  <Directory $project_path>" >> $host_file
printf "\n    Options Indexes FollowSymlinks MultiViews" >> $host_file
printf "\n    AllowOverride All" >> $host_file
printf "\n    Order allow,deny" >> $host_file
printf "\n    Allow from all" >> $host_file
printf "\n  </Directory>" >> $host_file
printf "\n</VirtualHost>" >> $host_file

# Update commands to vagrant
sudo -u alexandrelalung vagrant ssh -- -t "cd /etc/apache2/sites-available; sudo a2ensite $conf_file; sudo service apache2 reload"
