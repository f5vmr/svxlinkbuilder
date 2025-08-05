#!/bin/bash
function install {
URL="https://github.com/f5vmr/svxlink/releases/latest/download/svxlink.deb"
wget -O /tmp/svxlink.deb "$URL"
sudo apt install -y /tmp/svxlink.deb
}