#!/bin/dash

trap 'exit 1' INT

if [ ! -d "~/vsh" ]; then
    echo "Error: vsh directory not found in ~ ; Move it there and try again."
    exit 1
fi

echo "!! Everything currently in ~ will be moved to /home/old~N !!"
sleep 1
echo "Hit enter to proceed..."
read answer
if [ "$answer" = "^C" ]; then
    exit 1
else
    echo "Backing up ~ to an available /home/old~N directory and moving configurations..."
    
    base_dir="/home/old~"
    target_dir="$base_dir"
    counter=2
    
    while [ -d "$target_dir" ]; do
        target_dir="${base_dir}${counter}"
        counter=$((counter + 1))
    done
    
    sudo mkdir "$target_dir"
    cd
    sudo find . -maxdepth 1 -mindepth 1 -exec mv -f {} "$target_dir" \;
    cd "$target_dir"/vsh
    sudo find . -maxdepth 1 -mindepth 1 -exec mv -f {} ~ \;
    cd
    sudo rmdir "$target_dir"/vsh
    sudo mkdir -p /usr/share/fonts/TTF
    sudo rsync ~/TTF/* /usr/share/fonts/TTF
    rm -rf ~/TTF
    rm -rf ~/.git
    rm ~/LICENSE
    rm ~/README.md
fi

sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
echo "repository=https://github.com/index-0/librewolf-void/releases/latest/download/" | sudo tee /etc/xbps.d/librewolf-mirror.conf
sudo xbps-install -Syu

packages="libxcb-devel pam-devel zig NetworkManager PrismLauncher Signal-Desktop alacritty alsa-pipewire awesome blender brightnessctl btop dunst fastfetch font-awesome galculator gimp git gnome-keyring gnome-themes-extra gtk-engine-murrine imv libreoffice librewolf libxcb mpv neovim nwg-look pam pavucontrol pipewire pipewire-devel qbittorrent rofi sassc scrot starship steam ufw wine wine-gecko wine-mono xev xorg xauth yazi zsh"

for package in $packages; do
    sudo xbps-install -y "$package"
done

sudo ln -s /etc/sv/dbus /var/service
cd ly
sudo zig build installexe -Dinit_system=runit
sudo ln -s /etc/sv/ly /var/service/
sudo rm /var/service/agetty-tty2

bash -c "$(curl -fsSL https://raw.githubusercontent.com/kontr0x/github-desktop-install/main/installGitHubDesktop.sh)"
sudo mv ~/binaries/* /bin
sudo mv ~/GithubDesktop* /bin/github

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

xdg-settings set default-web-browser librewolf.desktop
xdg-mime default imv.desktop image/*
xdg-mime default mpv.desktop video/*

sudo ~/graphite-gtk-theme/other/grub2/install.sh -b
~/graphite-gtk-theme/install.sh --tweaks rimless black
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'
sudo echo "QT_QPA_PLATFORMTHEME=gtk3" | sudo tee /etc/environment

sudo mkdir -p /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
echo "autospawn = no" | sudo tee /etc/pulse/client.conf

rm -r ~/graphite-gtk-theme
rmdir ~/binaries
rm ~/v.sh

sudo xbps-install -Syu

echo "finished, reboot your computer"

exit 0
