#!/bin/dash

trap 'exit 1' INT

echo "!! This script is meant for a fresh install of Void Linux !!"
sleep 1
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
    sudo mv -f ~/TTF/* /usr/share/fonts/TTF
    rm -rf ~/.git
    rmdir ~/TTF
    rm ~/LICENSE
    rm ~/README.md
fi

sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree
echo "repository=https://github.com/index-0/librewolf-void/releases/latest/download/" | sudo tee /etc/xbps.d/librewolf-mirror.conf
sudo xbps-install -Syu

packages="librewolf neofetch gtk-layer-shell libdbusmenu sof-firmware socat NetworkManager PrismLauncher Signal-Desktop alacritty alsa-pipewire blender btop dunst fastfetch font-awesome galculator gimp gnome-keyring gnome-themes-extra gtk-engine-murrine i3lock imv libreoffice mpv neovim nwg-look pavucontrol pcmanfm-qt pipewire qbittorrent rofi sassc scrot starship steam ufw unclutter-xfixes wine wine-gecko wine-mono xclip xdg-utils yazi zsh"

for package in $packages; do
    sudo xbps-install -y "$package"
done

sudo ln -s /etc/sv/dbus /var/service

bash -c "$(curl -fsSL https://raw.githubusercontent.com/kontr0x/github-desktop-install/main/installGitHubDesktop.sh)"
sudo mv ~/binaries/* /usr/local/bin
rmdir ~/binaries

echo "Do you want to install flatpak? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    echo "Do you want to install discord through flatpak? (y/n)"
        read answer
	if [ "$answer" = "y" ]; then
            flatpak install com.discordapp.Discord -y
        fi
    echo "Do you want to install ungoogled chromium through flatpak? (y/n)"
        read answer
        if [ "$answer" = "y" ]; then
            flatpak install io.github.ungoogled_software.ungoogled_chromium -y
        fi
fi

echo "Do you want to install nvidia stuff? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit nvidia nvidia-libs-32bit linux-firmware-nvidia
fi

xdg-settings set default-web-browser librewolf.desktop
xdg-mime default imv.desktop image/avif
xdg-mime default imv.desktop image/gif
xdg-mime default imv.desktop image/jpeg
xdg-mime default imv.desktop image/jpg
xdg-mime default imv.desktop image/png
xdg-mime default imv.desktop image/svg
xdg-mime default imv.desktop image/webp
xdg-mime default mpv.desktop audio/cue
xdg-mime default mpv.desktop audio/m4a
xdg-mime default mpv.desktop audio/mp3
xdg-mime default mpv.desktop audio/ogg
xdg-mime default mpv.desktop audio/wav
xdg-mime default mpv.desktop video/avi
xdg-mime default mpv.desktop video/h264
xdg-mime default mpv.desktop video/h265
xdg-mime default mpv.desktop video/mkv
xdg-mime default mpv.desktop video/mov
xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/mpeg
xdg-mime default mpv.desktop video/mpg
xdg-mime default mpv.desktop video/mpv
xdg-mime default mpv.desktop video/ogv
xdg-mime default mpv.desktop video/webm

sudo ~/graphite-gtk-theme/other/grub2/install.sh -b
~/graphite-gtk-theme/install.sh --tweaks rimless black
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Gruvbox-Plus-Dark'
rm -r ~/graphite-gtk-theme
sudo echo "QT_QPA_PLATFORMTHEME=gtk3" | sudo tee -a /etc/environment

~/Tela-circle-icon-theme/install.sh -d ~/.icons

sudo mkdir -p /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
sudo ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d
echo "autospawn = no" | sudo tee /etc/pulse/client.conf

echo "vm.swappiness = 1" | sudo tee /etc/sysctl.conf
sudo sysctl -p

echo "no wm, dm, or de was installed"

echo "finished, reboot your computer"

rm ~/v.sh

exit 0

