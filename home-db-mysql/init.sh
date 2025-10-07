#!/bin/bash

ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
HMS_PASSWORD=$(cat /run/secrets/mysql_hms_user_password)
HB_PASSWORD=$(cat /run/secrets/mysql_hb_user_password)

mysql -u root -p"$ROOT_PASSWORD" <<EOSQL
CREATE DATABASE IF NOT EXISTS hms;
CREATE DATABASE IF NOT EXISTS hb;

CREATE USER 'hms'@'%' IDENTIFIED BY '$HMS_PASSWORD';
CREATE USER 'hb'@'%' IDENTIFIED BY '$HB_PASSWORD';

GRANT ALL PRIVILEGES ON hms.* TO 'hms'@'%';
GRANT ALL PRIVILEGES ON hb.* TO 'hb'@'%';

FLUSH PRIVILEGES;
EOSQL