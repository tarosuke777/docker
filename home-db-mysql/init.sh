#!/bin/bash

ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
HMS_PASSWORD=$(cat /run/secrets/mysql_hms_user_password)
HB_PASSWORD=$(cat /run/secrets/mysql_hb_user_password)
HV_PASSWORD=$(cat /run/secrets/mysql_hv_user_password)

mysql -u root -p"$ROOT_PASSWORD" <<EOSQL
CREATE DATABASE IF NOT EXISTS hms;
CREATE DATABASE IF NOT EXISTS hb;
CREATE DATABASE IF NOT EXISTS hv;

CREATE USER 'hms'@'%' IDENTIFIED BY '$HMS_PASSWORD';
CREATE USER 'hb'@'%' IDENTIFIED BY '$HB_PASSWORD';
CREATE USER 'hv'@'%' IDENTIFIED BY '$HV_PASSWORD';

GRANT ALL PRIVILEGES ON hms.* TO 'hms'@'%';
GRANT ALL PRIVILEGES ON hb.* TO 'hb'@'%';
GRANT ALL PRIVILEGES ON hv.* TO 'hv'@'%';

FLUSH PRIVILEGES;
EOSQL