#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  📱 MOBILE HACKING LAB - Ultimate Installer v2.0
#  
#  Features:
#  - Overall progress percentage
#  - GPU acceleration auto-setup (Turnip/Zink)
#  - All hacking tools pre-installed
#  - One-click desktop launch
#  
#  Author: Tech Jarves
#  YouTube: https://youtube.com/@TechJarves
#######################################################
# ============== CONFIGURATION ==============
TOTAL_STEPS=13
CURRENT_STEP=0
# ============== COLORS ==============
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'
# ============== PROGRESS FUNCTIONS ==============
# Update overall progress
update_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    # Create progress bar
    FILLED=$((PERCENT / 5))
    EMPTY=$((20 - FILLED))
    
    BAR="${GREEN}"
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    BAR+="${GRAY}"
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    BAR+="${NC}"
    
    echo ""
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  📊 OVERALL PROGRESS: ${WHITE}Step ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${WHITE}${PERCENT}%${NC}"
    echo -e "${WHITE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}
# Spinner animation for running tasks
spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r  ${YELLOW}⏳${NC} ${message} ${CYAN}${spin:$i:1}${NC}  "
        sleep 0.1
    done
    
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r  ${GREEN}✓${NC} ${message}                    \n"
    else
        printf "\r  ${RED}✗${NC} ${message} ${RED}(failed)${NC}     \n"
    fi
    
    return $exit_code
}
# Install package with progress
install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    
    (yes | pkg install $pkg -y > /dev/null 2>&1) &
    spinner $! "Installing ${name}..."
}
# ============== BANNER ==============
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'BANNER'
    ╔══════════════════════════════════════╗
    ║                                      ║
    ║   🚀  MOBILE HACKLAB v2.1  🚀        ║
    ║                                      ║
    ║       Tech Jarves - YouTube          ║
    ║                                      ║
    ╚══════════════════════════════════════╝
BANNER
    echo -e "${NC}"
    echo ""
}
# ============== DEVICE DETECTION ==============
detect_device() {
    echo -e "${PURPLE}[*] Detecting your device...${NC}"
    echo ""
    
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "arm64-v8a")
    
    # Detect GPU type for driver selection
    GPU_VENDOR=$(getprop ro.hardware.egl 2>/dev/null || echo "")
    
    echo -e "  ${GREEN}📱${NC} Device: ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${GREEN}🤖${NC} Android: ${WHITE}${ANDROID_VERSION}${NC}"
    echo -e "  ${GREEN}⚙️${NC}  CPU: ${WHITE}${CPU_ABI}${NC}"
    
    # Determine GPU driver
    if [[ "$GPU_VENDOR" == *"adreno"* ]] || [[ "$DEVICE_BRAND" == *"samsung"* ]] || [[ "$DEVICE_BRAND" == *"Samsung"* ]] || [[ "$DEVICE_BRAND" == *"oneplus"* ]] || [[ "$DEVICE_BRAND" == *"xiaomi"* ]]; then
        GPU_DRIVER="freedreno"
        echo -e "  ${GREEN}🎮${NC} GPU: ${WHITE}Adreno (Qualcomm) - Turnip driver${NC}"
    else
        GPU_DRIVER="swrast"
        echo -e "  ${GREEN}🎮${NC} GPU: ${WHITE}Software rendering${NC}"
    fi
    
    echo ""
    sleep 1
}
# ============== STEP 1: UPDATE SYSTEM ==============
step_update() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Updating system packages...${NC}"
    echo ""
    
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Updating package lists..."
    
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Upgrading installed packages..."
}
# ============== STEP 2: INSTALL REPOSITORIES ==============
step_repos() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Adding package repositories...${NC}"
    echo ""
    
    install_pkg "x11-repo" "X11 Repository"
    install_pkg "tur-repo" "TUR Repository (Firefox)"
}
# ============== STEP 3: INSTALL TERMUX-X11 ==============
step_x11() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Termux-X11...${NC}"
    echo ""
    
    install_pkg "termux-x11-nightly" "Termux-X11 Display Server"
    install_pkg "xorg-xrandr" "XRandR (Display Settings)"
}
# ============== STEP 4: INSTALL DESKTOP ==============
step_desktop() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing XFCE4 Desktop...${NC}"
    echo ""
    
    install_pkg "xfce4" "XFCE4 Desktop Environment"
    install_pkg "xfce4-terminal" "XFCE4 Terminal"
    install_pkg "thunar" "Thunar File Manager"
}
# ============== STEP 5: INSTALL GPU DRIVERS ==============
step_gpu() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing GPU Acceleration (Turnip/Zink)...${NC}"
    echo ""
    
    install_pkg "mesa-zink" "Mesa Zink (OpenGL over Vulkan)"
    
    if [ "$GPU_DRIVER" == "freedreno" ]; then
        install_pkg "mesa-vulkan-icd-freedreno" "Turnip Adreno GPU Driver"
    else
        install_pkg "mesa-vulkan-icd-swrast" "Software Vulkan Renderer"
    fi
    
    install_pkg "vulkan-loader-android" "Vulkan Loader"
    
    echo -e "  ${GREEN}✓${NC} GPU acceleration configured!"
}
# ============== STEP 6: INSTALL AUDIO ==============
step_audio() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Audio Support...${NC}"
    echo ""
    
    install_pkg "pulseaudio" "PulseAudio Sound Server"
}
# ============== STEP 7: INSTALL BROWSERS & APPS ==============
step_apps() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Applications...${NC}"
    echo ""

    install_pkg "firefox" "Firefox Browser"
    install_pkg "git" "Git Version Control"
    install_pkg "wget" "Wget Downloader"
    install_pkg "curl" "cURL"
}
# ============== STEP 8: INSTALL NETWORK TOOLS ==============
step_network_tools() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Network Scanning Tools...${NC}"
    echo ""
    
    install_pkg "nmap" "Nmap Network Scanner"
    install_pkg "netcat-openbsd" "Netcat"
    install_pkg "whois" "Whois Lookup"
    install_pkg "dnsutils" "DNS Utilities"
    install_pkg "tracepath" "Tracepath"
}
# ============== STEP 9: INSTALL SECURITY TOOLS ==============
step_security_tools() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Security Tools...${NC}"
    echo ""
    
    install_pkg "hydra" "Hydra Password Cracker"
    install_pkg "john" "John the Ripper"
    install_pkg "sqlmap" "SQLMap (SQL Injection)"
    
    # Python tools
    echo -e "  ${YELLOW}⏳${NC} Installing Python security libraries..."
    pip install requests beautifulsoup4 > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Python libraries installed"
}
# ============== STEP 10: INSTALL DEBIAN + METASPLOIT ==============
step_debian_proot() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Debian via proot-distro + Metasploit...${NC}"
    echo ""

    # Install proot-distro
    install_pkg "proot-distro" "PRoot Distro"

    # Install Debian rootfs
    echo -e "  ${YELLOW}⏳${NC} Installing Debian rootfs (this may take a while)..."
    (proot-distro install debian > /dev/null 2>&1) &
    spinner $! "Downloading and extracting Debian..."

    # Bootstrap Debian with core packages
    echo -e "  ${YELLOW}⏳${NC} Setting up Debian environment..."
    (proot-distro login debian -- bash -c "apt update -y && apt upgrade -y && apt install -y sudo curl wget git vim nano net-tools nmap python3 python3-pip build-essential locales openssh-server" > /dev/null 2>&1) &
    spinner $! "Installing core Debian packages..."

    # Install Metasploit inside Debian
    echo -e "  ${YELLOW}⏳${NC} Installing Metasploit Framework in Debian..."
    (proot-distro login debian -- bash -c "curl -fsSL https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > /tmp/msfinstall && chmod 755 /tmp/msfinstall && /tmp/msfinstall" > /dev/null 2>&1) &
    spinner $! "Installing Metasploit (this takes a while)..."

    # Install Android SDK inside Debian
    echo -e "  ${YELLOW}⏳${NC} Setting up Android SDK in Debian..."
    (proot-distro login debian -- bash -c "apt install -y openjdk-17-jdk unzip" > /dev/null 2>&1) &
    spinner $! "Installing OpenJDK 17 in Debian..."

    (proot-distro login debian -- bash -c '
        mkdir -p /opt/android-sdk/cmdline-tools &&
        cd /tmp &&
        curl -fsSL -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip &&
        unzip -qo cmdline-tools.zip &&
        mv cmdline-tools /opt/android-sdk/cmdline-tools/latest &&
        rm -f cmdline-tools.zip
    ' > /dev/null 2>&1) &
    spinner $! "Downloading Android SDK command-line tools..."

    (proot-distro login debian -- bash -c '
        export ANDROID_HOME=/opt/android-sdk
        export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
        yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses > /dev/null 2>&1
        $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "build-tools;35.0.0" "platforms;android-35" "platform-tools"
    ' > /dev/null 2>&1) &
    spinner $! "Installing Android SDK 35 + build-tools (this takes a while)..."

    # Set up Android SDK environment in Debian
    proot-distro login debian -- bash -c '
        cat > /etc/profile.d/android-sdk.sh << "SDKENV"
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/35.0.0:$PATH
SDKENV
    ' > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} Android SDK configured in Debian (SDK 35, build-tools 35.0.0)"

    # Install .NET SDK inside Debian
    echo -e "  ${YELLOW}⏳${NC} Installing .NET SDK in Debian..."
    (proot-distro login debian -- bash -c '
        curl -fsSL https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -o /tmp/packages-microsoft-prod.deb &&
        dpkg -i /tmp/packages-microsoft-prod.deb &&
        rm -f /tmp/packages-microsoft-prod.deb &&
        apt update -y &&
        apt install -y dotnet-sdk-8.0 dotnet-sdk-10.0
    ' > /dev/null 2>&1) &
    spinner $! "Installing .NET 8 LTS + .NET 10 SDK..."

    # Add dotnet to Debian profile
    proot-distro login debian -- bash -c '
        cat >> /etc/profile.d/android-sdk.sh << "DOTNETENV"
export DOTNET_ROOT=/usr/share/dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
DOTNETENV
    ' > /dev/null 2>&1
    echo -e "  ${GREEN}✓${NC} .NET 8 + .NET 10 SDK configured in Debian"

    # Create Debian shell launcher
    cat > ~/start-debian.sh << 'DEBIANEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🐧 Starting Debian Linux Shell..."
echo "   Android SDK, Gradle, and Metasploit are available."
echo "   Type 'exit' to return to Termux."
echo ""
proot-distro login debian
DEBIANEOF
    chmod +x ~/start-debian.sh
    echo -e "  ${GREEN}✓${NC} Created ~/start-debian.sh"

    # Create msfconsole wrapper
    cat > ~/msfconsole.sh << 'MSFEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "💀 Launching Metasploit Framework (inside Debian)..."
echo ""
proot-distro login debian -- msfconsole "$@"
MSFEOF
    chmod +x ~/msfconsole.sh
    echo -e "  ${GREEN}✓${NC} Created ~/msfconsole.sh"

    # Create Debian GUI launcher (X11 + Debian shell with display)
    cat > ~/start-debian-gui.sh << 'DEBGUIEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🐧 Starting Debian with X11 display..."
echo ""

# Start X11 server if not already running
if ! pgrep -f "termux.x11" > /dev/null 2>&1; then
    echo "📺 Starting X11 display server..."
    termux-x11 :0 -ac &
    sleep 3
else
    echo "📺 X11 server already running."
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Open Termux-X11 app to see GUI output."
echo "  Run GUI apps inside Debian normally."
echo "  Type 'exit' to return to Termux."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

proot-distro login debian --shared-tmp -- env DISPLAY=:0 bash -l
DEBGUIEOF
    chmod +x ~/start-debian-gui.sh
    echo -e "  ${GREEN}✓${NC} Created ~/start-debian-gui.sh"

    # Configure sshd inside Debian (port 2222, allow root login)
    echo -e "  ${YELLOW}⏳${NC} Configuring SSH server in Debian..."
    DEBIAN_ROOT_PASS=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 16)
    proot-distro login debian -- bash -c "
        mkdir -p /run/sshd
        sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
        sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
        sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
        echo 'ListenAddress 127.0.0.1' >> /etc/ssh/sshd_config
        echo \"root:${DEBIAN_ROOT_PASS}\" | chpasswd
        ssh-keygen -A
    " > /dev/null 2>&1
    echo "${DEBIAN_ROOT_PASS}" > ~/.debian_ssh_password
    chmod 600 ~/.debian_ssh_password
    echo -e "  ${GREEN}✓${NC} SSH configured (port 2222, user: root)"
    echo -e "  ${GREEN}✓${NC} Password saved to ~/.debian_ssh_password"

    # Create Debian sshd background service script
    cat > ~/debian-sshd.sh << 'SSHDEOF'
#!/data/data/com.termux/files/usr/bin/bash
case "${1:-start}" in
    start)
        if pgrep -f "proot.*debian.*sshd" > /dev/null 2>&1; then
            echo "🐧 Debian sshd is already running."
            exit 0
        fi
        echo "🐧 Starting Debian sshd on port 2222..."
        nohup proot-distro login debian -- /usr/sbin/sshd -D -p 2222 > /dev/null 2>&1 &
        sleep 2
        if pgrep -f "proot.*debian.*sshd" > /dev/null 2>&1; then
            echo "✅ Debian sshd running. Connect with:"
            echo "   ssh root@localhost -p 2222"
            if [ -f ~/.debian_ssh_password ]; then
                echo "   Password: $(cat ~/.debian_ssh_password)"
            else
                echo "   (password file missing — re-run install or reset with chpasswd in Debian)"
            fi
        else
            echo "❌ Failed to start sshd."
        fi
        ;;
    stop)
        echo "🛑 Stopping Debian sshd..."
        pkill -f "proot.*debian.*sshd" 2>/dev/null
        echo "✅ Stopped."
        ;;
    status)
        if pgrep -f "proot.*debian.*sshd" > /dev/null 2>&1; then
            echo "🐧 Debian sshd is running on port 2222."
        else
            echo "🐧 Debian sshd is not running."
        fi
        ;;
    *)
        echo "Usage: bash ~/debian-sshd.sh [start|stop|status]"
        ;;
esac
SSHDEOF
    chmod +x ~/debian-sshd.sh
    echo -e "  ${GREEN}✓${NC} Created ~/debian-sshd.sh (start|stop|status)"
}
# ============== STEP 11: INSTALL ANDROID DEV TOOLS ==============
step_android_dev() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Installing Android Development Tools...${NC}"
    echo ""

    install_pkg "openjdk-17" "Java Development Kit 17"
    install_pkg "aapt2" "AAPT2 (Android Asset Packaging)"
    install_pkg "apksigner" "APK Signer"
    install_pkg "d8" "D8 Dex Compiler"
    install_pkg "android-tools" "ADB & Fastboot"

    echo -e "  ${GREEN}✓${NC} Android dev toolchain ready (javac, aapt2, d8, apksigner, adb)"
}
# ============== STEP 12: CREATE LAUNCHER SCRIPTS ==============
step_launchers() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Creating Launcher Scripts...${NC}"
    echo ""
    
    # GPU Configuration file
    mkdir -p ~/.config
    cat > ~/.config/hacklab-gpu.sh << 'GPUEOF'
# Mobile HackLab - GPU Acceleration Config
export MESA_NO_ERROR=1
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLES_VERSION_OVERRIDE=3.2
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=noconform
export MESA_VK_WSI_PRESENT_MODE=immediate
export ZINK_DESCRIPTORS=lazy
GPUEOF
    echo -e "  ${GREEN}✓${NC} GPU config created"
    
    # Add to bashrc
    if ! grep -q "hacklab-gpu.sh" ~/.bashrc 2>/dev/null; then
        echo 'source ~/.config/hacklab-gpu.sh 2>/dev/null' >> ~/.bashrc
    fi
    
    # Main Desktop Launcher - AUDIO FIXED
    cat > ~/start-hacklab.sh << 'LAUNCHEREOF'
#!/data/data/com.termux/files/usr/bin/bash
echo ""
echo "🚀 Starting Mobile HackLab Desktop..."
echo ""
# Load GPU config
source ~/.config/hacklab-gpu.sh 2>/dev/null
# Kill any existing sessions
echo "🔄 Cleaning up old sessions..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
# === AUDIO SETUP ===
unset PULSE_SERVER
pulseaudio --kill 2>/dev/null
sleep 0.5
echo "🔊 Starting audio server..."
pulseaudio --start --exit-idle-time=-1
sleep 1
pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1 2>/dev/null
export PULSE_SERVER=127.0.0.1
# === END AUDIO ===
# Start Termux-X11 server
echo "📺 Starting X11 display server..."
termux-x11 :0 -ac &
sleep 3
# Set display
export DISPLAY=:0
# Start XFCE Desktop
echo "🖥️ Launching XFCE4 Desktop..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📱 Open the Termux-X11 app to see desktop!"
echo "  🔊 Audio is enabled!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
exec startxfce4
LAUNCHEREOF
    chmod +x ~/start-hacklab.sh
    echo -e "  ${GREEN}✓${NC} Created ~/start-hacklab.sh"
    
    # Quick Tools Menu
    cat > ~/hacktools.sh << 'TOOLSEOF'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
    clear
    echo ""
    echo "╔═══════════════════════════════════════════╗"
    echo "║     🔧 Mobile HackLab - Quick Tools       ║"
    echo "╠═══════════════════════════════════════════╣"
    echo "║  1) 🌐 Nmap - Network Scan                ║"
    echo "║  2) 💉 SQLMap - SQL Injection             ║"
    echo "║  3) 🔑 Hydra - Password Attack            ║"
    echo "║  4) 💀 Metasploit Console                 ║"
    echo "║  5) 🐧 Debian Shell                       ║"
    echo "║  6) 🐧 Debian GUI (X11)                   ║"
    echo "║  7) 🔌 Debian SSH Service                  ║"
    echo "║  8) 📱 Android Dev Tools                  ║"
    echo "║  9) 🖥️  Start Desktop                     ║"
    echo "║ 10) 🔍 Check GPU Status                   ║"
    echo "║  0) ❌ Exit                               ║"
    echo "╚═══════════════════════════════════════════╝"
    echo ""
    read -p "  Select option: " choice
    
    case $choice in
        1) 
            read -p "  Enter target IP/hostname: " target
            nmap -sV $target
            read -p "Press Enter to continue..."
            ;;
        2) 
            read -p "  Enter vulnerable URL: " url
            sqlmap -u "$url" --batch
            read -p "Press Enter to continue..."
            ;;
        3) 
            echo "  Example: hydra -l admin -P wordlist.txt 192.168.1.1 ssh"
            read -p "Press Enter to continue..."
            ;;
        4)
            bash ~/msfconsole.sh
            ;;
        5)
            bash ~/start-debian.sh
            ;;
        6)
            bash ~/start-debian-gui.sh
            ;;
        7)
            echo ""
            echo "  Debian SSH Service:"
            echo "  ───────────────────"
            bash ~/debian-sshd.sh status
            echo ""
            echo "  1) Start   2) Stop   3) Back"
            read -p "  Choose: " sshchoice
            case $sshchoice in
                1) bash ~/debian-sshd.sh start ;;
                2) bash ~/debian-sshd.sh stop ;;
            esac
            read -p "Press Enter to continue..."
            ;;
        8)
            echo ""
            echo "  Android Dev Tools:"
            echo "  ─────────────────"
            echo ""
            echo "  Termux (quick builds):"
            echo "    javac, aapt2, d8, apksigner, adb, fastboot"
            echo ""
            echo "  Debian (full Gradle projects):"
            echo "    bash ~/start-debian.sh"
            echo "    cd /path/to/project && ./gradlew assembleDebug"
            echo ""
            echo "  SDK location (in Debian): /opt/android-sdk"
            echo "  Java (in Debian):         openjdk-17"
            echo "  Platforms:                 android-35"
            echo "  Build tools:              35.0.0"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        9)
            bash ~/start-hacklab.sh
            ;;
        10)
            echo ""
            glxinfo | grep "renderer"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        0)
            exit 0
            ;;
    esac
done
TOOLSEOF
    chmod +x ~/hacktools.sh
    echo -e "  ${GREEN}✓${NC} Created ~/hacktools.sh"
    
    # Desktop Shutdown Script
    cat > ~/stop-hacklab.sh << 'STOPEOF'
#!/data/data/com.termux/files/usr/bin/bash
echo "Stopping Mobile HackLab..."
pkill -9 -f "termux.x11" 2>/dev/null
pkill -9 -f "pulseaudio" 2>/dev/null
pkill -9 -f "xfce" 2>/dev/null
pkill -9 -f "dbus" 2>/dev/null
echo "Desktop stopped."
STOPEOF
    chmod +x ~/stop-hacklab.sh
    echo -e "  ${GREEN}✓${NC} Created ~/stop-hacklab.sh"
}
# ============== STEP 13: CREATE DESKTOP SHORTCUTS ==============
step_shortcuts() {
    update_progress
    echo -e "${PURPLE}[Step ${CURRENT_STEP}/${TOTAL_STEPS}] Creating Desktop Shortcuts...${NC}"
    echo ""
    
    mkdir -p ~/Desktop
    
    # Firefox
    cat > ~/Desktop/Firefox.desktop << 'EOF'
[Desktop Entry]
Name=Firefox
Comment=Web Browser
Exec=firefox
Icon=firefox
Type=Application
Categories=Network;WebBrowser;
EOF
    
    # Terminal
    cat > ~/Desktop/Terminal.desktop << 'EOF'
[Desktop Entry]
Name=Terminal
Comment=XFCE Terminal
Exec=xfce4-terminal
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
EOF
    
    # Metasploit
    cat > ~/Desktop/Metasploit.desktop << 'EOF'
[Desktop Entry]
Name=Metasploit
Comment=Exploitation Framework
Exec=xfce4-terminal -e "bash ~/msfconsole.sh"
Icon=utilities-terminal
Type=Application
Categories=Security;
EOF

    # Debian Terminal
    cat > ~/Desktop/Debian_Terminal.desktop << 'EOF'
[Desktop Entry]
Name=Debian Terminal
Comment=Debian Linux Shell (proot)
Exec=xfce4-terminal -e "bash ~/start-debian.sh"
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
EOF

    # Debian GUI
    cat > ~/Desktop/Debian_GUI.desktop << 'EOF'
[Desktop Entry]
Name=Debian GUI
Comment=Debian Shell with X11 Display
Exec=xfce4-terminal -e "bash ~/start-debian-gui.sh"
Icon=utilities-terminal
Type=Application
Categories=System;TerminalEmulator;
EOF

    # HackTools Menu
    cat > ~/Desktop/HackTools.desktop << 'EOF'
[Desktop Entry]
Name=HackTools Menu
Comment=Quick Security Tools
Exec=xfce4-terminal -e "bash ~/hacktools.sh"
Icon=security-high
Type=Application
Categories=Security;
EOF
    
    chmod +x ~/Desktop/*.desktop 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Desktop shortcuts created"
}
# ============== COMPLETION ==============
show_completion() {
    echo ""
    echo -e "${GREEN}"
    cat << 'COMPLETE'
    
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║         ✅  INSTALLATION COMPLETE!  ✅                        ║
    ║                                                               ║
    ║              🎉 100% - All Done! 🎉                           ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
    
COMPLETE
    echo -e "${NC}"
    
    echo -e "${WHITE}📱 Your Mobile Hacking Lab is ready!${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}🚀 TO START THE DESKTOP:${NC}"
    echo -e "   ${GREEN}bash ~/start-hacklab.sh${NC}"
    echo ""
    echo -e "${WHITE}🔧 FOR QUICK TOOLS MENU:${NC}"
    echo -e "   ${GREEN}bash ~/hacktools.sh${NC}"
    echo ""
    echo -e "${WHITE}🐧 DEBIAN SHELL (no GUI):${NC}"
    echo -e "   ${GREEN}bash ~/start-debian.sh${NC}"
    echo ""
    echo -e "${WHITE}🐧 DEBIAN WITH X11 (for GUI apps):${NC}"
    echo -e "   ${GREEN}bash ~/start-debian-gui.sh${NC}"
    echo ""
    echo -e "${WHITE}🔌 DEBIAN SSH SERVICE:${NC}"
    echo -e "   ${GREEN}bash ~/debian-sshd.sh start${NC}   (start background sshd)"
    echo -e "   ${GREEN}ssh root@localhost -p 2222${NC}    (connect, pass: REDACTED)"
    echo -e "   ${GREEN}bash ~/debian-sshd.sh stop${NC}    (stop sshd)"
    echo ""
    echo -e "${WHITE}💀 TO LAUNCH METASPLOIT:${NC}"
    echo -e "   ${GREEN}bash ~/msfconsole.sh${NC}"
    echo ""
    echo -e "${WHITE}🛑 TO STOP THE DESKTOP:${NC}"
    echo -e "   ${GREEN}bash ~/stop-hacklab.sh${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}📦 INSTALLED TOOLS:${NC}"
    echo -e "   • Nmap, Netcat, DNS tools"
    echo -e "   • SQLMap, Hydra, John the Ripper"
    echo -e "   • Metasploit Framework (in Debian)"
    echo -e "   • Debian Linux (via proot-distro)"
    echo -e "   • Android SDK 35 + Gradle support (in Debian)"
    echo -e "   • .NET 8 LTS + .NET 10 SDK (in Debian)"
    echo -e "   • Android Dev Tools (javac, aapt2, d8, apksigner, adb)"
    echo -e "   • Firefox, Git"
    echo -e "   • XFCE4 Desktop + GPU Acceleration"
    echo ""
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  📺 Subscribe: https://youtube.com/@TechJarves${NC}"
    echo -e "${CYAN}  🎬 Tutorial:  [YOUR VIDEO URL]${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${WHITE}⚡ TIP: Open Termux-X11 app first, then run start-hacklab.sh${NC}"
    echo ""
}
# ============== MAIN INSTALLATION ==============
main() {
    show_banner
    
    echo -e "${WHITE}  This script will install a complete Linux desktop with${NC}"
    echo -e "${WHITE}  hacking tools and GPU acceleration on your Android phone.${NC}"
    echo ""
    echo -e "${GRAY}  Estimated time: 15-30 minutes (depends on internet speed)${NC}"
    echo ""
    echo -e "${YELLOW}  Press Enter to start installation, or Ctrl+C to cancel...${NC}"
    read
    
    # Run all steps
    detect_device
    step_update
    step_repos
    step_x11
    step_desktop
    step_gpu
    step_audio
    step_apps
    step_network_tools
    step_security_tools
    step_debian_proot
    step_android_dev
    step_launchers
    step_shortcuts
    
    # Show completion
    show_completion
}
# ============== RUN ==============
main
