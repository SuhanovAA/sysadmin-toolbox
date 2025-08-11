
# PostgreSQL: Установка и Настройка Репликации

---

## Установка PostgreSQL

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install postgresql -y
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

---

## Настройка пользователей и баз данных

```bash
sudo -i -u postgres
```

Создание пользователя `sysadmin`:

```bash
createuser sysadmin
```

Для удаления пользователя:

```bash
dropuser sysadmin
```

Подключение к PostgreSQL:

```bash
psql
```

Внутри psql:

```sql
\du  -- список ролей
SELECT * FROM pg_roles WHERE rolname = 'sysadmin';  -- детали роли sysadmin

-- Установка паролей (замените PASSWORD на ваш пароль)
ALTER USER postgres WITH ENCRYPTED PASSWORD 'PASSWORD';
ALTER USER sysadmin WITH ENCRYPTED PASSWORD 'PASSWORD';

\l  -- список баз данных

CREATE DATABASE test_db;
GRANT ALL PRIVILEGES ON DATABASE test_db TO sysadmin;

\q  -- выход из psql
```

---

## Настройка доступа и параметров подключения

Отредактируйте файл `/etc/postgresql/14/main/pg_hba.conf`, добавив или изменив строку:

```
host    test_db     sysadmin    IP/маска    scram-sha-256
```

Замените `IP/маска` на нужный диапазон адресов, например `192.168.1.0/24`.

В файле `/etc/postgresql/14/main/postgresql.conf` найдите и измените:

```conf
listen_addresses = '*'
```

Это позволит принимать подключения с любых IP.

---

## Применение изменений

```bash
sudo systemctl restart postgresql
```

---

## Подключение к базе данных

```bash
psql --host=IP_ADDRESS --username=sysadmin --password --dbname=test_db
```

---

# Настройка репликации PostgreSQL

---

## Создание пользователя для репликации

```bash
sudo -u postgres createuser --replication -P syncuser
```

Опция `-P` запросит ввод пароля для `syncuser`.

---

## Настройка конфигурационных файлов

В файле `/etc/postgresql/14/main/postgresql.conf`:

- Раскомментируйте и установите:

```conf
wal_level = replica
hot_standby = on
```

В файле `/etc/postgresql/14/main/pg_hba.conf` добавьте строку для репликации:

```
host    replication     syncuser    IP/маска    scram-sha-256
```

---

## Перезапуск PostgreSQL для применения настроек

```bash
sudo systemctl restart postgresql
```

---

# Настройка сервера-реплики (Slave)

---

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install postgresql -y

sudo nano /etc/postgresql/14/main/postgresql.conf
# Убедитесь, что строка hot_standby = on раскомментирована

sudo systemctl stop postgresql

# Очистка каталога данных (будет полностью перезаписан)
sudo -u postgres rm -rf /var/lib/postgresql/14/main/

# Получение резервной копии с мастера
sudo -u postgres pg_basebackup -h IP_MASTER -D /var/lib/postgresql/14/main -U syncuser -P -v -R

sudo systemctl start postgresql

# Проверка баз данных
sudo -u postgres psql -c "\l"
```