# Troubleshooting

## Initramfs

On Ubuntu 22.04 (and similar releases), initramfs is the small, compressed filesystem that gets loaded into memory by the bootloader before your main filesystem mounts. You usually interact with it when you:
- Update your kernel
- Add/remove kernel modules that need to be available at boot
- Fix boot problems

```bash
initramfs> ls -l /dev | egrep '^b'
initramfs> fstype /dev/vda*
initramfs> mkdir /tmp/sysroot
initramfs> mount /dev/vda2 /tmp/sysroot
initramfs> ls /tmp/sysroot
initramfs> reboot -n -f
```

## GRUB

GRUB2 (GRand Unified Bootloader version 2) is the bootloader that lets you choose which OS or kernel to boot on startup. It handles loading Linux kernels, initramfs, and other OSes like Windows.

```bash
linux -> /dev/vda2
```

> [!TIP]
> If you don't remember `root` password: add `init=/bin/bash` in linux line

+ command(CTRL+Z) -> start download

```bash
mount -o remount, rw /
passwd root
exec /sbin/init
update-grub

lsblk 
fdisk -l /dev/vda 
lvscan -> IF THERE IS AN INACTIVE SECTION: lvchange -ay <SECTION>
mkdir /opt/SECTION
mount /dev/opt/SECTION /opt/SECTION 
```

If you want error `wrong fs type, bad option, bad superblock`:

```bash
dd if=/dev/opt/SECTION of=/tmp/superblock bs=512 count=1
file /tmp/superblock 

apt instal xfsprogs
xfs_repair /dev/opt/SECTION
mount /dev/opt/SECTION /opt/SECTION
```