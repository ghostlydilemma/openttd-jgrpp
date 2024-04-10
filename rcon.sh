#!/bin/sh

openttd-admin rcon -c /home/openttd/.config/openttd/openttd.cfg

# Since the openttd-admin doesn't always exit cleanly, help it out a bit
reset -I
