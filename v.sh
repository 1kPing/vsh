#!/bin/dash

# Change to the vsh directory and move its contents to home
cd ~/vsh
find . -maxdepth 1 -mindepth 1 -exec mv -f {} ~ \;
cd

# Update system and install repo packages
sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hypr-mirror.conf
echo "repository=https://github.com/index-0/librewolf-void/releases/latest/download/" | sudo tee /etc/xbps.d/librewolf-mirror.conf
sudo xbps-install -Syu base-devel curl git
sudo xbps-install -Syu
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"

# Install packages
packages="dbus blender btop cairo-devel cmake eog fastfetch font-awesome fontconfig foot galculator gcc gettext gimp gnome-keyring gnome-themes-extra grim gstreamer1-devel gtk+3 gtk-engine-murrine gtk-layer-shell gzip hyprcursor hypridle hyprland hyprland-devel hyprland-protocols hyprlang hyprlock hyprpaper hyprutils hyprwayland-scanner jq libayatana-appindicator-devel libdrm-devel libgbm-devel libglvnd-devel libinput-devel libjpeg-turbo-devel libjxl-devel libnotify-devel libreoffice librewolf libseat-devel libwebp-devel libxkbcommon-devel make mako mpv neovim ninja nwg-look pam-devel pango-devel pavucontrol perl pipewire PrismLauncher python3 qbittorrent re2-devel sassc sdbus-cpp Signal-Desktop slurp starship steam tomlplusplus ufw unzip Waybar wayland-devel wayland-protocols wev wget wine-gecko wine-mono wl-clipboard wofi xdg-desktop-portal-hyprland yazi zig zsh"
sudo xbps-install -Syu $packages

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

mkdir ~/.icons

git clone https://github.com/jmattheis/gruvbox-dark-icons-gtk ~/.icons/gruvbox-dark-icons-gtk

gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'

git clone https://github.com/elkowar/eww
cd ~/eww
cargo build --release --no-default-features --features=wayland
chmod +x ~/eww/target/release/eww
mkdir ~/bin
mv ~/eww/target/release/eww ~/bin
cd
rm -rf ~/eww

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


echo "Finished, reboot your computer"
