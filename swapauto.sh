#!/bin/bash
setup_swap(){
    isSwapOn=$(swapon -s | tail -1)

    if [[ ${isSwapOn} == "" ]]; then
        add_swap
    else
        del_swap
        add_swap
    fi
    echo "Setup swap complete! Check output to confirm everything is good."
}
del_swap(){
echo del swap...
backupTime=$(date +%y-%m-%d--%H-%M-%S)
swapSpace=$(swapon -s | tail -1 |  awk '{print $1}' | cut -d '/' -f 2)
echo "3" > /proc/sys/vm/drop_caches
swapoff /$swapSpace
cp /etc/fstab /etc/fstab.$backupTime
sed -i '/swap/d' /etc/fstab
rm -rf "/$swapSpace"
}
add_swap(){
echo add swap...
dd if=/dev/zero of=/swapfile bs=1024k count=128
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
}
setup_swap
