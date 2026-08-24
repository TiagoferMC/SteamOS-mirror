#!/usr/bin/env bash

install() {
    paru -Syu --needed --overwrite '*' "$@"
    clean
}

clean() {
    paru -Scc --noconfirm
}

setup_dnscrypt() {
    sudo cp -r ./etc/* /etc
    sudo systemctl enable dnscrypt-proxy
}

setup_openssh() {
    sudo systemctl enable sshd
}

setup_noip() {
    sudo systemctl enable noip
}

setup_wireguard() {
    sudo systemctl enable wg-quick@wg0
}

setup_v4l2loopback () {
    git clone https://github.com/v4l2loopback/v4l2loopback.git
    cd v4l2loopback || exit 2
    make v4l2loopback
    sudo make install
    cd ..
    rm -rf v4l2loopback/

    local -a v4l2loopback_parameters=(
        "devices=2"
        "video_nr=10,11"
        'card_label="OBS Virtual Camera","scrcpy"'
        "exclusive_caps=1,1"
    )

    sudo modprobe v4l2loopback "${v4l2loopback_parameters[@]}"
    echo v4l2loopback | sudo tee /etc/modules-load.d/v4l2loopback.conf
    echo "options v4l2loopback ${v4l2loopback_parameters[*]}" \
        | sudo tee /etc/modprobe.d/v4l2loopback.conf
}

main() {
    sudo steamos-devmode enable --no-prompt
    local -a base=(base base-devel moreutils bash zsh zsh-autosuggestions
                   ttf-firacode-nerd)
    local -a network=(net-tools openssh wireshark-qt geoip2-database bind ufw
                      ufw-extras gufw dnscrypt-proxy wireguard-tools mosh noip)
    local -a disk=(testdisk rsync)
    local -a audio=(realtime-privileges)
    local -a input=(xf86-input-wacom xf86-input-elographics onboard)
    local -a headers
    mapfile -t headers < <(pacman -Qq \
        | awk '/^linux(-[a-z0-9]+)*$/ && !/-headers/ && !/linux-firmware/ \
               { print $0 "-headers" }')
    local -a game=(mangohud lib32-mangohud gamemode gamescope lib32-gamescope
                   xdg-desktop-portal-gamescope waydroid-helper-bin scopebuddy)
    local -a image=(ffmpeg imagemagick ghostscript jbigkit libheif libjxl libraw
                    libjpeg-turbo librsvg libtiff libultrahdr libwebp openjpeg2
                    libwmf libzip ocl-icd openexr openjpeg2 djvulibre pango
                    kdegraphics-thumbnailers qt5-imageformats qt6-imageformats
                    kimageformats kimageformats5 ffmpegthumbs ffmpegthumbnailer)
    local -a archive=(karchive karchive5 arj lrzip lzop 7zip unarchiver unrar)
    local -a video=(scrcpy)

    local -a packages=()
    packages+=("${base[@]}")
    packages+=("${network[@]}")
    packages+=("${disk[@]}")
    packages+=("${audio[@]}")
    packages+=("${input[@]}")
    packages+=("${headers[@]}")
    packages+=("${game[@]}")
    packages+=("${image[@]}")
    packages+=("${archive[@]}")
    packages+=("${video[@]}")

    install "${packages[@]}"

    local groups=(libvirt render video audio input uinput plugdev realtime
                  wireshark wheel)
    sudo usermod -aG "${groups[@]}" "$USER"

    cd "${BASH_SOURCE%/*}" || exit 2
    setup_dnscrypt
    setup_openssh
    setup_noip
    setup_wireguard
    setup_v4l2loopback

    omz update
}

main

