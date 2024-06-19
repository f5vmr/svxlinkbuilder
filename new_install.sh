#!/bin/bash
curl https://online-amateur-radio-club-m0ouk.github.io/oarc-packages/hibby.key | sudo tee /etc/apt/trusted.gpg.d/hibby.asc

echo "deb https://online-amateur-radio-club-m0ouk.github.io/oarc-packages bookworm main" | sudo tee -a /etc/apt/sources.list