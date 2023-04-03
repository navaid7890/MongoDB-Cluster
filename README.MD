# MongoDB Cluster Deployment using Docker

This is a sample docker-compose.yml file that deploys a MongoDB cluster using Docker. The cluster consists of three MongoDB nodes, each running in a separate Docker container.

## Prerequisites

To use this docker-compose.yml file, you need to have the following software installed on your machine:

- Docker
- Docker Compose

## Getting Started

1- Clone this repository to your local machine:

`git clone https://github.com/navaid7890/MongoDB-Cluster.git`

2- Navigate to the cloned directory:

`cd MongoDB-Cluster`

3- Modify the mongod.conf file to suit your needs. This file contains the MongoDB configuration settings for each node in the cluster.

For example, the following configuration file specifies the location of the MongoDB log file, the location of the MongoDB data directory, and the MongoDB security settings:

```YAML
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
```

4- Modify the setup.sh file to suit your needs. This file contains the commands that are executed when the first node is started. You can use this file to configure the replica set and create a MongoDB admin user.

For example, the following script initializes the replica set with the name **NavaidBlog**, and creates a MongoDB admin user with the username **admin** and password **Admin123@**

```bash
#!/bin/bash

mongo <<EOF
   var cfg = {
        "_id": "NavaidBlog",
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
```

5- Generate a MongoDB keyfile using the openssl command:

`openssl rand -base64 741 > mongo.key`

6- Start the MongoDB cluster using Docker Compose:

`docker-compose up -d`
This command starts the MongoDB nodes in the background.

7- Connect to the MongoDB cluster using the mongo shell:

`mongo --host localhost:30000`
This command connects to the MongoDB cluster using the first node's hostname and port.

8- Run the setup.sh script to configure the replica set and create the MongoDB admin user:

`chmod +x setup.sh`
`./setup.sh`
This command executes the setup.sh script in the first node's container.

9- Verify that the MongoDB replica set is up and running using the rs.status() command:
`rs.status()`
This command displays the current status of the MongoDB replica set.

## Conclusion
You have successfully deployed a MongoDB cluster using Docker. You can now use this cluster for your MongoDB applications. If you need to scale your cluster, you can modify the docker-compose.yml file to add more MongoDB nodes.