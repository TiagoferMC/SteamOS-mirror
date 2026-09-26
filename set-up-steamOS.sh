#!/usr/bin/env bash

# Globals
UNLOCK=1
INSTALL=1
GROUP=1
CONFIGURE=1
ZSH=1

# Install categories
BASE=1
NETWORK=1
DISK=1
AUDIO=1
INPUT=1
HEADERS=1
GAME=1
IMAGE=1
ARCHIVE=1
VIDEO=1

# Group categories
BASE_GROUP=1
NETWORK_GROUP=1

# Configure categories
DNSCRYPT=1
OPENSSH=1
NOIP=1
WIREGUARD=1
FIREWALL=1
V4L2LOOPBACK=1
WACOM=1

usage () {
    echo "Usage: ./$0 [-u -i *option* -g *option* -c *option* -z]

FLAGS:
-u --unlock
-i --install  all base network disk audio input headers game image archive video
-g --groups   base network
-c --configure dnscrypt openssh noip wireguard v4l2lookback
-z --zsh
"
}

parse_args () {
    # If first flag is positive (not -x), we want to invert the default behavior
    if [[ $1 != "-x" && $1 != "--exclude" ]]; then
        # Globals
        UNLOCK=0
        INSTALL=0
        GROUP=0
        CONFIGURE=0
        ZSH=0

        # Install categories
        BASE=0
        NETWORK=0
        DISK=0
        AUDIO=0
        INPUT=0
        HEADERS=0
        GAME=0
        IMAGE=0
        ARCHIVE=0
        VIDEO=0

        # Group categories
        BASE_GROUP=0
        NETWORK_GROUP=0

        # Configure categories
        DNSCRYPT=0
        OPENSSH=0
        NOIP=0
        WIREGUARD=0
        FIREWALL=0
        V4L2LOOPBACK=0
        WACOM=0
    fi

    local options="hui:g:c:zx:"
    local -a long_options=(help
                           init
                           unlock
                           install:
                           group:
                           configure:
                           config:
                           conf:
                           zsh
                           exclude:
                           ignore:)

    if ! parsed="$(IFS=,; getopt -o "$options" -l "${long_options[*]}" -- "$@")"
    then
        usage >&2
        exit 1
    fi

    eval set -- "$parsed"

    while true; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -u|--unlock|--init)
                UNLOCK=1
                shift
                ;;
            -i|--install)
                INSTALL=1
                case "$2" in
                    all)
                        BASE=1
                        NETWORK=1
                        DISK=1
                        AUDIO=1
                        INPUT=1
                        HEADERS=1
                        GAME=1
                        IMAGE=1
                        ARCHIVE=1
                        VIDEO=1
                        GROUP=1
                        BASE_GROUP=1
                        NETWORK_GROUP=1
                        shift
                        ;;
                    base)
                        BASE=1
                        GROUP=1
                        shift
                        ;;
                    network)
                        NETWORK=1
                        GROUP=1
                        shift
                        ;;
                    disk)
                        DISK=1
                        shift
                        ;;
                    audio)
                        AUDIO=1
                        shift
                        ;;
                    input)
                        INPUT=1
                        shift
                        ;;
                    headers)
                        HEADERS=1
                        shift
                        ;;
                    game)
                        GAME=1
                        shift
                        ;;
                    image)
                        IMAGE=1
                        shift
                        ;;
                    archive)
                        ARCHIVE=1
                        shift
                        ;;
                    video)
                        VIDEO=1
                        shift
                        ;;
                    *)
                        break
                        ;;
                    esac
                shift
                ;;
            -g|--group|--groups)
                GROUP=1
                case "$2" in
                    all)
                        BASE_GROUP=1
                        NETWORK_GROUP=1
                        shift
                        ;;
                    base)
                        BASE_GROUP=1
                        shift
                        ;;
                    network)
                        NETWORK_GROUP=1
                        shift
                        ;;
                    *)
                        break
                        ;;
                esac
                shift
                ;;
            -c|--configure|--config|--conf)
                CONFIGURE=1
                case "$2" in
                    all)
                        DNSCRYPT=1
                        OPENSSH=1
                        NOIP=1
                        WIREGUARD=1
                        FIREWALL=1
                        V4L2LOOPBACK=1
                        WACOM=1
                        shift
                        ;;
                    dnscrypt)
                        DNSCRYPT=1
                        shift
                        ;;
                    openssh|ssh)
                        OPENSSH=1
                        shift
                        ;;
                    noip)
                        NOIP=1
                        shift
                        ;;
                    wireguard)
                        WIREGUARD=1
                        shift
                        ;;
                    firewall)
                        FIREWALL=1
                        shift
                        ;;
                    v4l2loopback|v4l2)
                        V4L2LOOPBACK=1
                        shift
                        ;;
                    wacom|tablet)
                        WACOM=1
                        shift
                        ;;
                    *)
                        break
                        ;;
                    esac
                shift
                ;;
            -z|--zsh)
                ZSH=1
                shift
                ;;
            -x|--exclude|--ignore)
                case "$2" in
                    unlock|init)
                        UNLOCK=0
                        shift
                        ;;
                    install)
                        INSTALL=0
                        BASE=0
                        NETWORK=0
                        DISK=0
                        AUDIO=0
                        INPUT=0
                        HEADERS=0
                        GAME=0
                        IMAGE=0
                        ARCHIVE=0
                        VIDEO=0
                        shift
                        ;;
                    base)
                        BASE=0
                        shift
                        ;;
                    network)
                        NETWORK=0
                        shift
                        ;;
                    disk)
                        DISK=0
                        shift
                        ;;
                    audio)
                        AUDIO=0
                        shift
                        ;;
                    input)
                        INPUT=0
                        shift
                        ;;
                    headers)
                        HEADERS=0
                        shift
                        ;;
                    game)
                        GAME=0
                        shift
                        ;;
                    image)
                        IMAGE=0
                        shift
                        ;;
                    archive)
                        ARCHIVE=0
                        shift
                        ;;
                    video)
                        VIDEO=0
                        shift
                        ;;
                    group|groups)
                        GROUP=0
                        BASE_GROUP=0
                        NETWORK_GROUP=0
                        shift
                        ;;
                    configure|config|conf)
                        CONFIGURE=0
                        DNSCRYPT=0
                        OPENSSH=0
                        NOIP=0
                        WIREGUARD=0
                        FIREWALL=0
                        V4L2LOOPBACK=0
                        WACOM=0
                        shift
                        ;;
                    dnscrypt)
                        DNSCRYPT=0
                        shift
                        ;;
                    openssh|ssh)
                        OPENSSH=0
                        shift
                        ;;
                    noip)
                        NOIP=0
                        shift
                        ;;
                    wireguard)
                        WIREGUARD=0
                        shift
                        ;;
                    firewall)
                        FIREWALL=0
                        shift
                        ;;
                    v4l2loopback|v4l2)
                        V4L2LOOPBACK=0
                        shift
                        ;;
                    wacom|tablet)
                        WACOM=0
                        shift
                        ;;
                    zsh)
                        ZSH=0
                        shift
                        ;;
                    *)
                        break
                        ;;
                    esac
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "$1"
                usage >&2
                exit 1
                ;;
        esac
    done

    if [[ -n $* ]]; then usage >&2; exit 1; fi
}

clean() {
    paru -Scc --noconfirm
}

install() {
    paru -Syu --needed --noconfirm --overwrite '*' "$@"
    clean
}

install_packages () {
    # Base utilities
    # util-linux is already required by base, as well as sed and (g)awk
    local -a base=(base base-devel moreutils bash zsh zsh-autosuggestions bat
                   eza skim fzf ripgrep repgrep fd ttf-firacode-nerd)
    [[ $BASE == 1 ]] && install "${base[@]}"

    # Network utilities
    # gnu-netcat and openbsd-netcat are both options
    # doggo is aur-only for now
    local -a network=(iproute2 net-tools bind iptables nftables openssh mosh
                      netstat-nat nmap masscan vulscan openbsd-netcat iperf dog
                      iftop avahi whois ngrep hping miniupnpc miniupnpd coturn
                      tcpflow curl curlie httpie websocat wget traceroute mtr
                      nload vnstat speedtest-cli tcpdump termshark ufw gufw
                      ufw-extras conntrack-tools wireshark-qt wireshark-cli
                      geoip2-database dnscrypt-proxy wireguard-tools noip)
    [[ $NETWORK == 1 ]] && install "${network[@]}"

    # DIsk utilities
    local -a disk=(testdisk rsync)
    [[ $DISK == 1 ]] && install "${disk[@]}"

    # Audio utilities
    local -a audio=(realtime-privileges)
    [[ $AUDIO == 1 ]] && install "${audio[@]}"

    # Input utilities
    local -a input=(xf86-input-wacom xf86-input-elographics onboard)
    [[ $INPUT == 1 ]] && install "${input[@]}"

    # Linux headers
    local -a headers
    [[ $HEADERS == 1 ]] && mapfile -t headers < <(pacman -Qq \
        | awk '/^linux(-[a-z0-9]+)*$/ && !/-headers/ && !/linux-firmware/ \
               { print $0 "-headers" }')
    [[ $HEADERS == 1 ]] && install "${headers[@]}"

    # Game utilitiess
    local -a game=(mangohud lib32-mangohud gamemode gamescope lib32-gamescope
                   xdg-desktop-portal-gamescope waydroid-helper-bin scopebuddy)
    [[ $GAME == 1 ]] && install "${game[@]}"

    # Image utilities
    local -a image=(ffmpeg imagemagick ghostscript jbigkit libheif libjxl libraw
                    libjpeg-turbo librsvg libtiff libultrahdr libwebp openjpeg2
                    libwmf libzip ocl-icd openexr openjpeg2 djvulibre pango
                    kdegraphics-thumbnailers qt5-imageformats qt6-imageformats
                    kimageformats kimageformats5 ffmpegthumbs ffmpegthumbnailer)
    [[ $IMAGE == 1 ]] && install "${image[@]}"

    # Archive utilities
    local -a archive=(karchive karchive5 arj lrzip lzop 7zip unarchiver unrar)
    [[ $ARCHIVE == 1 ]] && install "${archive[@]}"

    # Video utilities
    local -a video=(scrcpy)
    [[ $VIDEO == 1 ]] && install "${video[@]}"
}

add_groups () {
    local -a groups=()

    # consider libvirt
    local -a base=(wheel render video audio input uinput plugdev realtime)
    [[ $BASE_GROUP == 1 ]] && groups+=("${base[@]}")

    local -a network=(wireshark)
    [[ $NETWORK_GROUP == 1 ]] && groups+=("${network[@]}")

    IFS=,; sudo usermod -aG "${groups[*]}" "$USER"
}

config_dnscrypt() {
    echo "Configuring dnscrypt-proxy..."
    sudo cp -r ./etc/dnscrypt-proxy ./etc/NetworkManager ./etc/systemd /etc
    sudo systemctl enable dnscrypt-proxy
}

config_openssh() {
    echo "Configuring OpenSSH..."
    sudo cp -r ./etc/ssh /etc
    sudo systemctl enable sshd
}

config_noip() {
    echo "Configuring no-ip..."
    sudo mkdir -p /etc/default
    sudo cp -r ./etc/default/noip-duc /etc/default
    sudo systemctl enable noip
}

config_wireguard() {
    echo "Configuring Wireguard..."
    sudo cp -r ./etc/wireguard /etc
    sudo systemctl enable wg-quick@wg0
}

config_firewall() {
    echo "Configuring Firewall..."

    sudo ufw allow 25565                                    # Minecraft
    sudo ufw allow 50000                                    # qBitTorrent
    sudo ufw allow 22/tcp                                   # SSH
    sudo ufw allow 60000:61000/udp                          # Mosh
    sudo ufw allow 51820/udp                                # Wireguard
    sudo ufw allow in on wg0 to any port 5900               # VNC on Wireguard
    sudo ufw deny in on wlan0 to any port 5900              # VNC on Wi-Fi
    sudo ufw deny in on enp4s0f3u1u4c2 to any port 5900     # VNC on Ethernet
    sudo systemctl enable ufw
    sudo ufw enable
}

config_wacom() {
    echo "Configuring Wacom Tablet..."
    sudo mkdir -p /etc/udev/rules.d
    sudo cp -r ./etc/udev/rules.d/99-wacom-rotation.rules /etc/udev/rules.d
}

config_v4l2loopback () {
    echo "Configuring V4L2loopback..."
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

config_services () {
    pushd .
    cd "${BASH_SOURCE%/*}" || exit 2
    [[ $DNSCRYPT == 1 ]] && config_dnscrypt
    [[ $OPENSSH == 1 ]] && config_openssh
    [[ $NOIP == 1 ]] && config_noip
    [[ $WIREGUARD == 1 ]] && config_wireguard
    [[ $FIREWALL == 1 ]] && config_firewall
    [[ $V4L2LOOPBACK == 1 ]] && config_v4l2loopback
    [[ $WACOM == 1 ]] && config_wacom
    popd || exit 2
}

update_zsh () {
    if ! zsh -i -c "omz update"; then
        echo "oh-my-zsh update failed" >&2
    fi
}

main () {

    if [[ -n "$*"  ]]; then
        parse_args "$@"
    fi

    [[ $UNLOCK == 1 ]] && sudo steamos-devmode enable --no-prompt

    [[ $INSTALL == 1 ]] && install_packages

    [[ $GROUP == 1 ]] && add_groups

    [[ $CONFIGURE == 1 ]] && config_services

    [[ $ZSH == 1 ]] && update_zsh

    return 0
}

main "$@"

