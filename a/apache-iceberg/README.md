NOTE
The tests require Docker Environment to execute. Please install Docker before running tests.

#Steps to Install docker for ubi 9.3 container
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl enable docker
systemctl start docker