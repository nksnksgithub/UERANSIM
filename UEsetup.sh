#!/bin/bash

# Run ifconfig to get the IPv4 address of uesimtun0
UE_IP=$(ifconfig uesimtun0 | grep 'inet ' | awk '{print $2}')

sudo ip route del default
sudo ip route add default via $UE_IP
