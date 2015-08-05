#!/bin/bash
## usage: cmd 01 03
for i in n{$1..$2}; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6/etc/

wwsh -y file import /etc/ssh/ssh_known_hosts
wwsh -y provision set --fileadd ssh_known_hosts
wwsh file sync


## rebuild image or sync file to take effect on compute nodes
