apt-get update

#Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt-get install 
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

#Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#setup stable docker repo
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

#Install Docker
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io

docker pull shadowsocks/shadowsocks-libev
docker run -e PASSWORD=Alien123. -p443:8388 -p443:8388/udp -d shadowsocks/shadowsocks-libev
