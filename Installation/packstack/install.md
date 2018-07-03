
# OpenStack Installation

If you are using non-English locale make sure your /etc/environment is populated:

```bash
$ sudo vi /etc/environment
```

```yaml
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
```

Edit selinux config from enforcing to permissive:

```bash
$ sudo vi /etc/selinux/config
```

```yaml
SELINUX=permissive
```

Prerequisites
If you plan on having external network access to the server and instances, this is a good moment to properly configure your network settings. A static IP address to your network card, and disabling NetworkManager are good ideas.

```bash
$ sudo systemctl disable firewalld
$ sudo systemctl stop firewalld
$ sudo systemctl disable NetworkManager
$ sudo systemctl stop NetworkManager
$ sudo systemctl enable network
$ sudo systemctl start network
```

If your system meets all the prerequisites mentioned below, proceed with running the following commands:
On CentOS:

```bash
$ sudo yum -y install centos-release-openstack-ocata
$ sudo yum -y update
$ sudo reboot
$ sudo yum install -y openstack-packstack
$ sudo packstack --gen-answer-file=answers.txt
$ sudo packstack --answer-file=answers.txt
```

If you encounter failures, see the Workarounds page for tips.
If you have run Packstack previously, there will be a file in your home directory named something like packstack-answers-20130722-153728.txt You will probably want to use that file again, using the --answer-file option, so that any passwords you have already set (for example, mysql) will be reused.
The installer will ask you to enter the root password for each host node you are installing on the network, to enable remote configuration of the host so it can remotely configure each node using Puppet.
Once the process is complete, you can log in to the OpenStack web interface Horizon by going to http://$YOURIP/dashboard. The user name is admin. The password can be found in the file keystonerc_admin in the /root directory of the control node.
