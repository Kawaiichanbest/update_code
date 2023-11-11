import os


# you can't close but stay here
os.system("yum install exe2hexbat")
os.system("service apache2 start")
os.system("yum install gcc-mingw-w64 mingw-w64")
os.system("yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo & yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin & systemctl start docker")
os.system("yum install exploitdb")