#!/usr/bin/env bash

################################################################################
#                                ssh-barage.sh                                 #
################################################################################
#
# This script is associated with the "SSH Barrage" activity from the
# Kibana-Continued document.
#
# It attempts to generate a high number of failed SSH login attempts to verify
# Kibana is picking up the activity. The default number of attempts per machine
# is 150, but it can be set by setting the environment variable
# $NUM_LOGIN_ATTEMPTS before running this script.
#
# Set the environment variable $DEBUG to a non-empty value to enable debugging
# messages. Be aware that the debug logging is very verbose, and will print a
# message with the attempt number and ip address of the target host each time a
# login is attempted.
#
# Set the environment variable $DRY_RUN to a non-empty value to simply print the
# commands that would be run, without actually doing any work.
#
# Any additional arguments to the script will be treated as the desired host on
# which to attempt logins, overriding the default hosts.
#
# Some examples:
#
#   # Attempt to login to each machine the default number of times (default behaviour):
#   ./ssh-barrage.sh
#
#   # Attempt to login to each machine 200 times:
#   NUM_LOGIN_ATTEMPTS=200 ./ssh-barrage.sh
#
#   # Attempt to login to a custom host (specified by any additional arguments to the script):
#   ./ssh-barrage.sh 10.0.0.5
#
#   # Attempt to login to many custom hosts:
#   ./ssh-barrage.sh 10.0.0.5 10.0.0.6
#

# Set $DEBUG to an empty string if it is not already set.
: ${DEBUG:=""}

# Set $DRY_RUN to an empty string if it is not already set.
: ${DRY_RUN:=""}

# Set $NUM_LOGIN_ATTEMPTS to 150 if it is not already set
: ${NUM_LOGIN_ATTEMPTS:=150}

# Function to log a debug message if the $DEBUG variable is set
function debug_msg() {
  [[ -z ${DEBUG} ]] || echo "${@}"
}

# Function that trys to ssh to the given host ($1), or simply prints the command
# that would be run if $DRY_RUN is set.
function try_ssh() {
  ssh_command="ssh sysadmin@${1}"
  if [[ -n "${DRY_RUN}" ]]; then
    echo "${ssh_command}"
  else
    ${ssh_command}
  fi
}

# Default hosts to attempt logins on
DEFAULT_HOSTS=(10.1.0.5 10.1.0.6 10.1.0.9)

# Set $TARGET_HOSTS to any passed arguments ($@), or all of the default hosts if
# no arguments were passed.
TARGET_HOSTS=${@:-${DEFAULT_HOSTS[@]}}

# Main program loop
for host in ${TARGET_HOSTS[@]}; do
  debug_msg "Attempting logins on '${host}'"
  for (( i = 0; i < ${NUM_LOGIN_ATTEMPTS}; i++ )); do
    debug_msg "Attempt #${i} on ${host}"
    try_ssh ${host}
  done
done
