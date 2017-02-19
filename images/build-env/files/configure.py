#!/usr/bin/env python3

import docker
import os
import sys
import time
import yaml

def docker_host_ip(retries=3):
    for attempts in range(1, retries + 1):
        client = docker.from_env()
        bridge_net = client.networks.list(names=['bridge'])[0]
        options = bridge_net.attrs['Options']
        try:
            host_ip = options['gateway']
        except KeyError:
            if attempts == retries:
                raise
            else:
                time.sleep(0.3)
                continue
        else:
            return host_ip

if __name__ == '__main__':

  # Create build directory.
  os.makedirs('build', mode=0o755, exist_ok=True)

  # Read Docker host IP address.
  host_ip = docker_host_ip()

  print(sys.argv)
  print(host_ip)
