## SERVER (NFS)

```bash
sudo apt update
sudo apt install nfs-kernel-server nfs-common -y
sudo mkdir -p /srv/shares/nfs/
sudo chown ${USER}:${USER} -R /srv/shares/nfs/
sudo nano /etc/exports
-> /srv/shares/nfs 10.0.0.0/8(rw,sync,no_subtree_check)
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server
showmount -e localhost
```

## CLIENT (NFS)

```bash
sudo mkdir -p /mnt/documents
sudo chown ${USER}:${USER} -R /mnt/documents/
sudo sh -c "apt update && apt install nfs-common -y"
sudo mount -t nfs IP_ADDRESS:/srv/shares/nfs /mnt/documents/
sudo nano /etc/fstab
-> IP_ADDRESS:/srv/shares/nfs /mnt/documents nfs defaults,nofail,_netdev 0 0
```

## SERVER (ISCSI)

```bash
sudo apt update
sudo apt install tgt
sudo mkdir -p /srv/shares/iscsi
sudo dd if=/dev/zero of=/srv/shares/iscsi/lun.img bs=1M count=4096
sudo touch /etc/tgt/conf.d/some_iscsi.conf
sudo nano /etc/tgt/conf.d/some_iscsi.conf
-> <target iqn.2024-00.some.domain:lun1>
-> backing-store /srv/shares/iscsi/lun.img
-> initiator-address IP_ADDRESS
-> incominguser USER PASSWORD
-> </target>
sudo service tgt restart
sudo systemctl enable tgt
sudo apt update
sudo apt install open-iscsi
sudo nano /etc/iscsi/initiatorname.iscsi
-> InitiatorName=iqn.2024-00.some.domain:initiator1
sudo iscsiadm --mode discovery --type sendtargets --portal IP_ADDRESS -o new
sudo iscsiadm --mode node --targetname iqn.2024-00.some.domain:lun1 -o update -n node.session.auth.username -v USER
sudo iscsiadm --mode node --targetname iqn.2024-00.some.domain:lun1 -o update -n node.session.auth.password -v PASSWORD
sudo iscsiadm --mode node --targetname iqn.2024-00.some.domain:lun1 --portal IP_ADDRESS --login
sudo iscsiadm -m session P3
```
