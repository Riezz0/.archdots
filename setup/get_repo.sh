#!/usr/bin/env bash

#-----Download-The Repo-----#
git clone https://github.com/Riezz0/.archdots.git /home/$USER/.archdots/
chmod +x /home/$USER/.archdots/setup/install.sh
cd /home/$USER/.archdots/ 
bash /home/$USER/.archdots/setup/install.sh

