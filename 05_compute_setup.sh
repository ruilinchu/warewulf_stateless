#!/bin/bash

## install gcc to compute nodes 
yum --tolerant --installroot /var/chroots/centos-6 -y install `paste -s compute_node_yum_list`

## configure munge
create-munge-key
chkconfig munge on
service munge start
echo testing  munge ...
munge -n | unmunge 

cp /etc/munge/munge.key /var/chroots/centos-6/etc/munge/munge.key

cat >> /var/chroots/centos-6/etc/rc.local << EOF
chkconfig munge on
service munge start
EOF

## install Lmod in /opt, copy script to /etc and image /etc

## 

## rebuild image 
#wwvnfs -y --chroot /var/chroots/centos-6
