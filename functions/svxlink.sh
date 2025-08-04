#!/bin/bash
URL="https://github.com/f5vmr/svxlink/releases/latest/download/svxlink-25.05.1-Linux.deb"
wget -O /tmp/svxlink.deb "$URL"
sudo apt install -y /tmp/svxlink.deb
