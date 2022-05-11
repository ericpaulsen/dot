# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~

# Add GitHub as a known host
echo "adding GitHub as a known host"
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# Install starship.rs
echo "installing starship"
# Install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f

# Set VS Code preferences
cp -f ~/dotfiles/settings.json /home/coder/.local/share/code-server/User/settings.json

echo "installing extensions..."
if [[ -f "settings.json" ]] 
then
    # Install extensions
    /var/tmp/coder/code-server/bin/code-server --install-extension pkief.material-icon-theme
    /var/tmp/coder/code-server/bin/code-server --install-extension streetsidesoftware.code-spell-checker
    /var/tmp/coder/code-server/bin/code-server --install-extension $HOME/vsix/marnix.tokyo-night-pro-1.1.4.vsix
    /var/tmp/coder/code-server/bin/code-server --install-extension HashiCorp.terraform
    /var/tmp/coder/code-server/bin/code-server --install-extension ms-azuretools.vscode-docker

fi

# Install fish & make it default shell
echo "installing fish shell"
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt-get install -y fish

echo "changing shell"
sudo chsh -s /usr/bin/fish $USER

# Install kubectl
echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install kubecolor
echo "installing kubecolor"
go install github.com/dty1er/kubecolor/cmd/kubecolor@latest

# Install kubectx
echo "installing kubectx"
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install Terraform
echo "installing Terraform"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# AWS CLI
echo "installaing AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install gcloud CLI
curl https://sdk.cloud.google.com > install.sh
bash install.sh --disable-prompts

# Install Azure CLI
sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install azure-cli