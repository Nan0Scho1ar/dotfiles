#!/usr/bin/env bash

AS_LOG_PATH="/home/nan0scho1ar/autostart.log"

echo "Running startup script..." >> $AS_LOG_PATH
date >> $AS_LOG_PATH

echo "Starting sxhkd..." >> $AS_LOG_PATH
sxhkd 2>&1 >> $AS_LOG_PATH & disown
echo -e "DONE\n\n" >> $AS_LOG_PATH

echo "Starting nextcloud..." >> $AS_LOG_PATH
nextcloud 2>&1 >> $AS_LOG_PATH & disown
echo -e "DONE\n\n" >> $AS_LOG_PATH

echo "Starting emacs daemon..." >> $AS_LOG_PATH
emacs --daemon 2>&1 >> $AS_LOG_PATH & disown
echo -e "DONE\n\n" >> $AS_LOG_PATH

#echo "Starting alacritty..." >> $AS_LOG_PATH
#alacritty 2>&1 >> $AS_LOG_PATH & disown
#echo -e "DONE\n\n" >> $AS_LOG_PATH


#echo "Starting picom..." >> $AS_LOG_PATH
#picom 2>&1 >> $AS_LOG_PATH & disown
#echo -e "DONE\n\n" >> $AS_LOG_PATH

echo "Starting polybar..." >> $AS_LOG_PATH
bash "/home/nan0scho1ar/.config/polybar/launch.sh" "both" 2>&1 >> $AS_LOG_PATH & disown
echo -e "DONE\n\n" >> $AS_LOG_PATH

echo "Ran startup script" >> $AS_LOG_PATH
echo -e "\n\n\n" >> $AS_LOG_PATH

case $HOSTNAME in
    jupiter) startup_jupiter  ;;
    *) echo "TODO" ;;
esac
