# MinIO

## Install MinIO

[Official website](https://docs.min.io/enterprise/aistor-object-store/installation/linux/#deploy-minio-distributed)

```bash
wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20240406052602.0.0_amd64.deb -O minio.deb 
sudo dpkg -i minio.deb -> install in /usr/lib/systemd/system/minio.service
sudo groupadd -r minio-user
sudo useradd -M -r -g minio-user minio-user
sudo mkdir /media/minio
sudo chown minio-user:minio-user /media/minio/
sudo nano /etc/default/minio

---> add in file `minio`
# Директория MinIO
MINIO_VOLUMES="/media/minio"
# Используется для указания порта, на котором работает сервис
MINIO_OPTS="--console-address :9001"
# Root пользователь MinIO
MINIO_ROOT_USER=LOGIN
# Пароль для пользователя
MINIO_ROOT_PASSWORD=PASSWORD

sudo systemctl start minio.service
sudo systemctl enable minio.service
```

Get in browser url="http://<IP-ADDRESS>:9001".

## Settings MinIO

```bash
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/
mc alias set myminio http://<IP-ADDRESS>:9000 LOGIN PASSWORD
mc admin info myminio
mc admin user add myminio LOGIN PASSWORD # create user
mc mb myminio/LOGIN
sudo nano NAME_FILE.json
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutBucketPolicy",
        "s3:GetBucketPolicy",
        "s3:DeleteBucketPolicy",
        "s3:ListAllMyBuckets",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::LOGIN"
      ],
      "Sid": ""
    },
    {
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::LOGIN/*"
      ],
      "Sid": ""
    }
  ]
}
```

```bash
mc admin policy create myminio LOGIN-policy NAME_FILE.json
mc admin policy attach myminio LOGIN-policy --user LOGIN
```