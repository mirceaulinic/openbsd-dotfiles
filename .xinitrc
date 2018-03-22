exec startxfce4
xbacklight -set 20
. /home/mircea/.kshrc
xidle -timeout 300 -program "/usr/local/bin/slock" &
