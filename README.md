* warewulf_stateless_provision
* centos-6.6 x86_64
* warewulf 3.6
* stateless provision
* passwd free ssh for all user across all nodes
* /home, /opt, /usr/local are NFS mounted from master node
* Lmod module environment
* Slurm job scheduler

To make yourself a warewulf Linux cluster, do 

1. configure eth0 as DHCP and eth1 static internal on master node, bring up network
2. run scripts in order, no input needed
3. you have a warewulf cluster!
