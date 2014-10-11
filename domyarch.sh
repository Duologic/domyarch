#!/bin/sh
# my Arch Linux user setup script
##set -euo pipefail

who=$(whoami)

echo "Install packages with Pacman"
sudo pacman -Syu --noconfirm --needed \
    base-devel sudo zsh tmux htop pass git \
    vim openssh lsof strace dnsutils keychain sl \
    python python-pip python2 python2-pip

echo "Install cower for AUR"
mkdir ~/aur
curl -LSso ~/aur/cower-git.tar.gz https://aur.archlinux.org/packages/co/cower-git/cower-git.tar.gz
cd ~/aur && tar -xzf cower-git.tar.gz && cd ~/aur/cower-git && makepkg -si --noconfirm

echo "Install asciiquarium"
cd ~/aur
cower -d asciiquarium
cd ~/aur/asciiquarium && makepkg -si --noconfirm

echo "Change to zshell"
sudo chsh -s /usr/bin/zsh $who

echo "Generate ssh key"
mkdir ~/.ssh && cd ~/.ssh
ssh-keygen
cat ~/.ssh/id_rsa
read -p "Copy ssh key to github and press [enter]"

echo "Configure git"
echo -n  "Username for git: " && read USER
echo -n  "E-mail for git: " && read MAIL
git config --global push.default current
git config --global user.name $USER
git config --global user.email $MAIL

echo "Configure user with dotfiles"
mkdir ~/git
cd ~/git
git clone git@github.com:Duologic/domyarch.git
ln -s ~/git/domyarch/zshrc ~/.zshrc
ln -s ~/git/domyarch/tmux.conf ~/.tmux.conf
ln -s ~/git/domyarch/vimrc ~/.vimrc
ln -s ~/git/domyarch/gitignore ~/.gitignore

echo "Install Pathogen and Python mode for VIM"
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
git clone git://github.com/klen/python-mode.git
