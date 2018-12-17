#!/bin/bash

postgres_pass=$1

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

#Make master DB file configurations
configure_postgres() {
  # Get the machines internal IP address
  export ip=`/sbin/ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
  export dir="/etc/postgresql/9.6/main/postgresql.conf"
  export archive_dir="/var/lib/postgresql/9.6/main/archive/"

  # Write configurations to postgresql.conf file
  sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '$ip'/" $dir
  sudo sed -i -e "s/#wal_level = minimal/wal_level = hot_standby/" $dir
  sudo sed -i -e "s/#synchronous_commit = on/synchronous_commit = local/" $dir
  sudo sed -i -e "s/#max_wal_senders = 0/max_wal_senders = 3/" $dir
  sudo sed -i -e "s/#wal_keep_segments = 0/wal_keep_segments = 32/" $dir
  sudo sed -i -e "s/#archive_mode = off/archive_mode = on/" $dir
  sudo sed -i -e "s/#archive_command = ''/archive_command = 'cp %p \/var\/lib\/postgresql\/9.6\/archive\/%f'/" $dir
  sudo sed -i -e "s/#synchronous_standby_names = ''/synchronous_standby_names = 'pgslave001'/" $dir

  # Change archive directory
  sudo mkdir -p $archive_dir
  sudo chmod 700 $archive_dir
  sudo chown -R postgres:postgres $archive_dir

  # Restart the postgres server
  sudo systemctl restart postgresql

  # Create replication user
  sudo su postgres -c "psql -c \"CREATE ROLE replicator WITH REPLICATION PASSWORD '${postgres_pass}' LOGIN;\"; exit"

  # Edit the /etc/postgresql/9.6/main/pg_hba.conf inorder to allow the IP that can connect to it
  # Allow the replicator user from the slave IP address range access to the replicator table on the master.
  sudo su - postgres -c 'echo -e "\nhost    all             all             10.0.0.32/29           md5" >> /etc/postgresql/9.6/main/pg_hba.conf'
  sudo su - postgres -c 'echo -e "\nhost    replication             replicator             10.0.0.0/27           md5" >> /etc/postgresql/9.6/main/pg_hba.conf'

  # Restart the postgres server
  sudo systemctl restart postgresql
}


main () {
  install_postgres
  configure_postgres
}

main