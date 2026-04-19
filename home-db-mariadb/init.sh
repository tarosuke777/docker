#!/bin/bash

ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
HMS_PASSWORD=$(cat /run/secrets/mysql_hms_user_password)
HB_PASSWORD=$(cat /run/secrets/mysql_hb_user_password)
HV_PASSWORD=$(cat /run/secrets/mysql_hv_user_password)

# mariadbコマンドで実衁E
mariadb -u root -p"${ROOT_PASSWORD}" <<EOSQL
CREATE DATABASE IF NOT EXISTS hms;
CREATE DATABASE IF NOT EXISTS hb;
CREATE DATABASE IF NOT EXISTS hv;

-- HMS用
DROP USER IF EXISTS 'hms'@'%';
CREATE USER IF NOT EXISTS 'hms'@'%' IDENTIFIED BY '${HMS_PASSWORD}';
GRANT ALL PRIVILEGES ON hms.* TO 'hms'@'%';

-- HB用
DROP USER IF EXISTS 'hb'@'%';
CREATE USER IF NOT EXISTS 'hb'@'%' IDENTIFIED BY '${HB_PASSWORD}';
GRANT ALL PRIVILEGES ON hb.* TO 'hb'@'%';

-- HV用
DROP USER IF EXISTS 'hv'@'%';
CREATE USER IF NOT EXISTS 'hv'@'%' IDENTIFIED BY '${HV_PASSWORD}';
GRANT ALL PRIVILEGES ON hv.* TO 'hv'@'%';

FLUSH PRIVILEGES;
EOSQL