#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

apt-get update -y
apt-get install -y fontconfig openjdk-21-jre unzip curl gnupg apt-transport-https ca-certificates software-properties-common jq

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
  -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update -y
apt-get install -y jenkins

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker jenkins
usermod -aG docker ubuntu
systemctl enable docker
systemctl restart docker

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

curl --silent --location "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update -y
apt-get install -y terraform

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# sysctl -w vm.max_map_count=262144
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf
# docker run -d --name sonarqube --restart unless-stopped -p 9000:9000 sonarqube:lts-community

systemctl enable jenkins
systemctl start jenkins
