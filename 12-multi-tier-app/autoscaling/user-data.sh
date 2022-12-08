#!/bin/bash -x
sed -i "39i\$nrconf{restart} = 'a';" /etc/needrestart/needrestart.conf
add-apt-repository ppa:ondrej/php -y
apt-get update -y
apt-get install nginx software-properties-common -y
systemctl start nginx
systemctl enable nginx
apt-get install -y --no-install-recommends php7.4
apt-get install -y php7.4-mbstring php7.4-xml php7.4-bcmath php7.4-fpm php7.4-mysql
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 8M/' /etc/php/7.4/cli/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 700M/' /etc/php/7.4/cli/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 8M/' /etc/php/7.4/fpm/php.ini
sed -i 's/memory_limit = 128M/memory_limit = -1/' /etc/php/7.4/fpm/php.ini
apt-get install -y ruby-full ruby-webrick wget curl
curl https://getcomposer.org/download/2.3.7/composer.phar --output /usr/bin/composer && chmod +x /usr/bin/composer
wget https://aws-codedeploy-ap-southeast-2.s3.ap-southeast-2.amazonaws.com/releases/codedeploy-agent_1.3.2-1902_all.deb
mkdir codedeploy-agent_1.3.2-1902_ubuntu22
dpkg-deb -R codedeploy-agent_1.3.2-1902_all.deb codedeploy-agent_1.3.2-1902_ubuntu22
sed 's/Depends:.*/Depends:ruby3.0/' -i ./codedeploy-agent_1.3.2-1902_ubuntu22/DEBIAN/control
dpkg-deb -b codedeploy-agent_1.3.2-1902_ubuntu22/
dpkg -i codedeploy-agent_1.3.2-1902_ubuntu22.deb
/lib/systemd/systemd-sysv-install enable codedeploy-agent
