#!/bin/bash

yum install gmp-devel mpfr-devel libmpc-devel rpm-build redhat-rpm-config
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

## slurm
wget -P ~/rpmbuild/SOURCES https://github.com/SchedMD/slurm/archive/slurm-14-11-8-1.tar.gz
cd ~/rpmbuild/SOURCES
## you can also do rpmbuild -ta slurm*.gz and rpm install the rpm
## configuration guide can also be figured out from the slurm.spec file inside tar file
# centos-7 uses: systemctl start xxx.service instead of service
tar xvzf slurm-14-11-8-1.tar.gz
cd slurm-slurm-14-11-8-1
./configure --prefix=/opt/slurm/14.11.8 --sysconfdir=/opt/slurm/14.11.8/etc
make 
make install
## sample scripts for deamon service and configuration
##cp -r etc /opt/slurm/14.11.8/
if [ -d /etc/init.d ]; then
  install -D -m755 etc/init.d.slurm    /etc/init.d/slurm
  install -D -m755 etc/init.d.slurmdbd /etc/init.d/slurmdbd
  mkdir -p "/usr/sbin"
  ln -s /etc/init.d/slurm    /usr/sbin/rcslurm
  ln -s /etc/init.d/slurmdbd /usr/sbin/rcslurmdbd
fi
## this is for centos-7
if [ -d /usr/lib/systemd/system ]; then
  install -D -m755 etc/slurmctld.service /usr/lib/systemd/system/slurmctld.service
  install -D -m755 etc/slurmd.service    /usr/lib/systemd/system/slurmd.service
  install -D -m755 etc/slurmdbd.service  /usr/lib/systemd/system/slurmdbd.service
fi

install -D -m644 etc/slurm.conf.example /opt/slurm/14.11.8/etc/slurm.conf.example
install -D -m644 etc/cgroup.conf.example /opt/slurm/14.11.8/etc/cgroup.conf.example
install -D -m644 etc/cgroup_allowed_devices_file.conf.example /opt/slurm/14.11.8/etc/cgroup_allowed_devices_file.conf.example
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup.release_common.example
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_freezer
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_cpuset
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_memory
install -D -m644 etc/slurmdbd.conf.example /opt/slurm/14.11.8/etc/slurmdbd.conf.example
install -D -m755 etc/slurm.epilog.clean /opt/slurm/14.11.8/etc/slurm.epilog.clean
install -D -m755 contribs/sgather/sgather /opt/slurm/14.11.8/bin/sgather
install -D -m755 contribs/sjstat /opt/slurm/14.11.8/bin/sjstat
##start slurmd on compute nodes and slurmctld on master node on boot

## you will need to configure file slurm.conf using the html tool in doc folder under install directory

## new gcc
wget ‐P ~/rpmbuild/SOURCES http://mirrors.concertpass.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz
cp rpm_specs/* ~/rpmbuild/SPECS
## rpmbuild using gcc spec file, replace the HMS with your own name in SPEC file
rpmbuild -ba ~/rpmbuild/SPECS/gcc-5.2.0.spec
##rpm -ivh ~/rpmbuild/RPMS/x86_64/gcc-5.2.*.rpm

## openmpi, configed to do srun in slurm
wget -P ~/rpmbuild/SOURCES http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.8.tar.gz
rpmbuild -ba ~/rpmbuild/SPECS/openmpi-1.8.8.spec
##rpm -ivh ~/rpmbuild/RPMS/x86_64/openmpi-1.8*.rpm
## now we can kick start the app stack and module tree
