#!/bin/bash

clear
yum install epel-release -y
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -Uvh remi-release-6*.rpm

cat > /etc/yum.repos.d/remi.repo <<EOL

# Repository: http://rpms.remirepo.net/
# Blog:       http://blog.remirepo.net/
# Forum:      http://forum.remirepo.net/

[remi]
name=Remi's RPM repository for Enterprise Linux 6 - $basearch
#baseurl=http://rpms.remirepo.net/enterprise/6/remi/$basearch/
mirrorlist=http://rpms.remirepo.net/enterprise/6/remi/mirror
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-php55]
name=Remi's PHP 5.5 RPM repository for Enterprise Linux 6 - $basearch
#baseurl=http://rpms.remirepo.net/enterprise/6/php55/$basearch/
mirrorlist=http://rpms.remirepo.net/enterprise/6/php55/mirror
# NOTICE: common dependencies are in "remi-safe"
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-php56]
name=Remi's PHP 5.6 RPM repository for Enterprise Linux 6 - $basearch
#baseurl=http://rpms.remirepo.net/enterprise/6/php56/$basearch/
mirrorlist=http://rpms.remirepo.net/enterprise/6/php56/mirror
# NOTICE: common dependencies are in "remi-safe"
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-test]
name=Remi's test RPM repository for Enterprise Linux 6 - $basearch
#baseurl=http://rpms.remirepo.net/enterprise/6/test/$basearch/
mirrorlist=http://rpms.remirepo.net/enterprise/6/test/mirror
# WARNING: If you enable this repository, you must also enable "remi"
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-debuginfo]
name=Remi's RPM repository for Enterprise Linux 6 - $basearch - debuginfo
baseurl=http://rpms.remirepo.net/enterprise/6/debug-remi/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-php55-debuginfo]
name=Remi's PHP 5.5 RPM repository for Enterprise Linux 6 - $basearch - debuginfo
baseurl=http://rpms.remirepo.net/enterprise/6/debug-php55/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-php56-debuginfo]
name=Remi's PHP 5.6 RPM repository for Enterprise Linux 6 - $basearch - debuginfo
baseurl=http://rpms.remirepo.net/enterprise/6/debug-php56/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

[remi-test-debuginfo]
name=Remi's test RPM repository for Enterprise Linux 6 - $basearch - debuginfo
baseurl=http://rpms.remirepo.net/enterprise/6/debug-test/$basearch/
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi

EOL




echo 'Going to install the LAMP stack on your machine, here we go...'
echo '------------------------'
read -p "MySQL Password: " mysqlPassword
read -p "Retype password: " mysqlPasswordRetype

yum install -y  httpd php mysql mysql-server php-cli php-dev php-fpm php-cgi php-mysql php-xmlrpc php-curl php-gd php-apc php-pear php-imap php-mcrypt php-pspell phpmyadmin

chkconfig mysql-server on
chkconfig httpd on

/etc/init.d/mysqld restart

while [[ "$mysqlPassword" = "" && "$mysqlPassword" != "$mysqlPasswordRetype" ]]; do
  echo -n "Please enter the desired mysql root password: "
  stty -echo
  read -r mysqlPassword
  echo
  echo -n "Retype password: "
  read -r mysqlPasswordRetype
  stty echo
  echo
  if [ "$mysqlPassword" != "$mysqlPasswordRetype" ]; then
    echo "Passwords do not match!"
  fi
done

/usr/bin/mysqladmin -u root password $mysqlPassword


clear
echo 'Okay.... apache, php and mysql & Phpmyadinis installed, running and set to your desired password'
echo 'Edit /etc/httpd/conf.d/phpMyadmin.conf for allo IPs'
