This repository contains code for the setup of a Postgresql Database Cluster with a Master server and 2 replicas. It also uses HAProxy to implement loadbalancing and monitoring within the cluster.

## TECHNOLOGY STACK

The following technologies were used in the set up:

* [Google Cloud](https://console.cloud.google.com): The whole infrastructure for the project is built on Google Cloud.
* [Terraform](https://www.terraform.io/): Terraform makes it easy to spin up and tear down complex infrastructure. It does this through Infrastructure As Code (IAC). The infrastructure for this project is built with Terraform.
* [Postgres](https://www.postgresql.org/about/): Postgres is an extensible Object Relation Database Management System (ORDBMS). The databases used in this project are Postgres databases.
* [HAProxy](http://www.haproxy.org/): HAProxy is a free, fast, and efficient open source software that provides high availability loadbalancing and proxy servers for TCP and HTTP-based applications. HAProxy is used to loadbalance and monitor the cluster.

## The Project
This project was built for automated deployments to the Google Cloud Compute Engine using Terraform and shell scripts written to help configure and deploy the database cluster. HAProxy triples as the NAT gateway, loadbalancer and monitoring server. 
To begin, ensure you have terraform installed on your computer. You can check by running `terraform -v`. If you have it installed, you'd find details about your current version of terraform. Else, please download and install terraform to your computer from [here](https://www.terraform.io/downloads.html). Then proceed with the below steps.
### Infrastructure
1. Run `git clone https://github.com/andela-ifatoki/db-lms.git; cd db-lms;`
2. Run `cp terraform.tfvars.sample terraform.tfvars` This creates a copy of the **terraform.tfvars.sample** file and renames it to **terraform.tfvars**
3. Now populate the fields in file **terraform.tfvars**. These include:
  * project
  * region
  * zone
  * password
  * slave-cluster-ip-range
4. Go over to your Google Cloud Account and request to download your service key. Download it to your computer and add a copy of the key to the terraform directory.
5. Open a shell session and navigate to the terraform directory
6. Run `terraform init`
7. To begin checking out what our infrastructure would create, run `terraform plan`
8. To deploy the infrastructure, run `terraform apply` and respond `yes` when requested for confirmation.

This would run through all the terraform configuration and IaC files, deploying them as is in GCP and returning a report of what was/wasn't created. 

### Configuration
As part of the infrastructure setup, the master database, nat gateway and loadbalancer have all been automatically configured hence why you can already check out the infrastructure monitor. In my own instance, [here](http://35.246.130.23:7000/)

Next, to configure the slave servers, ensure you have gcloud command line tool installed on your computer. If you don't please find it [here](https://cloud.google.com/sdk/install). Once ready, follow these steps for each of the slaves:
1. `gcloud compute ssh instance-lms-nat`
2. Once in, run `gcloud beta compute ssh instance-lms-slave-1 --internal-ip` or `gcloud beta compute ssh instance-lms-slave-2 --internal-ip` to get ssh access into the slave server.
3. run `sudo su -` to change to the root user.
4. run `cd /home/ubuntu/db-lms` to change the current directory.
5. run `. setup_postgres_slave.sh <master-db-ip>` pass the masters ip address as a parameter to the setup_postgres_slave script.
6. when it prompts for a password, type in the password that you entered in the *terraform.tfvars* file
7. run `. setup_postgres_slave_2.sh <master-db-ip> <password>` pass the masters ip address and the password (same as above) to the setup_postgres_slave_2 script.
### Testing
To test the service if its properly setup,
1. SSH into the master db and run the commands.
  * `sudo su - postgres; psql;`
  * `CREATE TABLE test_table (hakase varchar(200));`
  * `INSERT INTO test_table VALUES ('It is a test');`
  * `INSERT INTO test_table VALUES ('This is from Master');`
2. SSH into any of the slaves and run the commands.
  * `sudo su - postgres; psql;`
  * `select * from test_table;`
  This should return the 2 values added previously in the master db.