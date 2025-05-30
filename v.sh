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
sudo xbps-install -Syu base-devel curl
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install packages
packages="blender btop cairo-devel cmake eog fastfetch font-awesome fontconfig foot galculator gcc gettext gimp gnome-keyring gnome-themes-extra grim gstreamer1-devel gtk+3 gtk-engine-murrine gtk-layer-shell gzip hyprcursor hypridle hyprland hyprland-devel hyprland-protocols hyprlang hyprlock hyprpaper hyprutils hyprwayland-scanner jq libayatana-appindicator-devel libdrm-devel libgbm-devel libglvnd-devel libinput-devel libjpeg-turbo-devel libjxl-devel libnotify-devel libreoffice librewolf libseat-devel libwebp-devel libxkbcommon-devel mako mpv neovim ninja nwg-look pango-devel pavucontrol perl pipewire PrismLauncher python-clickgen python3 qbittorrent re2-devel sdbus-cpp Signal-Desktop slurp starship steam tomlplusplus tuigreet ufw unzip Waybar wayland-devel wayland-protocols wev wine-gecko wine-mono wl-clipboard wofi xdg-desktop-portal-hyprland yazi zsh"
sudo xbps-install -y $packages

# Hyprsunset
git clone https://github.com/hyprwm/hyprsunset
cd hyprsunset
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build
cd ..
rm -rf hyprsunset

# ttf-cascadia-code
wget https://github.com/microsoft/cascadia-code/releases/download/v2404.23/CascadiaCode-2404.23.zip
unzip CascadiaCode-2404.23.zip -d /tmp/cascadia
sudo mv /tmp/cascadia/ttf/* /usr/share/fonts/
fc-cache -f
rm -rf /tmp/cascadia CascadiaCode-2404.23.zip

# alarm-clock-applet
git clone https://github.com/alarm-clock-applet/alarm-clock
cd alarm-clock
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build
cd ..
rm -rf alarm-clock

# Hyprshot
git clone https://github.com/Gustash/Hyprshot
cd Hyprshot
chmod +x hyprshot.sh
sudo mv hyprshot.sh /usr/local/bin/hyprshot
cd ..
rm -rf Hyprshot

# Bibata-cursor-theme
git clone https://github.com/ful1e5/Bibata_Cursor
cd Bibata_Cursor
make build
sudo make install
cd ..
rm -rf Bibata_Cursor

# Gruvbox-dark-icons-gtk
git clone https://github.com/jmattheis/gruvbox-dark-icons-gtk
cd gruvbox-dark-icons-gtk
mkdir -p ~/.icons
cp -r gruvbox-dark-icons-gtk ~/.icons/
cd ..
rm -rf gruvbox-dark-icons-gtk

###

echo "Do you want to install flatpak, flathub, and discord? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.discordapp.Discord -y
fi

echo "Do you want to install amd microcode? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y amd-ucode
fi

echo "Do you want to install nvidia stuff? (y/n)"
read answer
if [ "$answer" = "y" ]; then
    sudo xbps-install -y libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit nvidia nvidia-libs-32bit
fi

# Set default web browser
xdg-settings set default-web-browser librewolf.desktop

# Enable greetd service
sudo ln -s /etc/sv/greetd /var/service/

# Configure greetd to use tuigreet
echo "[terminal]
vt = 1
[default_session]
command = \"tuigreet\"
user = \"greeter\"" | sudo tee /etc/greetd/config.toml

# Install and set up GTK theme
cd graphite-gtk-theme
./install.sh --tweaks rimless black
cd

# Set GTK and icon themes
gsettings set org.gnome.desktop.interface gtk-theme 'Graphite-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'gruvbox-dark-icons-gtk'

# Install eww
git clone https://github.com/elkowar/eww
cd eww
cargo build --release --no-default-features --features=wayland
chmod +x target/release/eww
mv target/release/eww ~/bin/
cd ..
rm -rf eww

# Clean up
rm -rf .git
rm -r vsh
rm -r graphite-gtk-theme
rm LICENSE
rm README.md
rm NOTES
rm a.sh

echo "Finished, reboot your computer"
