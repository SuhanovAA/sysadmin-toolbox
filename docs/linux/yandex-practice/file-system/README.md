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

## CLIENT

```bash
sudo mkdir -p /mnt/documents
sudo chown ${USER}:${USER} -R /mnt/documents/
sudo sh -c "apt update && apt install nfs-common -y"
sudo mount -t nfs IP_ADDRESS:/srv/shares/nfs /mnt/documents/
sudo nano /etc/fstab
-> IP_ADDRESS:/srv/shares/nfs /mnt/documents nfs defaults,nofail,_netdev 0 0
```
