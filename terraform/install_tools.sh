#!/bin/bash

# Update system and install core packages
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre 

# Jenkins installation
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get -y install jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins

# Docker installation
sudo apt-get update
sudo apt-get install docker.io -y

# User group permission
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins

sudo systemctl restart docker
sudo systemctl restart jenkins

# Install dependencies and Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release snapd -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# AWS CLI installation
sudo snap install aws-cli --classic

# Helm installation
sudo snap install helm --classic

# 系统更新和 Java 安装

# 更新 apt 源，安装 Java 17（Jenkins 运行需要）。
# Jenkins 安装

# 下载 Jenkins 官方密钥，添加 Jenkins 软件源，安装 Jenkins。
# 启动并设置 Jenkins 开机自启。
# Docker 安装与配置

# 安装 Docker。
# 将当前用户和 jenkins 用户加入 docker 用户组，允许这两个用户直接操作 Docker。
# 重启 Docker 和 Jenkins 服务。
# Trivy 安装

# 安装 Trivy（容器镜像安全扫描工具）及其依赖。
# AWS CLI、Helm 安装

# 通过 snap 安装 AWS CLI 和 Helm（Kubernetes 包管理工具）