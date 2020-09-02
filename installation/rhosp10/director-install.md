# INSTALLING THE UNDERCLOUD

## Creating a Director Installation User

The director installation process requires a non-root user to execute commands. Use the following commands to create the user named stack and set a password:

```bash
# useradd stack
# passwd stack  
```

Disable password requirements for this user when using sudo:

```bash
# echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack
# chmod 0440 /etc/sudoers.d/stack
```

Switch to the new stack user:

```bash
# su - stack
```

Continue the director installation as the stack user.

## Creating Directories for Templates and Images

The director uses system images and Heat templates to create the overcloud environment. To keep these files organized, we recommend creating directories for images and templates:

```bash
$ mkdir ~/images
$ mkdir ~/templates
```

Other sections in this guide use these two directories to store certain files.

## Setting the Hostname for the System

The director requires a fully qualified domain name for its installation and configuration process. This means you may need to set the hostname of your director’s host. Check the hostname of your host:

```bash
$ hostname    
$ hostname -f
```

If either commands do not report the correct hostname or report an error, use hostnamectl to set a hostname:

```bash
$ sudo hostnamectl set-hostname director.example.com
$ sudo hostnamectl set-hostname --transient manager.example.com
```

The director also requires an entry for the system’s hostname and base name in /etc/hosts. For example, if the system is named manager.example.com, then /etc/hosts requires an entry like:

```yaml
127.0.0.1   manager.example.com manager localhost localhost.localdomain localhost4 localhost4.localdomain4
```

## Registering your System

To install the Red Hat OpenStack Platform director, first register the host system using Red Hat Subscription Manager, and subscribe to the required channels.

Register your system with the Content Delivery Network, entering your Customer Portal user name and password when prompted:

```bash
$ sudo subscription-manager register
```

Find the entitlement pool ID for Red Hat OpenStack Platform director. For example:

```bash
$ sudo subscription-manager list --available --all --matches="*OpenStack*"
$ sudo subscription-manager attach --pool=Valid-Pool-Number-123456
```

Disable all default repositories, and then enable the required Red Hat Enterprise Linux repositories:

```bash
$ sudo subscription-manager repos --disable=*
$ sudo subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-rh-common-rpms --enable=rhel-ha-for-rhel-7-server-rpms --enable=rhel-7-server-openstack-10-rpms
```

These repositories contain packages the director installation requires.

Perform an update on your system to make sure you have the latest base system packages:

```bash
$ sudo yum update -y
$ sudo reboot
```

The system is now ready for the director installation.

## Installing the Director Packages

Use the following command to install the required command line tools for director installation and configuration:

```bash
$ sudo yum install -y python-tripleoclient
```

This installs all packages required for the director installation.

## Configuring the Director

The director installation process requires certain settings to determine your network configurations. The settings are stored in a template located in the stack user’s home directory as undercloud.conf.

Red Hat provides a basic template to help determine the required settings for your installation. Copy this template to the stack user’s home directory:

```bash
$ cp /usr/share/instack-undercloud/undercloud.conf.sample ~/undercloud.conf
```

The undercloud.conf file contains settings to configure your undercloud. If you omit or comment out a parameter, the undercloud installation uses the default value.

There is a tool available that can help with writing a basic undercloud.conf: [Undercloud Configuration Wizard](http://ucw.tripleo.org/) It takes some basic information about the intended overcloud environment and generates sane values for a number of the important options.

Modify the values for these parameters to suit your network. When complete, save the file and run the following command:

```bash
$ openstack undercloud install
```

The configuration also starts all OpenStack Platform services automatically. Check the enabled services using the following command:

```bash
$ sudo systemctl list-units openstack-*
```

To initialize the stack user to use the command line tools, run the following command:

```bash
$ source ~/stackrc
```

You can now use the director’s command line tools.

## Obtaining Images for Overcloud Nodes

Obtain these images from the rhosp-director-images and rhosp-director-images-ipa packages:

```bash
$ sudo yum install rhosp-director-images rhosp-director-images-ipa
```

Extract the archives to the images directory on the stack user’s home (/home/stack/images):

```bash
$ cd ~/images
$ for i in /usr/share/rhosp-director-images/overcloud-full-latest-10.0.tar /usr/share/rhosp-director-images/ironic-python-agent-latest-10.0.tar; do tar -xvf $i; done
```

Import these images into the director:

```bash
$ openstack overcloud image upload --image-path /home/stack/images/
```

View a list of the images in the CLI:

```bash
$ openstack image list
```

```yaml
+--------------------------------------+------------------------+
| ID                                   | Name                   |
+--------------------------------------+------------------------+
| 765a46af-4417-4592-91e5-a300ead3faf6 | bm-deploy-ramdisk      |
| 09b40e3d-0382-4925-a356-3a4b4f36b514 | bm-deploy-kernel       |
| ef793cd0-e65c-456a-a675-63cd57610bd5 | overcloud-full         |
| 9a51a6cb-4670-40de-b64b-b70f4dd44152 | overcloud-full-initrd  |
| 4f7e33f4-d617-47c1-b36f-cbe90f132e5d | overcloud-full-vmlinuz |
+--------------------------------------+------------------------+
```

This list will not show the introspection PXE images. The director copies these files to /httpboot.

```bash
[stack@host1 ~]$ ls -l /httpboot
```

```yaml
total 341460
-rwxr-xr-x. 1 root root   5153184 Mar 31 06:58 agent.kernel
-rw-r--r--. 1 root root 344491465 Mar 31 06:59 agent.ramdisk
-rw-r--r--. 1 root root       337 Mar 31 06:23 inspector.ipxe
```

## Setting a Nameserver on the Undercloud’s Neutron Subnet

Overcloud nodes require a nameserver so that they can resolve hostnames through DNS. For a standard overcloud without network isolation, the nameserver is defined using the undercloud’s neutron subnet. Use the following commands to define nameservers for the environment:

```bash
$ openstack subnet list
$ openstack subnet set --dns-nameserver [nameserver1-ip] --dns-nameserver [nameserver2-ip] [subnet-uuid]
```

View the subnet to verify the nameserver:

```bash
$ openstack subnet show [subnet-uuid]
```

```yaml
+-------------------+-----------------------------------------------+
| Field             | Value                                         |
+-------------------+-----------------------------------------------+
| ...               |                                               |
| dns_nameservers   | 8.8.8.8                                       |
| ...               |                                               |
+-------------------+-----------------------------------------------+
```
