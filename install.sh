# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~

# Set VS Code preferences
echo "installing extensions..."

if [[ -f "settings.json" ]] 
then
    cp -rf /home/coder/dotfiles/.local ~/.local
    # Install extensions
    /var/tmp/coder/code-server/bin/code-server --install-extension pkief.material-icon-theme
    /var/tmp/coder/code-server/bin/code-server --install-extension streetsidesoftware.code-spell-checker
    /var/tmp/coder/code-server/bin/code-server --install-extension marnix.tokyo-night-pro
fi

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
    FISH_BINARY=/usr/local/bin/fish

    if [ ! -f $FISH_BINARY ] ; then
        sudo apt-get update
        sudo apt-get install -y fish
        echo "installing fish in $FISH_PATH"
    else
        echo "fish already installed"
    fi
    echo "changing shell"
    sudo chsh -s /usr/local/bin/fish $USER
fi

# Install kubectl
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install kubectx
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Install gcloud
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-385.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-385.0.0-linux-x86.tar.gz
./google-cloud-sdk/install.sh
./google-cloud-sdk/bin/gcloud init

