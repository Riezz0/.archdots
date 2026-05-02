#!/usr/bin/env bash

#VARIABLES#
flatinstall="flatpak install --noninteractive flathub"
localsend="org.localsend.localsend_app"
flatseal="com.github.tchx84.Flatseal"
rpcs3="net.rpcs3.RPCS3"
retroarch="org.libretro.RetroArch"
sysdman="io.github.plrigaux.sysd-manager"
adwgtk3="org.gtk.Gtk3theme.adw-gtk3"
adwgtk3dark="org.gtk.Gtk3theme.adw-gtk3-dark"

echo "Installing Flat Apps"
sleep 3
$flatinstall $localsend $flatseal $rpcs3 $retroarch $sysdman $adwgtk3 $adwgtk3dark



