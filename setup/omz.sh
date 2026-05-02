#!/usr/bin/env bash

dots="/home/$USER/.archdots"

git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "$dots/tmp/zsh-autosuggestions/"
git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$dots/tmp/zsh-syntax-highlighting/"
git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$dots/tmp/fast-syntax-highlighting/"
git clone --depth 1 "https://github.com/marlonrichert/zsh-autocomplete.git" "$dots/tmp/zsh-autocomplete/"
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "$dots/tmp/autoswitch_virtualenv/"

RUNZSH=no sh -c "$(curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh")" "" --unattended

cp -r $dots/tmp/zsh-autosuggestions/ /home/$USER/.oh-my-zsh/custom/plugins/
cp -r $dots/tmp/zsh-syntax-highlighting/ /home/$USER/.oh-my-zsh/custom/plugins/
cp -r $dots/tmp/fast-syntax-highlighting/ /home/$USER/.oh-my-zsh/custom/plugins/
cp -r $dots/tmp/zsh-autocomplete/ /home/$USER/.oh-my-zsh/custom/plugins/
cp -r $dots/tmp/autoswitch_virtualenv/ /home/$USER/.oh-my-zsh/custom/plugins/

rm -rf $dots/tmp/

chsh -s "$(which zsh)"

rm /home/$USER/.zshrc
cd $dots
stow zsh
