#!/usr/bin/env bash
#判断linux版本以安装
centos_version7=$(cat /etc/system-release|grep -c "CentOS Linux release 7")
centos_version8=$(cat /etc/system-release|grep -c "CentOS Linux release 8")
if [ $centos_version7 = 1 ];then
    sudo yum install epel-release
elif [ $centos_version8 = 1 ]; then
    sudo dnf install epel-release
    sudo dnf upgrade
else
  echo "linux version is not support,please try another way"
  exit
fi

# 安装snap
sudo yum install -y snapd
sudo systemctl enable --now snapd.socket
if [ ! -d "/snap" ]; then
  sudo ln -s /var/lib/snapd/snap /snap
fi

sudo snap install core
sudo snap refresh core


#卸载之前曾使用过的certbot软件
sudo yum remove certbot

#安装certbot
sudo snap install --classic certbot

if [ ! -f "/usr/bin/certbot" ]; then
#增加软链
sudo ln -s /snap/bin/certbot /usr/bin/certbot
fi
#给nginx增加 certbot配置
sudo certbot --nginx

#配置cerbot 自动延期证书
sudo certbot renew --dry-run
