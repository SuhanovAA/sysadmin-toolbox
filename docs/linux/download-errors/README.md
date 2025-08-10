initramfs> ls -l /dev | egrep '^b'
initramfs> fstype /dev/vda*
initramfs> mkdir /tmp/sysroot
initramfs> mount /dev/vda2 /tmp/sysroot
initramfs> ls /tmp/sysroot
initramfs> reboot -n -f
