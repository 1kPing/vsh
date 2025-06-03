#!/bin/dash

echo "Hit enter to proceed..."
read answer
if [ "$answer" = "noconf" ]; then
    echo "Skipping backup and config..."
elif [ "$answer" = "^C" ]; then
    exit 1
else
    echo "Backing up ~ to /home/old~ and moving configurations..."
    sudo mkdir /home/old~
    sudo mv ~/* /home/old~
    sudo mv /home/old~/vsh ~
    cd ~/vsh
    find . -maxdepth 1 -mindepth 1 -exec mv -f {} ~ \;
fi
cd

# Update system and install repo packages
sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
echo "repository=https://github.com/index-0/librewolf-void/releases/latest/download/" | sudo tee /etc/xbps.d/librewolf-mirror.conf
sudo xbps-install -Syu

# Install packages
packages="NetworkManager PrismLauncher Signal-Desktop alsa-pipewire awesome blender btop elogind fastfetch font-awesome foot galculator gimp git gnome-keyring gnome-themes-extra gtk-engine-murrine imv libreoffice librewolf mako mpv neovim nwg-look pavucontrol pipewire pipewire-devel qbittorrent sassc seatd starship steam ufw wev wine wine-gecko wine-mono wofi xscreensaver yazi zsh"

for package in $packages; do
  sudo xbps-install -y "$package"
done

sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/seatd /var/service

bash -c "$(curl -fsSL https://raw.githubusercontent.com/kontr0x/github-desktop-install/main/installGitHubDesktop.sh)"
sudo mv ~/binaries/* /bin
mv ~/GithubDesktop* /bin/github

## echo "Do you want to install hypr stuff? (y/n)"
## read answer
## if [ "$answer" = "y" ]; then
##     echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland-mirror.conf
##     sudo xbps-install -Syu hyprland hyprland-protocols hyprlock hyprpaper xdg-desktop-portal-hyprland
## fi

echo "Do you want to install discord with flatpak? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install com.discordapp.Discord -y
fi

echo "Do you want to install nvidia stuff? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit nvidia nvidia-libs-32bit linux-firmware-nvidia
fi

# More configuration
xdg-settings set default-web-browser librewolf.desktop
~/graphite-gtk-theme/install.sh --tweaks rimless black
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'
sudo mkdir -p /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
echo "autospawn = no" | sudo tee /etc/pulse/client.conf
sudo usermod -aG _seatd $USER

# Clean up
rm -rf ~/.git
rm -r ~/vsh
rm -r ~/graphite-gtk-theme
rm ~/LICENSE
rm ~/README.md
rm ~/v.sh

echo "finished, reboot your computer"
