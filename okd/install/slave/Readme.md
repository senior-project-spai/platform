## Install From Bare Server
```
sudo yum install -y git

git clone https://github.com/senior-project-spai/platform

sudo chmod +x -R platform/okd/install

source platform/okd/install/settings.sh

platform/okd/install/add_hosts.sh

platform/okd/install/install_pre.sh
```