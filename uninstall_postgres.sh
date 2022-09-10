sudo apt-get --purge remove postgresql\*
sudo rm -rf /etc/postgresql
sudo rm -rf /etc/postgresql-common
sudo rm -rf /var/lib/postgresql
sudo userdel -r postgres
sudo groupdel postgres
