#!/bin/python
#!/bin/python2
#!/bin/python3

import os
import time

print("Hello guys")
os.system("clear")
time.sleep(1)
print("Do not close any program ever!")							# Don't close using program? 
time.sleep(40)
		      # started
os.system("service apache2 start") 				# that new website must started
os.system("yum install gcc-mingw-w64 mingw-w64") 						# Linux setup windows of exe, c,
os.system("yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo & yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin & systemctl start docker") 						# Docker needed to installed