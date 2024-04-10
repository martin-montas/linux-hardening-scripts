#!/usr/bin/bash

# SSH allows administrators to set a network responsiveness timeout interval. After this interval has passed, the unresponsive client will be automatically logged out.

# To set this timeout interval, edit the following line in /etc/ssh/sshd_config as follows:

ClientAliveInterval 300

