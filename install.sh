# copy dotfiles into ~
shopt -s dotglob # include . in *
shopt -s extglob
yes | cp -rf ~/dotfiles/!(.git|.|..|.local) ~
# Set VS Code preferences for the FIRST time
if [ -f "settings.json" ] 
then
    echo "VS Code settings are already present." 
else
    cp -rf /home/coder/dotfiles/.local ~/.local
    # Install extensions
    /opt/coder/code-server/bin/code-server --install-extension yummygum.city-lights-theme
fi