#!/bin/sh
# my Arch Linux user setup script
##set -euo pipefail

who=$(whoami)

echo "Install packages with Pacman"
sudo pacman -Syu --noconfirm --needed \
    base-devel sudo zsh sl tmux htop git vim pkgfile \
    openssh keychain pass lsof strace dnsutils pciutils \
    xorg xorg-apps xorg-fonts xorg-xinit xcompmgr autocutsel slock \
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
sudo pkgfile --update

echo "Generate ssh key"
mkdir ~/.ssh && cd ~/.ssh
ssh-keygen -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
read -p "Copy ssh key to github and press [enter]"

echo "Configure git"
read -p "Username for git: " USER
read -p  "E-mail for git: " MAIL
git config --global user.name $USER
git config --global user.email $MAIL
git config --global push.default current

echo "Configure user with dotfiles"
mkdir ~/git
cd ~/git
git clone git@github.com:Duologic/domyarch.git
ln -s ~/git/domyarch/zshrc ~/.zshrc
ln -s ~/git/domyarch/tmux.conf ~/.tmux.conf
ln -s ~/git/domyarch/vimrc ~/.vimrc
ln -s ~/git/domyarch/gitignore ~/.gitignore
ln -s ~/git/domyarch/xinitrc ~/.xinitrc
ln -s ~/git/domyarch/Xmodmap ~/.Xmodmap

echo "Install Pathogen and Python mode for VIM"
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle
git clone git://github.com/klen/python-mode.git
