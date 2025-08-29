```bash
sudo apt-get install gnupg curl

sudo curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update

sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod

# settings file to path:
sudo nano /etc/mongod.conf

# if error = 14
chown -R mongodb:mongodb /var/lib/mongodb
chown mongodb:mongodb /tmp/mongodb-27017.sock

```

```bash
mongosh
show dbs
use mydb

#create collection
db.createCollection("mycollection")
show collections
db.mycollection.insertOne({ key: "value" })
db.mycollection.find()
db.mycollection.drop()

db.dropDatabase()


# settings security

mongosh
use admin
db.createUser({user:"Some_Admin_Account", pwd:passwordPrompt(), roles:[{role:"userAdminAnyDatabase", db:"admin"}, "readWriteAnyDatabase"]})
sudo nano /etc/mongod.conf
#  security:
#    authorization: "enabled"
systemctl restart mongod


# TEST
use yp_db
