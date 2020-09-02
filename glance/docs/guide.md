Upload the image to the Image service using the QCOW2 disk format, bare container format, and public visibility so all projects can access it:

CentOS 6

```bash
# wget http://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud-20141129_01.qcow2
# openstack image create --disk-format qcow2 --container-format bare --public --file CentOS-6-x86_64-GenericCloud-20141129_01.qcow2 CentOS-6-x86_64
```

CentOS 7

```bash
# wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1608.qcow2
# openstack image create --disk-format qcow2 --container-format bare --public --file CentOS-7-x86_64-GenericCloud-1608.qcow2 CentOS-7-x86_64
```

Ubuntu Trusty 14

```bash
# wget https://cloud-images.ubuntu.com/releases/14.04/14.04.4/ubuntu-14.04-server-cloudimg-amd64-disk1.img
# openstack image create --disk-format qcow2 --container-format bare --public --file ubuntu-14.04-server-cloudimg-amd64-disk1.img Ubuntu-14.04
```

List or get details for images :

```bash
# openstack image list
# openstack image show image_name
```

Delete images:

```bash
# openstack image delete image_id
# openstack image delete image_name
```

Troubleshoot image creation:

If you encounter problems in creating an image in the Image service or Compute, the following information may help you troubleshoot the creation process.
1. Ensure that the version of qemu you are using is version 0.14 or later. Earlier versions of qemu result in an unknown option -s error message in the /var/log/nova/nova-compute.log file.
2. Examine the /var/log/nova/nova-api.log and /var/log/nova/nova-compute.log log files for error messages.
