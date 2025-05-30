#!/bin/dash

# Change to the vsh directory and move its contents to home
cd ~/vsh
find . -maxdepth 1 -mindepth 1 -exec mv -f {} ~ \;
cd

# Update system and install repo packages
sudo xbps-install -yu xbps 
sudo xbps-install -Syu void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland_mirror.conf
echo 'repository=https://github.com/index-0/librewolf-void/releases/latest/download/' > /etc/xbps.d/20-librewolf.conf
sudo xbps-install -Syu base-devel rustup
rustup default stable

# Install packages
packages="ayatana-appindicator3-devel btop blender cairo-devel cmake fastfetch font-awesome fontconfig galculator gimp gettext git github-cli gstreamer1.0-devel gtk3 gtk-engine-murrine gtk-layer-shell hyprcursor hypridle hyprlang hyprlock hyprpaper hyprutils hyprwayland-scanner hyprland-devel hyprland-protocols libdrm-devel libgbm-devel libglvnd-devel libinput-devel libjxl-devel libjpeg-turbo-devel libnotify-devel libseat-devel libwebp-devel libxkbcommon-devel libreoffice librewolf mako mpv ninja neovim pango-devel pavucontrol perl pipewire prismlauncher qbittorrent re2-devel slurp steam starship tomlplusplus unzip wayland-devel wayland-protocols wev wl-clipboard wofi wine-gecko wine-mono xdg-desktop-portal-hyprland yazi zsh"
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
git clone https://github.com/shixue/Hyprshot
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
