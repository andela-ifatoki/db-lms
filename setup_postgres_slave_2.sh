#!/bin/bash

master_ip=$1
postgres_pass=$2
recovery_dir="/var/lib/postgresql/9.6/main"

# Write the necessary configs for continuous data sync to the recovery.conf file.
cat << 'EOF' | sudo tee -a /var/lib/postgresql/9.6/main/recovery.conf >> /dev/null
standby_mode = 'on'
primary_conninfo = 'host=${master_ip} port=5432 user=replicator password=$postgres_pass application_name=pgslave001'
trigger_file = '/var/lib/postgresql/9.6/trigger'
restore_command = 'cp /var/lib/postgresql/9.6/archive/%f "%p"'
EOF

# Swap out variable names with actual variable values and set file owner to postgres
sudo sed -i -e "s/host=\${master_ip}/host=${master_ip}/" ${recovery_dir}/recovery.conf
sudo sed -i -e "s/password=\$postgres_pass/password=$postgres_pass/" ${recovery_dir}/recovery.conf
sudo chown postgres:postgres ${recovery_dir}/recovery.conf
sudo su - postgres -c 'echo -e "\nhost    all             all             10.0.0.32/29           md5" >> /etc/postgresql/9.6/main/pg_hba.conf'

sudo systemctl restart postgresql