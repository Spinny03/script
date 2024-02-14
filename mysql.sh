cd ~
wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster-community-management-server_8.0.36-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-management-server_8.0.36-1ubuntu22.04_amd64.deb

sudo mkdir /var/lib/mysql-cluster

touch /var/lib/mysql-cluster/config.ini

sudo echo
"[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=2	# Number of replicas

[ndb_mgmd]
# Management process options:
hostname=10.10.10.11 # Hostname of the manager
datadir=/var/lib/mysql-cluster 	# Directory for the log files

[ndbd]
hostname=10.10.10.12 # Hostname/IP of the first data node
NodeId=2			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[ndbd]
hostname=10.10.10.13 # Hostname/IP of the second data node
NodeId=3			# Node ID for this data node
datadir=/usr/local/mysql/data	# Remote directory for the data files

[mysqld]
# SQL node options:
hostname=10.10.10.11" > /var/lib/mysql-cluster/config.ini

sudo ndb_mgmd -f /var/lib/mysql-cluster/config.ini

sudo pkill -f ndb_mgmd

sudo echo
"
[Unit]
Description=MySQL NDB Cluster Management Server
After=network.target auditd.service

[Service]
Type=forking
ExecStart=/usr/sbin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/ndb_mgmd.service

sudo systemctl daemon-reload
sudo systemctl enable ndb_mgmd
sudo systemctl start ndb_mgmd

sudo ufw allow from 10.10.10.12
sudo ufw allow from 10.10.10.13

wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.6/mysql-cluster_8.0.36-1ubuntu22.04_amd64.deb-bundle.tar
mkdir install
tar -xvf mysql-cluster_8.0.36-1ubuntu22.04_amd64.deb-bundle.tar -C install/

cd install
sudo apt update
sudo apt install libaio1 libmecab2
sudo dpkg -i mysql-common_8.0.36-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-client_8.0.36-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-client_8.0.36-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-cluster-community-server_8.0.36-1ubuntu22.04_amd64.deb

sudo dpkg -i mysql-server_8.0.36-1ubuntu22.04_amd64.deb

sudo echo 
"!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mysql.conf.d/
[mysqld]
# Options for mysqld process:
ndbcluster                      # run NDB storage engine

[mysql_cluster]
# Options for NDB Cluster processes:
ndb-connectstring=10.10.10.11  # location of management server
"  > /etc/mysql/my.cnf
sudo systemctl restart mysql
sudo systemctl enable mysql


