# Interview Questions - Logging and Monitoring

### Setting Alerts in a New Monitoring System

#### Problem

Creating and maintaining a new monitoring system can be a daunting and
cumbersome task. Many considerations need to be taken into account, including
what alerts to set on each monitored machine and why.

#### Example Scenario

In Project 1, I created a network consisting of two subnets and five total
virtual machines. The below tables describe the subnets, machines on each, and
the machine's purpose:

##### red-team-default-network (10.1.0.0/24)

| Machine Name        | IP Address | Purpose                                                |
| ------------------- | ---------- | ------------------------------------------------------ |
| JumpBox-Provisioner | 10.1.0.7   | Runs ansible, configures and provisions other machines.|
| Web-1               | 10.1.0.5   | Runs DVWA Application via docker container.            |
| Web-2               | 10.1.0.6   | Runs DVWA Application via docker container.            |
| Web-3               | 10.1.0.9   | Runs DVWA Application via docker container.            |

##### elk-vm-network (10.0.0.0/24)

| Machine Name        | IP Address | Purpose                              |
| ------------------- | ---------- | -------------------------------------|
| Elk-Stack-VM        | 10.1.0.4   | Runs ELK stack via docker container. |

Of all the above machines, only the JumpBox-Provisioner VM needs to be publicly
accessible via SSH, and only from one IP address (my home network IP). None of
the other machines need be publicly accessible via SSH.

#### Solution Requirements

Since the vast majority of the virtual machines need not be publicly accessible,
alerts should be configured when SSH access is attempted to these machines.  The
web VMs should only be accessible on HTTP via the load-balancer, additional
alerts should fire when HTTP access is attempted on these machines. In order to
not advertise our network topology, an alert should be configured on each of the
machines to warn of ping attempts.

#### Solution Details

In Project 1, we would have used the Kibana web interface to configure these
alerts. In addition to the alerts mentioned above, we would like to guarantee no
unauthorized SSH access occurs on the Jump Box, so we would set an alert to warn
of failed SSH attempts, or any SSH attempt from an unauthorized IP address.

Overall, the following alerts should be configured on the virtual machines:

* Jump Box Provisioner
  * Failed SSH attempts
  * Ping attempts
  * Any SSH attempt from unauthorized IP addresses (i.e. not my home network)

* Web-1, Web-2, Web-3
  * Failed SSH attempts
  * Ping attempts
  * Any SSH attempt from outside the virtual network
  * Any HTTP attempt from unauthorized IP addresses (i.e. not my home network)

* Elk-Stack VM
  * Failed SSH Attempts
  * Ping attempts
  * Any SSH attempt from outside the virtual network
  * Any Kibana web interface access from unauthorized IP addresses

#### Advantages and Disadvantages

While the above alerts should cover the vast majority of malicious
circumstances, unforeseen events can take place that compromise any given
machine on the network and can lead to unauthorized access of the network.

As seen by the recent SolarWinds breach, even when all packages are updated with
security patches, malicious actors can still gain access to networks.

If a malicious actor were to gain physical access to one of the Azure data
centers, our network could be compromised, unbeknownst to us. Although the
likelihood of this taking place is minimal, we should be wary of it.
