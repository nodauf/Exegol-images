#!/bin/bash
# Author: The Exegol Project

source common.sh

function install_misc_apt_tools() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing misc apt tools"
    fapt rlwrap imagemagick ascii rsync yq xq

    add-history rlwrap
    add-history imagemagick
    add-history rsync

    add-test-command "rlwrap --version"                            # Reverse shell utility
    add-test-command "convert -version"                            # Copy, modify, and distribute image
    add-test-command "rsync -h"                                    # File synchronization tool for efficiently copying and updating data between local or remote locations.

    add-to-list "rlwrap,https://github.com/hanslub42/rlwrap,rlwrap is a small utility that wraps input and output streams of executables / making it possible to edit and re-run input history"
    add-to-list "imagemagick,https://github.com/ImageMagick/ImageMagick,ImageMagick is a free and open-source image manipulation tool used to create / edit / compose / or convert bitmap images."
    add-to-list "rsync,https://packages.debian.org/sid/rsync,File synchronization tool for efficiently copying and updating data between local or remote locations"
}

function install_goshs() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing goshs"
    go install -v github.com/patrickhener/goshs@latest
    asdf reshim golang
    add-history goshs
    add-test-command "goshs -v"
    add-to-list "goshs,https://github.com/patrickhener/goshs,Goshs is a replacement for Python's SimpleHTTPServer. It allows uploading and downloading via HTTP/S with either self-signed certificate or user provided certificate and you can use HTTP basic auth."
}

function install_shellerator() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing shellerator"
    pipx install --system-site-packages git+https://github.com/ShutdownRepo/shellerator
    add-history shellerator
    add-test-command "shellerator --help"
    add-to-list "shellerator,https://github.com/ShutdownRepo/Shellerator,a simple command-line tool for generating shellcode"
}

function install_uberfile() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing uberfile"
    pipx install --system-site-packages git+https://github.com/ShutdownRepo/uberfile
    add-history uberfile
    add-test-command "uberfile --help"
    add-to-list "uberfile,https://github.com/ShutdownRepo/Uberfile,Uberfile is a simple command-line tool aimed to help pentesters quickly generate file downloader one-liners in multiple contexts (wget / curl / powershell / certutil...). This project code is based on my other similar project for one-liner reverseshell generation Shellerator."
}

function install_arsenal() {
    colorecho "Installing arsenal"
    pipx install --system-site-packages git+https://github.com/Orange-Cyberdefense/arsenal
    add-aliases arsenal
    add-history arsenal
    add-test-command "arsenal --version"
    add-to-list "arsenal,https://github.com/Orange-Cyberdefense/arsenal,Powerful weapons for penetration testing."
}

function install_whatportis() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing whatportis"
    pipx install --system-site-packages whatportis
    # TODO : FIX : "port": port[1] if port[1] else "---",list index out of range - cli.py
    # echo y | whatportis --update
    add-history whatportis
    add-test-command "whatportis --version"
    add-to-list "whatportis,https://github.com/ncrocfer/whatportis,Command-line tool to lookup port information"
}

function install_searchsploit() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing searchsploit"
    if [[ ! -d "/opt/tools/exploitdb" ]]
    then
        git -C /opt/tools/ clone --depth 1 https://gitlab.com/exploit-database/exploitdb
        add-history searchsploit
        add-test-command "searchsploit --help; searchsploit --help |& grep 'You can use any number of search terms'"
        add-to-list "searchsploit,https://gitlab.com/exploit-database/exploitdb,A command line search tool for Exploit-DB"
    else
        colorecho "Searchsploit is already installed"
    fi
    ln -sf /opt/tools/exploitdb/searchsploit /opt/tools/bin/searchsploit
    cp -n /opt/tools/exploitdb/.searchsploit_rc ~/
    sed -i 's/\(.*[pP]aper.*\)/#\1/' ~/.searchsploit_rc
    sed -i 's/opt\/exploitdb/opt\/tools\/exploitdb/' ~/.searchsploit_rc
}

function install_triliumnext() {
    colorecho "Installing TriliumNext"
    fapt libpng16-16 libpng-dev pkg-config autoconf libtool build-essential nasm libx11-dev libxkbfile-dev
    # https://github.com/TriliumNext/Notes/issues/1890
    local temp_fix_limit="2025-07-01"
    if check_temp_fix_expiry "$temp_fix_limit"; then
      git -C /opt/tools/ clone --branch v0.93.0 --depth 1 https://github.com/triliumnext/notes.git triliumnext
    fi
    #git -C /opt/tools/ clone --depth 1 https://github.com/triliumnext/notes.git triliumnext
    cd /opt/tools/triliumnext || exit
    zsh -c "source ~/.zshrc && nvm use default && npm install"
    mkdir /opt/tools/triliumnext/data
    # config.ini contains the exposition port and host
    cp -v /root/sources/assets/triliumnext/config.ini /opt/tools/triliumnext/data/config.ini
    cp -v /root/sources/assets/triliumnext/triliumnext-manager.sh /opt/tools/triliumnext/triliumnext-manager.sh
    chmod +x /opt/tools/triliumnext/triliumnext-manager.sh
    /opt/tools/triliumnext/triliumnext-manager.sh start
    /opt/tools/triliumnext/triliumnext-manager.sh configure
    /opt/tools/triliumnext/triliumnext-manager.sh stop
    add-aliases triliumnext
    add-history triliumnext
    add-test-command "triliumnext-test"
    add-to-list "TriliumNext,https://github.com/TriliumNext/Notes,Personal knowledge management system (successor to Trilium)."
}

function install_ngrok() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing ngrok"
    if [[ $(uname -m) = 'x86_64' ]]
    then
        wget -O /tmp/ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
    elif [[ $(uname -m) = 'aarch64' ]]
    then
        wget -O /tmp/ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
    elif [[ $(uname -m) = 'armv7l' ]]
    then
        wget -O /tmp/ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.tgz
    else
        criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    fi
    tar xvzf /tmp/ngrok.tgz -C /opt/tools/bin
    add-history ngrok
    add-test-command "ngrok version"
    add-to-list "ngrok,https://github.com/inconshreveable/ngrok,Expose a local server behind a NAT or firewall to the internet"
}

function install_objectwalker() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing objectwalker"
    pipx install --system-site-packages git+https://github.com/p0dalirius/objectwalker
    add-history objectwalker
    add-test-command "objectwalker --help"
    add-to-list "objectwalker,https://github.com/p0dalirius/objectwalker,A python module to explore the object tree to extract paths to interesting objects in memory."
}

function install_tig() {
    # CODE-CHECK-WHITELIST=add-aliases,add-history
    colorecho "Installing tig"
    git -C /tmp clone --depth 1 https://github.com/jonas/tig.git
    cd /tmp/tig || exit
    make -j
    make install bindir=/opt/tools/bin sysconfdir=/etc
    # Need add-history ?
    add-test-command "tig --help"
    add-to-list "tig,https://github.com/jonas/tig,Tig is an ncurses-based text-mode interface for git."
}

function install_yt-dlp() {
    # CODE-CHECK-WHITELIST=add-aliases,add-history
    colorecho "Installing yt-dlp"
    pipx install --system-site-packages git+https://github.com/yt-dlp/yt-dlp
    add-test-command "yt-dlp --help"
    add-to-list "yt-dlp,https://github.com/yt-dlp/yt-dlp,A youtube-dl fork with additional features and fixes"
}

function install_cyberchef() {
    # CODE-CHECK-WHITELIST=add-aliases,add-history
    colorecho "Installing CyberChef"
    local last_release
    last_release=$(curl --location --silent "https://api.github.com/repos/gchq/CyberChef/releases/latest"|grep browser_download_url|awk '{print $2}'|tr -d '"')
    echo "$last_release"
    if [[ -z "$last_release" ]]; then
        criticalecho-noexit "Latest release not found" && return
    fi
    mkdir -p /opt/tools/CyberChef
    wget "$last_release" -O /tmp/CyberChef.zip
    unzip -o /tmp/CyberChef.zip -d /opt/tools/CyberChef/
    rm /tmp/CyberChef.zip
    mv /opt/tools/CyberChef/CyberChef_*.html /opt/tools/CyberChef/CyberChef.html
    add-test-command "file /opt/tools/CyberChef/CyberChef.html"
    add-to-list "CyberChef,https://github.com/gchq/CyberChef/,The Cyber Swiss Army Knife"
}

function install_creds() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing creds"
    pipx install --system-site-packages git+https://github.com/ihebski/DefaultCreds-cheat-sheet
    add-history creds
    add-test-command "creds version"
    add-to-list "creds,https://github.com/ihebski/DefaultCreds-cheat-sheet,One place for all the default credentials to assist pentesters during an engagement. This document has several products default login/password gathered from multiple sources."
}

function install_uploader() {
    colorecho "Installing Uploader"
    git -C /opt/tools/ clone --depth 1 https://github.com/Frozenka/uploader.git 
    cd /opt/tools/uploader || exit
    python3 -m venv --system-site-packages ./venv
    source ./venv/bin/activate
    pip install -r requirements.txt
    deactivate
    add-aliases uploader
    add-history uploader
    add-test-command "uploader --help"
    add-to-list "uploader,https://github.com/Frozenka/uploader,Tool for quickly downloading files to a remote machine based on the target operating system"
}

function install_wesng() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing wesng"
    pipx install --system-site-packages git+https://github.com/bitsadmin/wesng
    add-history wesng
    add-test-command "wes --help"
    add-to-list "wesng,https://github.com/bitsadmin/wesng,WES-NG is a tool based on the output of Windows's systeminfo utility which provides the list of vulnerabilities the OS is vulnerable to including any exploits for these vulnerabilities."
}


# Package dedicated to offensive miscellaneous tools
function package_misc() {
    set_env
    local start_time
    local end_time
    start_time=$(date +%s)
    install_misc_apt_tools
    install_goshs           # Web uploader/downloader page
    install_searchsploit    # Exploitdb local search engine
    install_shellerator     # Reverse shell generator
    install_uberfile        # file uploader/downloader commands generator
    install_arsenal         # Cheatsheets tool
    install_triliumnext     # notes taking tool
    install_ngrok           # expose a local development server to the Internet
    install_whatportis      # Search default port number
    install_objectwalker    # Python module to explore the object tree to extract paths to interesting objects in memory
    install_tig             # ncurses-based text-mode interface for git
    install_yt-dlp          # A youtube-dl fork with additional features and fixes
    install_cyberchef       # A web based toolbox
    install_creds           # A default credentials vault
    install_uploader        # uploader for fast file upload
    install_wesng           # Search Windows vulnerability via systeminfo
    post_install
    end_time=$(date +%s)
    local elapsed_time=$((end_time - start_time))
    colorecho "Package misc completed in $elapsed_time seconds."
}
