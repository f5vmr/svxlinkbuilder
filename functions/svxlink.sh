#!/bin/bash
function install {
URL="https://github.com/f5vmr/svxlink/releases/download/v25.05.1.24/svxlink-V25.05.01.24.g6b56a264-Linux.deb"
wget -O /tmp/svxlink.deb "$URL"
sudo apt install -y /tmp/svxlink.deb
}