# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~

# Set VS Code preferences
echo "installing extensions..."

if [ -f "settings.json" ] 
then
    cp -rf /home/coder/dotfiles/.local ~/.local
    # Install extensions
    /opt/coder/code-server/bin/code-server --install-extension yummygum.city-lights-theme
    /opt/coder/code-server/bin/code-server --install-extension streetsidesoftware.code-spell-checker
fi

# Install fish & make it default shell
echo "install fish shell"

DISTRO=$(egrep '^(NAME)=' /etc/os-release)

if [ $DISTRO =~ "NAME=Arch Linux" ]; then
    yes | sudo pacman -S fish
    FISH_PATH=$(which fish)
    export PATH=$PATH:FISH_PATH
    sudo chsh -s /usr/sbin/fish $USER
else
    FISH_BINARY=/usr/bin/fish
    FISH_PATH=/usr/bin

    if [ ! -f $FISH_BINARY ] ; then
        sudo apt-get update
        sudo apt-get install -y fish
        echo "installing fish in $FISH_PATH"
    else
        echo "fish already installed"
    fi
    echo "changing shell"
    sudo chsh -s /usr/bin/fish $USER
fi

