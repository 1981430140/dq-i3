#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="~/.config/polybar/forest/scripts/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/powermenu.rasi"

# Options
shutdown=" 关机"
reboot=" 重启"
lock=" 锁屏"
logout=" 注销"

# Confirmation
confirm_exit() {
	rofi -dmenu\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? : "\
		-theme $dir/confirm.rasi
}

# Message
msg() {
	rofi -theme "$dir/message.rasi" -e "Available Options  -  yes / y / no / n"
}

# Variable passed to rofi
options="$lock\n$logout\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		systemctl poweroff
		# ans=$(confirm_exit &)
		# if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
		# 	systemctl poweroff
		# elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
		# 	exit 0
        # else
		# 	msg
        # fi
        ;;
    $reboot)
		systemctl reboot
		# ans=$(confirm_exit &)
		# if [[ $ans == "yes" || $ans == "YES" || $ans == "y" || $ans == "Y" ]]; then
			
		# elif [[ $ans == "no" || $ans == "NO" || $ans == "n" || $ans == "N" ]]; then
		# 	exit 0
        # else
		# 	msg
        # fi
        ;;
    $lock)
		# 锁屏带模糊的截图
		# 锁屏 需要安装 i3lock，需要处理图片则还需安装 imagemagick，自动锁屏需要安装 xautolock
		# sudo apt-get install i3lock imagemagick xautolock
		curDate=$(date "+%Y%m%d%H%M%S")
		scrot /tmp/lockscreen$curDate.png && mogrify -scale 50% -gaussian-blur 0x4 -gamma 0.8 -scale 200% /tmp/lockscreen$curDate.png && i3lock -i /tmp/lockscreen$curDate.png
		# if [[ -f /usr/bin/i3lock ]]; then
		# 	i3lock
		# elif [[ -f /usr/bin/betterlockscreen ]]; then
		# 	betterlockscreen -l
		# fi
        ;;
    $logout)
		if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
			openbox --exit
		elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
			bspc quit
		elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
			i3-msg exit
		fi
        ;;
esac
