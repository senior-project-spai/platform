From Bare Server

sudo yum install -y git

git clone https://github.com/senior-project-spai/platform

cd platform/okd

sudo chmod +x -R install

cd install

source settings.sh

cd ~/platform/okd/install/node

./add_hosts.sh

sudo ../install_pre.sh