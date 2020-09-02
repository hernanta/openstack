# VLAN Configuration

Load 8021q module:

```bash
# modprobe --first-time 8021q
```

## Manual Network Configuration

Creating the vlan bridge which is used by openstack to communicate with the physical vlan based networking switch:

```bash
# ovs-vsctl add-br br-vlan
# ovs-vsctl add-port br-vlan eth0
```

Configuring an ip from the development range to an interface on the node so we have access to it:

```bash
# ip link set br-vlan up
# ip link set br-vlan.100 up
# ip address add dev br-vlan.100 192.168.0.100 netmask 255.255.255.0
# ip route add default via 192.168.0.1
```

Configuring openstack ml2 plugin with our vlan setup:

```bash
# vi /etc/neutron/neutron.conf
```

```yaml
core_plugin =neutron.plugins.ml2.plugin.Ml2Plugin
```

Configuring the actual vlan's:

```bash
# vi /etc/neutron/plugins/ml2/ml2_conf.ini
```

```yaml
type_drivers = vxlan,gre,vlan
network_vlan_ranges = physical-vlan:100:100
```

Creating the mapping between the vlan and the actual physical interface:

```bash
# vi /etc/neutron/plugins/ml2/openvswitch_agent.ini
```

```yaml
bridge_mappings = physical-vlan:br-vlan
```

We do have a working setup right now if everything went well and you should be able to launch an instance. To test ICMP traffic do not forget to enable a security group which allows this kind of traffic. Otherwise you couldn't use ping to test traffic.

Some useful commands:

```bash
ovs-vsctl show #shows the openvswitch configuration
ovs-ofctl dump-flows br-int #shows the flows to map an internal project tag to an actual vlan id
brctl show #shows the linux bridge
```

## Persistent Network Configuration

To keep your networking up and running after a reboot you should configure you bridges natively on the all-in-one instance:

```bash
# vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

```yaml
DEVICE="eth0"
ONBOOT=yes
OVS_BRIDGE=br-vlan
TYPE=OVSPort
DEVICETYPE="ovs"
```

```bash
# vi /etc/sysconfig/network-scripts/ifcfg-br-vlan
```

```yaml
DEVICE=br-vlan
BOOTPROTO=none
ONBOOT=yes
TYPE=OVSBridge
DEVICETYPE="ovs"
```

```bash
# vi /etc/sysconfig/network-scripts/ifcfg-br-vlan.100
```

```yaml
BOOTPROTO="none"
DEVICE="br-vlan.100"
ONBOOT="yes"
IPADDR="192.168.0.100"
PREFIX="24"
GATEWAY="192.168.0.1"
DNS1="192.168.0.1"
VLAN=yes
NOZEROCONF=yes
USERCTL=no
```

Be sure to use the OVSBridge type and ovs DEVICETYPES otherwise it will not work..
