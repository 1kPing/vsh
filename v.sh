#!/bin/dash

echo "~ is being backed up to /home/old~"
sudo mkdir /home/old~
sudo mv -r ~/* /home/old~
sudo mv -r /home/old~/vsh ~
cd ~/vsh
find . -maxdepth 1 -mindepth 1 -exec mv -f {} ~ \;
cd

# Update system and install repo packages
sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland-mirror.conf
echo "repository=https://github.com/index-0/librewolf-void/releases/latest/download/" | sudo tee /etc/xbps.d/librewolf-mirror.conf
sudo xbps-install -Syu
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"

# Install packages
packages=""
sudo xbps-install -Syu $packages

sudo mv ~/eww /bin
sudo mv ~/alarm-clock-applet /bin

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
xdg-settings set default-web-browser librewolf.desktop

~/graphite-gtk-theme/install.sh --tweaks rimless black

git clone https://github.com/jmattheis/gruvbox-dark-icons-gtk ~/.icons/gruvbox-dark-icons-gtk

gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'

# Clean up
rm -rf ~/.git
rm -r ~/vsh
rm -r ~/graphite-gtk-theme
rm ~/LICENSE
rm ~/README.md
rm ~/NOTES
rm ~/v.sh

# Startup services
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/sddm /var/service

echo "finished, reboot your computer"
