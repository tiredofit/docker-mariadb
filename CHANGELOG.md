## 3.10.15 2022-07-04 <dave at tiredofit dot ca>

   ### Added
      - MysqlTuner 1.9.9


## 3.10.14 2022-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Fix for Zabbix Agent


## 3.10.13 2022-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Fix for socket path and file
      - Remove static zabbix configuration


## 3.10.12 2022-06-18 <dave at tiredofit dot ca>

   ### Added


## 3.10.11 2022-06-18 <dave at tiredofit dot ca>

   ### Added
      - Configurable Socket Path and File


## 3.10.10 2022-05-25 <dave at tiredofit dot ca>

   ### Changed
      - Bugfix in image name


## 3.10.9 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.7.4
      - Alpine 3.16 base


## 3.10.8 2022-04-06 <dave at tiredofit dot ca>

   ### Added
      - Patchup for db-backup tmp state files


## 3.10.7 2022-03-04 <dave at tiredofit dot ca>

   ### Added
      - Be more descriptive when we actually have to upgrade a database version


## 3.10.6 2022-02-14 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.6.7


## 3.10.5 2022-02-09 <dave at tiredofit dot ca>

   ### Changed
      - Refresh base image


## 3.10.4 2021-12-13 <dave at tiredofit dot ca>

   ### Changed
      - Prepare for Zabbix Agent 1/2 Switching


## 3.10.3 2021-12-07 <dave at tiredofit dot ca>

   ### Added
      - Add Zabbix auto register support for templates


## 3.10.2 2021-11-24 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.15 base

## 3.10.1 2021-11-08 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.6.5
      - MySQLtuner 1.8.3


## 3.10.0 2021-10-24 <dave at tiredofit dot ca>

   ### Added
      - Switch to Alpine 3.14 as base and dont rely on Edge
      - Compile pixz instead of from packages


## 3.9.3 2021-09-04 <dave at tiredofit dot ca>

   ### Changed
      - Change the way that logortate is configured for better parsing


## 3.9.2 2021-09-01 <dave at tiredofit dot ca>

   ### Changed
      - Fix Regex


## 3.9.1 2021-09-01 <dave at tiredofit dot ca>

   ### Changed
      - Modernize environment variables from upstream images


## 3.9.0 2021-08-30 <dave at tiredofit dot ca>

   ### Added
      - Customizable logging support for error, general, and slow queries
      - Enabled logrotation for logs
      - Enabled fluent-bit log shipping parser for logs


## 3.8.1 2021-08-18 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.6.4


## 3.8.0 2021-07-25 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.6.3


## 3.7.5 2021-07-19 <dave at tiredofit dot ca>

   ### Changed
      - Switch to classic Zabbix Agent for now


## 3.7.4 2021-07-12 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.5.11


## 3.7.3 2021-05-09 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.5.10


## 3.7.1 2021-03-18 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.5.9


## 3.7.0 2020-10-30 <rusxakep@github>

   ### Added
      - MariaDB 10.5.7

   ### Changed
      - Shellcheck fixes
      - CRLF fixes
      - Remove duplicate variables
      - Set defaults for mariadb-backup component
      - Remove old code and convert to new sanity_var / db_ready functions

## 3.6.4 2020-10-30 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.5.6


## 3.6.3 2020-09-17 <dave at tiredofit dot ca>

   ### Changed
      - Remove false error when backing up manually


## 3.6.2 2020-09-17 <dave at tiredofit dot ca>

   ### Changed
      - Fix MariaDB backup script `backup-now`


## 3.6.1 2020-08-26 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.5.5


## 3.6.0 2020-08-06 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.5.4


## 3.5.1 2020-07-03 <dave at tiredofit dot ca>

   ### Changed
      - Cleanup code as per shellcheck warnings


## 3.5.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 5.0.0 base image


## 3.4.4 2020-03-09 <dave at tiredofit dot ca>

   ### Changed
      - Fix for container startup routines


## 3.4.3 2020-03-04 <dave at tiredofit dot ca>

   ### Added
      - Update image to support new tiredofit/alpine:4.4.0 base


## 3.4.2 2020-02-24 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.4.12


## 3.4.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Additional Changes to support new tiredofit/alpine base image


## 3.4.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Update to support new tiredofit/alpine image


## 3.3.6 2019-12-16 <dave at tiredofit dot ca>

   ### Changed
      - Previous IMAGE_VERSION wasn't being populated on screen


## 3.3.5 2019-12-16 <dave at tiredofit dot ca>

   ### Changed
      - Repair Auto Upgrade schema functionality


## 3.3.4 2019-12-15 <dave at tiredofit dot ca>

   ### Changed
      - Switch to Alpine Edge due to missing proj/geos dependencies


## 3.3.3 2019-12-15 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.4.11


## 3.3.2 2019-11-18 <dave at tiredofit dot ca>

   ### Changed
      - Change in execution of embedded backup script


## 3.3.1 2019-11-18 <dave at tiredofit dot ca>

   ### Added
      - Update to MariaDB 10.4.10


## 3.3.0 2019-11-11 <dave at tiredofit dot ca>

* Added functionality to support scheduled backups within container (same functionality as tiredofit/mariadb-backup)

## 3.2.0 2019-11-05 <dave at tiredofit dot ca>

* MariaDB 10.4.8
* Create DB Name with Charset and Default Collation
* Auto Upgrade Check from earlier images
* Renamed (but left compatibility) for Environment Variables
* Added LZO and LZ4 compression capability
* Included MySQL Tuner

## 3.1.2 2019-10-21 <dave at tiredofit dot ca>

* MariaDB 10.3.18

## 3.1.1 2019-06-30 <dave at tiredofit dot ca>

* Rename Proj4 to Proj

## 3.1 2019-06-19 <dave at tiredofit dot ca>

* Alpine 3.10

## 3.0.5 2019-06-19 <dave at tiredofit dot ca>

* MariaDB 10.3.16

## 3.0.4 2019-06-13 <dave at tiredofit dot ca>

* MariaDB 10.3.13

## 3.0.3 2019-02-08 <dave at tiredofit dot ca>

* Alpine 3.9
* MariaDB 10.3.12

## 3.0.2 2018-12-10 <dave at tiredofit dot ca>

* MariaDB 10.3.11

## 3.0.1 2018-09-18 <dave at tiredofit dot ca>

* Fix bug with creating new database under mariadb username

## 3.0.0 2018-08-22 <dave at tiredofit dot ca>

* Maria DB 10.3.9
* Ability to Create Multiple Databases

## 2.6.1 2018-08-22 <dave at tiredofit dot ca>

* Bump to MariaDB 10.2.17

## 2.6 2018-07-14 <dave at tiredofit dot ca>

* Allow setting default character set (default at moment is urf8)

## 2.51 2018-07-02 <dave at tiredofit dot ca>

* Bump to Alpine 3.8
* MariaDB 10.2.16

## 2.5 2018-04-15 <dave at tiredofit dot ca>

* Bump to 10.2.14

## 2.4 2018-01-31 <dave at tiredofit dot ca>

* Bump to MariaDB 10.2.12
* Alpine 3.7 Base
* Tweak Zabbix Monitoring

## 2.3 2017-12-03 <dave at tiredofit dot ca>

* Update to MariaDB 10.2.11

## 2.2 2017-10-03 <dave at tiredofit dot ca>

* Update my.cnf permissions to 0644

## 2.1 2017-08-28 <dave at tiredofit dot ca>

* Image Reorganization
* Tracking MariaDB release 10.2.8

## 2.0 2017-07-14 <dave at tiredofit dot ca>

* Rebase with S6 init.d
* Alpine 3:4 base
* Tracking MariaDB release 10.2.7

## 1.2 2017-05-19 <dave at tiredofit dot ca>

* Fixed Error in Dockerfile
* MariaDB 10.2.3

## 1.1 2017-02-08 <dave at tiredofit dot ca>

* Rebase
* Mysql 10.2.2

## 1.0 2017-02-08 <dave at tiredofit dot ca>

* Initial Release
* Zabbix MySQL Monitoring Included
* Tracking 10.1 Official Releases
