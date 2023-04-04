#!/bin/bash

mongosh <<EOF
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
    //rs.reconfig(cfg, { force: true });
    rs.status();
EOF
sleep 10

mongosh <<EOF
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
