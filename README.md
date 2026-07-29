# nfrastack/container-mariadb

## About

This repository will build a container image for (https://mariadb.org). A relational database forked from MySQL.

* Configuration tweaked to use all around settings for general usage - Can be changed
* Can use official MariaDB/MySQL environment variables (MYSQL_USER|MARIADB_USER,MARIADB|MYSQL_PASSWORD, MARIADB|MYSQL_ROOT_PASSWORD)
* Allows for automatically creating multiple databases on container initialization and subsequent reboots
* Allows restoration of previously performed backup into database once or repeatedly
* Automatic Table/DB Upgrade support if MariaDB version has changed
* Includes MySQL Tuner inside image to optimize your configuration
* Logging with automatic rotation
* Zabbix Monitoring for metrics

## Maintainer

- [Nfrastack](https://www.nfrastack.com)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Prebuilt Images](#prebuilt-images)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
- [Environment Variables](#environment-variables)
  - [Base Images used](#base-images-used)
  - [Core Configuration](#core-configuration)
- [Users and Groups](#users-and-groups)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support & Maintenance](#support--maintenance)
- [License](#license)

## Installation

### Prebuilt Images

Feature limited builds of the image are available on the [Github Container Registry](https://github.com/nfrastack/container-mariadb/pkgs/container/container-mariadb) and [Docker Hub](https://hub.docker.com/r/nfrastack/mariadb).

To unlock advanced features, one must provide a code to be able to change specific environment variables from defaults. Support the development to gain access to a code.

To get access to the image use your container orchestrator to pull from the following locations:

```
ghcr.io/nfrastack/container-mariadb:(image_tag)
docker.io/nfrastack/mariadb:(image_tag)
```

Image tag syntax is:

`<image>:<branch>-<optional tag>-<optional_distribution>_<optional_distribution_variant>`

Example:
`ghcr.io/nfrastack/container-mariadb:12.3` or optionally

`ghcr.io/nfrastack/container-mariadb:12.3-1.0` or optionally

`ghcr.io/nfrastack/container-mariadb:12.3-1.0-alpine` or optinally


- The `branch` will relate to the MAJOR eg `12` and MINOR `.3` release.
- An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - These are the safest
- If it is built for multiple distributions there may exist a value of `alpine` or `debian`
- If there are multiple distribution variations it may include a version - see the registry for availability

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for your use.

- Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
- Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description                                                    |
| ---------- | -------------------------------------------------------------- |
| `/config/` | Optional directory to put .cnf files for additional directives |
| `/data/`   | Datafiles                                                      |
| `/logs/`   | Logfiles                                                       |

### Environment Variables

#### Base Images used

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

| Image                                                   | Description |
| ------------------------------------------------------- | ----------- |
| [OS Base](https://github.com/nfrastack/container-base/) | Base Image  |

Below is the complete list of available options that can be used to customize your installation.

- Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

#### Container Options
| Parameter     | Description                                                  | Default         |
| ------------- | ------------------------------------------------------------ | --------------- |
| `CERT_PATH`   | Certs Path                                                   |                 |
| `CONFIG_FILE` | (optional) Configuration File to load - Not needed to be set | `mariadb.cnf`   |
| `CONFIG_PATH` | (optional) Configuration Path                                | `/config/`      |
| `DATA_PATH`   | Data Files Path                                              | `/data/`        |
| `LOG_PATH`    | Log Files Path                                               | `/logs/`        |
| `SOCKET_FILE` | Socket Name                                                  | `mariadbd.sock` |
| `SOCKET_PATH` | Socket Path                                                  | `/run/mariadb/` |

#### MariaDB Options

| Parameter         | Description                                                 | Default              | `_FILE` |
| ----------------- | ----------------------------------------------------------- | -------------------- | ------- |
| `CHARACTER_SET`   | Set Default Character Set                                   | `utf8mb4`            |         |
| `COLLATION`       | Set Default Collation                                       | `utf8mb4_general_ci` |         |
| `DB_AUTO_UPGRADE` | If MariaDB has changed from first time image has been used  | `TRUE`               |         |
|                   | automatically upgrade DBs and tables to latest versions     | `TRUE`               |         |
| `CONFIG_PROFILE`  | Type of Configuration - `standard`, or `default`, or `none` | `standard`           |         |
| `LISTEN_PORT`     | Server Listening Port                                       | `3306`               |         |
| `ROOT_PASS`       | Root Password for Instance (e.g. password)                  |                      | x       |
| `MARIADBD_ARGS`   | Add extra arguments to the mariadb execution                |                      |         |

* With regards to `CONFIG_PROFILE`
  - `default` - Means the default my.cnf file from MariaDB
  - `standard` - My own settings that I find work for my own DB servers.

#### Database Options

Automatically create user databases on startup. This can be done on each container start, and then removed on subsequent starts if desired.

| Parameter   | Description                               | Default | `_FILE` |
| ----------- | ----------------------------------------- | ------- | ------- |
| `CREATE_DB` | Automatically create databases on startup | `TRUE`  |         |
| `DB_NAME`   | Database Name e.g. `database`             |         | x       |
| `DB_USER`   | Database User e.g. `user`                 |         | x       |
| `DB_PASS`   | Database Pass e.g. `password`             |         | x       |

**OR**

Create multiple databases and different usernames and passwords to access. You can share usernames and passwords for multiple databases by using the same user and password in each entry.

| Parameter   | Description                                        | Default | `_FILE` | Advanced |
| ----------- | -------------------------------------------------- | ------- | ------- | -------- |
| `DB01_NAME` | First Database Name e.g. `database1`               |         | x       | x        |
| `DB01_USER` | First Database User e.g. `user1`                   |         | x       | x        |
| `DB01_PASS` | First Database Pass e.g. `password1`               |         | x       | x        |
| `DB02_NAME` | Second Database Name e.g. `database1`              |         | x       | x        |
| `DB02_USER` | Second Database User e.g. `user2`                  |         | x       | x        |
| `DB02_PASS` | Second Database Pass e.g. `password2`              |         | x       | x        |
| `DBXX_...`  | As above, should be able to go all the way to `99` |         |         | x        |

A limit of 3 can be created when not in advanced mode.

##### Restore on startup (DBXX_RESTORE)

This image can import SQL dumps into databases created during initialization using per-database environment variables. Set `DB01_RESTORE_FILE`, `DB02_RESTORE_FILE`, ... to point to a SQL dump file that is readable inside the container.

| Parameter           | Description                                                                     | Default | `_FILE` | Advanced |
| ------------------- | ------------------------------------------------------------------------------- | ------- | ------- | -------- |
| `DBXX_RESTORE_FILE` | Path and file inside container containing databse dump to restore.              |         |         |          |
| `DBXX_RESTORE_MODE` | Restore using logic                                                             | `INIT`  |         |          |
|                     | `INIT` / `FRESH` restores only on database initialization (database must be empty) |         |         |          |
|                     | `ONCE` restores the file once, overwriting the database even if it contains data |         |         |          |
|                     | `ALWAYS` restores the database, overwriting on each container startup.          |         |         |          |

>> `ROOT_PASS` must be set so the importer can authenticate as root.
>> If `DBxx_RESTORE_FILE` is set but the matching `DBxx_NAME` is missing the restore will be skipped and an error logged.
>> Supported input formats: plain SQL and common compressed formats — gzip (`.gz`), bzip2 (`.bz2`), xz (`.xz`) and zstd (`.zst`).
>> Modes that only run once (`ONCE`, `INIT`, `FRESH`) write a file into ${DATA_PATH}/.restore_<db_name> to prevent re-importing. Delete this file to allow re-importing for that database.

#### Logging Options

| Parameter                  | Description                                                  | Default          |
| -------------------------- | ------------------------------------------------------------ | ---------------- |
| `ENABLE_LOG_ERROR`         | Enable Error Logging                                         | `TRUE`           |
| `ENABLE_LOG_GENERAL_QUERY` | Log all connections and queries to server (performance hit!) | `FALSE`          |
| `ENABLE_SLOW_QUERY_LOG`    | Log all slow queries                                         | `FALSE`          |
| `LOG_LEVEL`                | Log Level for warnings `0` to `9`                            | `2`              |
| `LOG_FILE_ERROR`           | Error Log File Name                                          | `error.log`      |
| `LOG_FILE_GENERAL_QUERY`   | General Query Log File name                                  | `general.log`    |
| `LOG_FILE_SLOW_QUERY`      | Slow Query Log File Name                                     | `slow_query.log` |

## Users and Groups

| Type  | Name      | ID   |
| ----- | --------- | ---- |
| User  | `mariadb` | 3306 |
| Group | `mariadb` | 3306 |

### Networking

| Port   | Protocol | Description    |
| ------ | -------- | -------------- |
| `3306` | tcp      | MariaDB Daemon |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container.

### Mysql Tuner

This image comes with [Mysql Tuner](https://github.com/major/MySQLTuner-perl). Simply enter inside the container and execute `mysql-tuner` along with your arguments.

## Support & Maintenance

- For community help, tips, and community discussions, visit the [Discussions board](/discussions).
- For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
- To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
- Feature requests are welcome, but not guaranteed. For prioritized development, consider a support agreement.
- Updates are best-effort, with priority given to active production use and support agreements.

## References

* https://mariadb.org

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
