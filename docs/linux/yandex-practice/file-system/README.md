## Установка и настройка NFS + iSCSI с переменными

```bash
#!/bin/bash

# ==== ПЕРЕМЕННЫЕ ДЛЯ НАСТРОЙКИ ====
NFS_IP="10.0.0.10"                     # IP сервера NFS
ISCSI_IP="10.0.0.20"                   # IP сервера iSCSI
ISCSI_USER="iscsiuser"                 # Логин для iSCSI
ISCSI_PASS="iscsipass"                 # Пароль для iSCSI
INITIATOR_NAME="iqn.2024-00.some.domain:initiator1"
TARGET_NAME="iqn.2024-00.some.domain:lun1"
LUN_SIZE_MB=4096                       # Размер LUN в МБ

# ==== SERVER (NFS) ====
sudo apt update
sudo apt install -y nfs-kernel-server nfs-common
sudo mkdir -p /srv/shares/nfs/
sudo chown ${USER}:${USER} -R /srv/shares/nfs/
echo "/srv/shares/nfs ${NFS_IP%.*}.0/24(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server
showmount -e localhost

# ==== CLIENT (NFS) ====
sudo mkdir -p /mnt/documents
sudo chown ${USER}:${USER} -R /mnt/documents/
sudo apt update && sudo apt install -y nfs-common
sudo mount -t nfs ${NFS_IP}:/srv/shares/nfs /mnt/documents/
echo "${NFS_IP}:/srv/shares/nfs /mnt/documents nfs defaults,nofail,_netdev 0 0" | sudo tee -a /etc/fstab

# ==== SERVER (iSCSI) ====
sudo apt update
sudo apt install -y tgt
sudo mkdir -p /srv/shares/iscsi
sudo dd if=/dev/zero of=/srv/shares/iscsi/lun.img bs=1M count=${LUN_SIZE_MB}
sudo mkdir -p /etc/tgt/conf.d
sudo tee /etc/tgt/conf.d/some_iscsi.conf > /dev/null <<EOF
<target ${TARGET_NAME}>
    backing-store /srv/shares/iscsi/lun.img
    initiator-address ${ISCSI_IP%.*}.0/24
    incominguser ${ISCSI_USER} ${ISCSI_PASS}
</target>
EOF
sudo systemctl restart tgt
sudo systemctl enable tgt

# ==== CLIENT (iSCSI) ====
sudo apt update
sudo apt install -y open-iscsi
sudo tee /etc/iscsi/initiatorname.iscsi > /dev/null <<EOF
InitiatorName=${INITIATOR_NAME}
EOF
sudo iscsiadm --mode discovery --type sendtargets --portal ${ISCSI_IP} -o new
sudo iscsiadm --mode node --targetname ${TARGET_NAME} -o update -n node.session.auth.username -v ${ISCSI_USER}
sudo iscsiadm --mode node --targetname ${TARGET_NAME} -o update -n node.session.auth.password -v ${ISCSI_PASS}
sudo iscsiadm --mode node --targetname ${TARGET_NAME} --portal ${ISCSI_IP} --login
sudo iscsiadm -m session P3
```