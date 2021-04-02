# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~
# Set VS Code preferences for the FIRST time

echo "installing extensions..."

if [ -f "settings.json" ] 
then
    cp -rf /home/coder/dotfiles/.local ~/.local
    # Install extensions
    /opt/coder/code-server/bin/code-server --install-extension yummygum.city-lights-theme
    /opt/coder/code-server/bin/code-server --install-extension streetsidesoftware.code-spell-checker
fi

echo "install fish shell"

FISH_BINARY=/usr/bin/fish
FISH_PATH=/usr/bin

if [ ! -f $FISH_BINARY ] ; then
    sudo apt-get update
    sudo apt-get install -y fish
    echo "installing fish in $FISH_PATH"

    sudo curl -L https://get.oh-my.fish | fish
    omf install lambda
    echo "installing your Oh My Fish lambda theme"

else
    echo "fish already installed"
fi

echo "changing shell"
sudo chsh -s /usr/bin/fish $USER