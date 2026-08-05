#!/bin/sh

cp -rfv /usr/src/linux/arch/x86/boot/bzImage /boot/vmlinuz-$KERNEL
cp -rfv /usr/src/linux/System.map /boot/System.map-$KERNEL
cp -rfv /usr/src/linux/.config /boot/config-$KERNEL
echo

sleep 4

cd /boot
ln -sf vmlinuz-$KERNEL vmlinuz
ln -sf System.map-$KERNEL System.map
ln -sf config-$KERNEL config
echo

sleep 4

depmod -a $KERNEL

mkinitrd -k $KERNEL -F /etc/mkinitrd.conf

#mv initrd.img initrd-$.img

echo
sleep 2

export ZPOOL_VDEV_NAME_PATH=YES
grub-mkconfig -o /boot/grub/grub.cfg

echo
echo "concluido!!!"
