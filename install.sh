#!/bin/bash

wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz
tar xzf nvim-linux64.tar.gz --strip-components 1 -C /usr/local/

mkdir -p ~/.config/nvim
wget https://raw.githubusercontent.com/alanoy/mini-nvim/main/init.lua ~/.config/nvim

sed -i '/alias l='"'"'ls -CF'"'"'/a alias vi='"'"'nvim'"'"'' ~/.bashrc
. ~/.bashrc

echo "Neovim 安装和配置完成!"
