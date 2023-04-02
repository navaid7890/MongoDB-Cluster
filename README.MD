MongoDB Cluster Deployment using Docker
This is a sample docker-compose.yml file that deploys a MongoDB cluster using Docker. The cluster consists of three MongoDB nodes, each running in a separate Docker container.

Prerequisites
To use this docker-compose.yml file, you need to have the following software installed on your machine:

Docker
Docker Compose
Getting Started
Clone this repository to your local machine:

bash
Copy code
git clone <repository-url>
Navigate to the cloned directory:

bash
Copy code
cd <cloned-directory>
Modify the mongod.conf file to suit your needs. This file contains the MongoDB configuration settings for each node in the cluster.

For example, the following configuration file specifies the location of the MongoDB log file, the location of the MongoDB data directory, and the MongoDB security settings:

yaml
Copy code
systemLog:
  verbosity: 0
  destination: file
  path: /root/logs/mongod.log
  timeStampFormat: iso8601-utc
storage:
  directoryPerDB: true
  dbPath: /root/data
  engine: wiredTiger
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
  journal:
    enabled: true
processManagement:
  fork: true
net:
  port: 27017
  bindIp: 0.0.0.0
security:
  authorization: enabled
Modify the setup.sh file to suit your needs. This file contains the commands that are executed when the first node is started. You can use this file to configure the replica set and create a MongoDB admin user.

For example, the following script initializes the replica set with the name xelerate, and creates a MongoDB admin user with the username admin and password Admin123@:

php
Copy code
#!/bin/bash

mongo <<EOF
   var cfg = {
        "_id": "xelerate",
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "mongo-0:27017",
                "priority": 2
            },
            {
                "_id": 1,
                "host": "mongo-1:27017",
                "priority": 0
            },
            {
                "_id": 2,
                "host": "mongo-2:27017",
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.status();
EOF

sleep 10

mongo <<EOF
   use admin;
   admin = db.getSiblingDB("admin");
   admin.createUser(
     {
      user: "admin",
      pwd: "Admin123@",
      roles: [ { role: "root", db: "admin" } ]
     });
     db.getSiblingDB("admin").auth("admin", "Admin123@");
     rs.status();
EOF
Generate a MongoDB keyfile using the openssl command:

bash
Copy code
openssl rand -base64 741 > mongo.key
Start the MongoDB cluster using Docker Compose:

Copy code
docker-compose up -d
This command starts the MongoDB nodes in the background.

Connect to the MongoDB cluster using the mongo shell:

css
Copy code
mongo --host localhost:30000