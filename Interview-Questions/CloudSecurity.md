# Interview Questions - Cloud Security

### Cloud Access Control

#### Problem

Controlling access to a cloud network is a difficult task. Although network
security defaults on Azure provide a secure network, configuration changes must
be made to allow access to traffic outside the network.

#### Example Scenario

In project one, we deployed a cloud network rather than an on-premises network.
The cloud network consisted of two subnets, linked with a peering configured on
Azure.

Many access controls had to be configured on this network. Access controls were
implemented for the following reasons:

* Allow SSH access to the Jump Box, in order to configure other machines.

* Allow SSH access from the Jump Box to other machines on the network for
  configuration and provisioning.

* Allow HTTP access to the load-balancer, in order to access the DVWA
  container application.

* Allow access to the Kibana web interface running on the Elk-Stack-VM.

The above controls represent a fairly simple access control configuration. These
scenarios need to be taken into account when securing access control to any
cloud network.

#### Solution Requirements

In Project 1, we implemented a number of access controls. All access controls
were implemented via Azure Network Security Groups ("NSGs"). Two separate NSGs
were configured, one for each subnet in the network. Due to the fact all access
controls were configured via the NSGs, no local firewalls were installed or
configured on any virtual machine.

The following table describes which protocols were allowed from what sources and
to what destinations (note that not all NSG configuration is in the table):

| Protocol | Source              | Destination         |
| -------- | ------------------- | ------------------- |
| SSH      | My Home Network IP  | 10.1.0.7 (Jump Box) |
| SSH      | 10.1.0.7 (Jump Box) | Virtual Network     |
| HTTP     | My Home Network IP  | Load Balancer IP    |

The first access control (SSH from my home network to the Jump Box) allowed SSH
access from my workstation to the Jump Box machine. This was necessary for the
project so I could configure the provisioner, install the required software, and
access the rest of the machines on the network.

The second access control (SSH from Jump Box to other machines on the virtual
network) allowed the Jump Box to provision and configure the other machines on
the network. This was necessary for the project, since it allowed the docker
container running ansible to provision the other machines, and configure the
various software packages that needed to be installed for the project.

The third access control (HTTP access from my home network to the load-balancer)
allowed access to the DVWA application from my workstation. This was necessary
for the project because it allowed me to access the web application from my
workstation.

The fourth access control (access from my home network to the Kibana web
interface) allowed me to access the Kibana web interface from my workstation.
This was necessary for the project because it allowed me to monitor logs and
metrics on the three web virtual machines via Kibana.

#### Solution Details

###### NSG Rules

The access control configuration consisted of two network security groups,
one for each subnet on the network.

The first subnet (`red-team-default`) has the IP address range `10.1.0.0/24`,
and contains the Jump Box Provisioner, Web-1 VM, Web-2 VM, and Web-3 VM. Custom
access controls implemented in the associated NSG (`red-team-nsg`) can be
described as follows:

> For brevity, `Home IP` represents the IP address of my home network, `Vnet`
> represents the IP address range of the entire virtual network, and `LB IP`
> represents the IP address of the load-balancer.

| Priority | Name          | Port | Protocol | Source     | Destination | Action |
| -------- | ------------- | ---- | -------- | ---------- | ----------- | ------ |
| 100      | Allow-SSH     | 22   | TCP      | Home IP    | JumpBox IP  | Allow  |
| 101      | Open-LB       | 80   | TCP      | Home IP    | LB IP       | Allow  |
| 110      | JB-SSH-to-Vnet| 22   | TCP      | JumpBox IP | Vnet        | Allow  |

The second subnet (`elk-vnet`) has the IP address range `10.0.0.0/24`, and
contains the Elk-Stack-VM. A network security group (`ELK-vm-nsg`) was
associated with the Elk-Stack-VM itself, rather than the network as a whole. The
following custom access controls were implemented on the VM's NSG:

| Priority | Name         | Port | Protocol | Source  | Destination | Action |
| -------- | ------------ | ---- | -------- | ------- | ----------- | ------ |
| 1000     | Allow-Kibana | 5601 | TCP      | Home IP | Vnet        | Allow  |

###### Jump Box Access

Access to the Jump Box works via SSH. The user configures a key pair when
deploying the machine via the Azure web interface, and then uses that key to
achieve SSH access to the Jump Box.

Once the user is in the Jump Box, they attach the docker container that runs
ansible. A second key pair is then generated, and the public key from this pair
is configured to allow SSH access on the web VMs, via the Azure web interface.
Only the ansible docker container is allowed SSH access to the web VMs. Ansible
is then used to provision and configure the rest of the machines.

#### Advantages and Disadvantages

###### Scalability

This solution is not entirely scalable. Each time a new VM is created on the
network, the public key from the ansible docker container would need to be
copied to allow access to the VM. While this is not necessarily the most
cumbersome task, if 1,000 virtual machines were added to the network, it
represents a significant rise in time to configure.

###### Alternative Solutions

There are two viable alternative solutions to the one presented above:
* A virtual private network ("VPN").
* The Azure Bastion service.

In a large network, a VPN would be the most viable solution. I will explore the
advantages and disadvantages of a VPN below. Usage of the Azure Bastion service
is outside of the scope of this document.

###### Virtual Private Network

If a virtual private network were implemented, it would allow SSH access to the
machines on the network without the need for access control configurations. Due
to the nature of SSH however, the public key would still need to be copied to
new machines.

Although a VPN makes things significantly easier when implemented, creation and
maintenance of the VPN makes it a cumbersome task for such a small network. To
create a VPN for this project, a new virtual machine would have to have been
created, on which a VPN server (such as OpenVPN) would need to be installed and
configured. VPN configuration can be a daunting task.

Due to the small size of the network created for Project 1 and the technical
debt associated with creation and maintenance of a VPN, one was not needed for
this project.

Advantages of a VPN include the following:

* Direct network access to any machine from outside the virtual network.
* Fully-encrypted access to the web servers.
  * Access over a VPN is fully encrypted, meaning we would not have had to
    configure access controls for DVWA or Kibana in order to access the web
    interfaces.

Despite these advantages, it was determined that a VPN was not suitable for the
network in this project, due to the small size of the network and number of
access control configurations required.

If the network were much larger, or if we required access to the web interfaces
from a number of machines, it would have been appropriate to use a VPN for
access control.
