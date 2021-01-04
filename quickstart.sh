#!/bin/bash
set -euo pipefail

function prompt() {
    while true; do
        read -p "$1 [y/N] " yn
        case $yn in
            [Yy] ) return 0;;
            [Nn]|"" ) return 1;;
        esac
    done
}

if [[ $(id -u) != 0 ]]; then
    echo Please run this script as root.
    exit 1
fi

if [[ $(uname -m 2> /dev/null) != x86_64 ]]; then
    echo Please run this script on x86_64 machine.
    exit 1
fi

NAME=siaimes
REPO=set_fan_speed_based_on_gpu_load
DOWNLOADURL="https://raw.githubusercontent.com/$NAME/$REPO/main/set_fan_speed_based_on_gpu_load.sh"
TMPDIR="$(mktemp -d)"
INSTALLPREFIX=/usr/local
SYSTEMDPREFIX=/etc/systemd/system

BINARYPATH="$INSTALLPREFIX/bin/$REPO"
SYSTEMDPATH="$SYSTEMDPREFIX/$REPO.service"

echo Entering temp directory $TMPDIR...
cd "$TMPDIR"

echo Downloading $REPO ...
curl -LO --progress-bar "$DOWNLOADURL" || wget -q --show-progress "$DOWNLOADURL"

echo Installing $REPO to $BINARYPATH...
install -Dm755 "$REPO" "$BINARYPATH"

if [[ -d "$SYSTEMDPREFIX" ]]; then
    echo Installing $REPO systemd service to $SYSTEMDPATH...
    if ! [[ -f "$SYSTEMDPATH" ]] || prompt "The systemd service already exists in $SYSTEMDPATH, overwrite?"; then
        cat > "$SYSTEMDPATH" << EOF
[Unit]
Description=$REPO Service

[Service]
Type=simple
User=nobody
Restart=on-failure
RestartSec=5s
ExecStart="$BINARYPATH"
[Install]
WantedBy=multi-user.target
EOF

        echo Reloading systemd daemon...
        systemctl daemon-reload
    else
        echo Skipping installing $REPO systemd service...
    fi
fi

echo Deleting temp directory $TMPDIR...
rm -rf "$TMPDIR"

echo Done!
