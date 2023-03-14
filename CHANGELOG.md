## 10.10-4.0.1 2023-03-14 <dave at tiredofit dot ca>

   ### Changed
      - Strip TCP check on mysql_upgrade
      - Change Autoregister to mariadbmodern
      - Strip suffix from IMAGE_NAME


## 10.10-4.0.0 2023-02-08 <dave at tiredofit dot ca>

Major rewrite to the entire image bringing in a revamped way of dealing with multiple databases and users, bringing backup functionality up to parity with tiredofit/db-backup. Massive improvements with monitoring and safer initialization routines.
Compatibility with older versions is possible, with the exception of DB Backup routines all being prefixed with DB_BACKUP_

   ### Added
      - Pull MariaDB source instead of tarball, and compile in extra features
      - Switch to using bundled wolfSSL for TLS functions
      - Bring to parity with tiredofit/db-backup for in container backups
      - Zabbix Agent is now default and only supported way of doing metrics
      - Multiple Database Support + User support by means of DB01_,DB02,etc prefixes. Also allows for updating permissions and adding databases on subsequent reboots instead of on first initialization.
      - Make everything dynamic allowing for customization of configuration files, paths, data locations, socket locations.
      - Rework all initializations to work in a protected space before actually starting up the final mysqld process (Creating Databases/Users/Enabling Monitoring)
      - Monitoring is turnkey, user and password is automatically generated upon each container start to keep secrets from flying around
      - Modernize image with latest functions from tiredofit base images
      - Modernize Dockerfile to allow for cross distro compatibility
      - Further secure system by removing anonymous and extra users
      - Run as mariadb user, always, even when initializing
      - Rewrite Zabbix templates


## 10.10-3.12 2023-02-08 <dave at tiredofit dot ca>

   ### Changed
      - Isolate some db backup routines from container initialization


## 10.10-3.11.10 2023-02-06 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.10.3


## 3.11.9 2022-11-23 <dave at tiredofit dot ca>

   ### Added
      - Alpine 3.17 Base


## 3.11.8 2022-10-19 <dave at tiredofit dot ca>

   ### Changed
      - Fix Zabbix 'mysql.ping' command


## 3.11.7 2022-10-19 <dave at tiredofit dot ca>

   ### Changed
      - Fix for LOG_PATH environment variable


## 3.11.6 2022-10-19 <dave at tiredofit dot ca>

   ### Changed
      - Fix for logrotate and logshipping not working properly


## 3.11.5 2022-10-03 <dave at tiredofit dot ca>

   ### Added
      - Add LISTEN_PORT variable

   ### Changed
      - Clean up Code


## 3.11.4 2022-10-03 <dave at tiredofit dot ca>

   ### Added
      - Add LISTEN_PORT variable

   ### Changed
      - Clean up Code


## 3.11.3 2022-10-03 <dave at tiredofit dot ca>

   ### Changed
      - Fix IMAGE_NAME environment variable in Dockerfile


## 3.11.2 2022-10-02 <dave at tiredofit dot ca>

   ### Changed
      - Patchup for 3.11.1


## 3.11.1 2022-10-02 <dave at tiredofit dot ca>

   ### Changed
      - Patch for 3.11.0


## 3.11.0 2022-10-02 <dave at tiredofit dot ca>

   ### Added
      - Add 60 seconds S6 Grace timeout to not destroy database writes and allow for safe shutdown
      - Increase verbosity with EXTRA_ARGUMENTS command

   ### Changed
      - Rework version upgrades, only execute on MAJOR version changes, yet still log minor release changes


## 3.10.21 2022-09-30 <dave at tiredofit dot ca>

   ### Added
      - Add EXTRA_ARGUMENTS variable


## 3.10.20 2022-08-26 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.10.1 RC


## 3.10.19 2022-08-26 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.9.2


## 3.10.18 2022-08-26 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.8.4


## 3.10.17 2022-07-04 <dave at tiredofit dot ca>

   ### Added
      - MySQLTuner 1.9.9


## 3.10.16 2022-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Zabbix Agent socket fix


## 3.10.15 2022-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Fix Image Name environment variable


## 3.10.14 2022-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Remove static Zabbix configuration


## 3.10.13 2022-06-21 <dave at tiredofit dot ca>

   ### Changed
      - Fix for socket path and file


## 3.10.12 2022-06-18 <dave at tiredofit dot ca>

   ### Added


## 3.10.11 2022-05-25 <dave at tiredofit dot ca>

   ### Changed
      - Bugfix in Image name


## 3.10.10 2022-05-24 <dave at tiredofit dot ca>

   ### Added
      - MariaDB 10.8.3


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
