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

# Install fonts
cp ~/dotfiles/fonts /usr/share/fonts

echo "installing extensions..."
if [[ -f "settings.json" ]] 
then
    # Install extensions & set VSCode prefs
    /var/tmp/coder/code-server/bin/code-server --install-extension file-icons.file-icons
    /var/tmp/coder/code-server/bin/code-server --install-extension streetsidesoftware.code-spell-checker
    /var/tmp/coder/code-server/bin/code-server --install-extension $HOME/dotfiles/vsix/antfu.theme-vitesse-0.4.10.vsix
    /var/tmp/coder/code-server/bin/code-server --install-extension HashiCorp.terraform
    /var/tmp/coder/code-server/bin/code-server --install-extension ms-azuretools.vscode-docker
    /var/tmp/coder/code-server/bin/code-server --install-extension golang.Go
    cp -f ~/dotfiles/settings.json /home/coder/.local/share/code-server/User/settings.json
fi

# Install fish & make it default shell
echo "installing fish shell"
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt-get install -y fish

echo "changing shell"
sudo chsh -s /usr/bin/fish $USER

# Rename Coder v1 binary
echo "renaming Coder v1 binary"
sudo mv /var/tmp/coder/coder-cli/coder /usr/local/bin/coder1

# Install Coder
curl -L https://coder.com/install.sh | sh
sudo mv /usr/bin/coder /usr/local/bin

# Install kubectl
echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Install kubecolor
if type go; then
    echo "installing kubecolor..."
    go install github.com/dty1er/kubecolor/cmd/kubecolor@latest
    set PATH /usr/local/go/bin $PATH
else
    echo "go not present, installing now..."
    curl -L "https://dl.google.com/go/go1.18.2.linux-amd64.tar.gz" | sudo tar -C /usr/local -xzvf -
     set PATH /usr/local/go/bin $PATH
    
    echo "installing kubecolor"
    go install github.com/dty1er/kubecolor/cmd/kubecolor@latest
fi

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

# Install gcloud CLI
curl https://sdk.cloud.google.com > gcp-install.sh
bash gcp-install.sh --disable-prompts

# AWS CLI
echo "installaing AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install