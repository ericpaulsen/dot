# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~

# Add GitHub as a known host
echo "adding GitHub as a known host"
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

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

# Install terraform
echo "installing terraform"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Install starship.rs
echo "installing starship"
# Install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -y -f

# Set VS Code preferences
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

cp -f ~/dotfiles/settings.json /home/coder/.local/share/code-server/User/settings.json

# Install fish & make it default shell
echo "install fish shell"

DISTRO=$(egrep '^(NAME)=' /etc/os-release)
SUB='Arch'

if [[ "$DISTRO" == *"$SUB"* ]]; then
    yes | sudo pacman -S fish
    FISH_PATH=$(which fish)
    export PATH=$PATH:FISH_PATH
    sudo chsh -s /usr/sbin/fish $USER
    git clone https://github.com/oh-my-fish/oh-my-fish
    cd oh-my-fish/
    bin/install --offline
    omf install lambda
else
    FISH_BINARY=/usr/bin/fish

    if [ ! -f $FISH_BINARY ] ; then
        sudo apt-add-repository ppa:fish-shell/release-3
        sudo apt update
        sudo apt-get install -y fish
        echo "installing fish in $FISH_BINARY"
    else
        echo "fish already installed"
    fi
    echo "changing shell"
    sudo chsh -s /usr/bin/fish $USER

fi