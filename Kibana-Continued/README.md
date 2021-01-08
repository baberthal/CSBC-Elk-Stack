# Kibana Continued

### Setup

The Web VMs have the following IP addresses:

* Web-1 - `10.1.0.5`
* Web-2 - `10.1.0.6`
* Web-3 - `10.1.0.9`

---

### SSH Barrage

To verify that Kibana is picking up failed login attempts, we generate a high
number of failed SSH login attempts using the JumpBox VM, which does not have
proper SSH permissions to access any of the Web VMs.

The script located [here](./scripts/ssh-barrage.sh) can be used from the JumpBox to generate an arbitrary number of failed SSH login attempts on any or all of
the Web VMs.

To use the script, simply download it to the JumpBox (available at [this
url]()), ensure it is executable, and run it.

#### Script Installation

```bash
# Assuming you are logged into the JumpBox VM
sysadmin@JumpBox:~$ curl -O XXX_URL/ssh-barrage.sh
sysadmin@JumpBox:~$ chmod +x ./ssh-barrage.sh
```

#### Script Usage

Set the environment variable `$DEBUG` to a non-empty value to enable debugging
messages. Be aware that the debug logging is very verbose, and will print a
message with the attempt number and ip address of the target host each time a
login is attempted.

Set the environment variable `$DRY_RUN` to a non-empty value to simply print the
commands that would be run, without actually doing any work.

Any additional arguments to the script will be treated as the desired host on
which to attempt logins, overriding the default hosts.

##### Examples

Attempt to login to each machine the default number of times (default behaviour):

```bash
sysadmin@JumpBox:~$ ./ssh-barrage.sh
```

Attempt to login to each machine 200 times:

```bash
sysadmin@JumpBox:~$ NUM_LOGIN_ATTEMPTS=200 ./ssh-barrage.sh
```

Attempt to login to a custom host (specified by any additional arguments to the script):

```bash
sysadmin@JumpBox:~$ ./ssh-barrage.sh 10.0.0.5
```

Attempt to login to many custom hosts:

```bash
sysadmin@JumpBox:~$ ./ssh-barrage.sh 10.0.0.5 10.0.0.6
```

Don't actually do anything, but see what would be run:

```bash
sysadmin@JumpBox:~$ DRY_RUN=1 ./ssh-barrage.sh
```

---

### Linux Stress

To verify that Kibana is picking up excessive CPU usage in the metrics page,
we will use the Linux program `stress` to artifically stress the CPU of one of
the Web VMs.

To perform this test, first we must SSH into the Web VM via the JumpBox and
Ansible container:

```bash
# Assuming you have SSHed into the JumpBox, and attached the Ansible docker
# container
root@ed622b84bcd3:~\# ssh sysadmin@10.1.0.5
```

Ensure the `stress` program is installed:

```bash
# Now we are in the Web-1 VM
sysadmin@Web-1:~$ sudo apt update
sysadmin@Web-1:~$ sudo apt install stress
```

Run `stress` for a few minutes, and monitor the Kibana metrics page:

```bash
# Press Ctrl-C after a few minutes to stop
sysadmin@Web-1:~$ sudo stress --cpu 1
```

Repeat these steps with all three of the Web VMs. The results should look like
this:

![stress-results-example](../images/stress-results.png)
