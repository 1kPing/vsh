#!/bin/dash

echo "~ is being backed up to /home/old~"
sudo mkdir /home/old~
sudo mv ~/* /home/old~
sudo mv /home/old~/vsh ~
cd ~/vsh
find . -maxdepth 1 -mindepth 1 -exec mv -f {} ~ \;
cd

# Update system and install repo packages
sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland-mirror.conf
echo "repository=https://github.com/index-0/librewolf-void/releases/latest/download/" | sudo tee /etc/xbps.d/librewolf-mirror.conf
sudo xbps-install -Syu

# Install packages
packages="PrismLauncher Signal-Desktop Waybar blender btop fastfetch font-awesome foot galculator gimp gnome-keyring gnome-themes-extra gtk-engine-murrine imv libreoffice librewolf mako mpv neovim nwg-look pavucontrol pipewire qbittorrent sassc sddm starship steam ufw wev wine wine-gecko wine-mono wofi yazi zsh"
sudo xbps-install -Syu $packages

sudo mv ~/eww /bin
sudo mv ~/alarm-clock-applet /bin
sudo mv ~/theclicker /bin

echo "Do you want to install discord with flatpak? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y flatpak
    flatpak install com.discordapp.Discord -y
fi

echo "Do you want to install nvidia stuff? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit nvidia nvidia-libs-32bit linux-firmware-nvidia
fi

# Configuration
~/graphite-gtk-theme/install.sh --tweaks rimless black
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'

# Clean up
rm -rf ~/.git
rm -r ~/vsh
rm -r ~/graphite-gtk-theme
rm ~/LICENSE
rm ~/README.md
rm ~/v.sh

# Startup services
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/sddm /var/service

echo "finished, reboot your computer"
