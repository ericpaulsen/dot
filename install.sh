# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~

# Install kubectl
brew install kubectl

# Install kubectx
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# Install terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Set VS Code preferences
echo "installing extensions..."

if [[ -f "settings.json" ]] 
then
    # Install extensions
    /var/tmp/coder/code-server/bin/code-server --install-extension pkief.material-icon-theme
    /var/tmp/coder/code-server/bin/code-server --install-extension streetsidesoftware.code-spell-checker
    /var/tmp/coder/code-server/bin/code-server --install-extension /vsix/marnix.tokyo-night-pro-1.1.4.vsix
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
    FISH_BINARY=/usr/bin/fish

    if [ ! -f $FISH_BINARY ] ; then
        sudo apt-get update
        sudo apt-get install -y fish
        echo "installing fish in $FISH_BINARY"
    else
        echo "fish already installed"
    fi
    echo "changing shell"
    sudo chsh -s /usr/bin/fish $USER

fi

# Install OMF
echo "installing OMF"
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install neolambda

echo "installing starship"
# Install Starship
brew install starship