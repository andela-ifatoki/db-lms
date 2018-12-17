#!/bin/bash

master_ip=$1
# Download and install postgresql
install_postgres() {
  # add the Postgres 9.6 repository to the source.list.d directory
  echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' | sudo tee -a /etc/apt/sources.list.d/postgresql.list
  # Dowload PostgresSQL key to the system
  wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
  # Update the system repository
  sudo apt-get update
  # Install the PostgresSQL 9.6 package
  sudo apt-get install -y postgresql-9.6
}

configure_postgres() {
  # Get the machines internal IP address 
  export ip=`/sbin/ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
  export main_dir="/etc/postgresql/9.6/main"
  export postgres_main_dir="/var/lib/postgresql/9.6/main"

  # Write configurations to postgresql.conf file
  sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '$ip'/" ${main_dir}/postgresql.conf
  sudo sed -i -e "s/#wal_level = minimal/wal_level = hot_standby/" ${main_dir}/postgresql.conf
  sudo sed -i -e "s/#synchronous_commit = on/synchronous_commit = local/" ${main_dir}/postgresql.conf
  sudo sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 3/" ${main_dir}/postgresql.conf
  sudo sed -i -e "s/#wal_keep_segments = 0/wal_keep_segments = 32/" ${main_dir}/postgresql.conf
  sudo sed -i -e "s/#synchronous_standby_names = ''/synchronous_standby_names = 'pgslave001'/" ${main_dir}/postgresql.conf
  sudo sed -i -e "s/#hot_standby = off/hot_standby = on/" ${main_dir}/postgresql.conf

  # Remove and recreate a main directory
  sudo mv $postgres_main_dir ${postgres_main_dir}_backup
  sudo su - postgres -c "mkdir $postgres_main_dir; chmod 700 $postgres_main_dir"
  
  # Copy main directory from master
  sudo su - postgres -c "pg_basebackup -h $master_ip -U replicator -D $postgres_main_dir -P --xlog"
}


main () {
  install_postgres
  configure_postgres
}

main