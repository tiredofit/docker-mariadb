# nfrastack/container-mariadb

## About

This repository will build a container image for (https://mariadb.org). A relational database forked from MySQL.

* Ships configuration profiles tweaked for general usage - see `CONFIG_PROFILE`
* Can use official MariaDB/MySQL environment variables (MYSQL_USER|MARIADB_USER, MYSQL_PASSWORD|MARIADB_PASSWORD, MYSQL_ROOT_PASSWORD|MARIADB_ROOT_PASSWORD, MYSQL_DATABASE|MARIADB_DATABASE)
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
    - [Multi-Architecture Support](#multi-architecture-support)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Core Configuration](#core-configuration)
    - [Container Options](#container-options)
    - [MariaDB Options](#mariadb-options)
    - [Database Options](#database-options)
      - [Restore on startup](#restore-on-startup)
    - [Logging Options](#logging-options)
    - [Monitoring Options](#monitoring-options)
- [Users and Groups](#users-and-groups)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
  - [Mysql Tuner](#mysql-tuner)
- [Support & Maintenance](#support--maintenance)
- [References](#references)
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
`ghcr.io/nfrastack/container-mariadb:11.8` or optionally

`ghcr.io/nfrastack/container-mariadb:11.8-1.0` or optionally

`ghcr.io/nfrastack/container-mariadb:11.8-1.0-alpine` or optionally


- The `branch` will relate to the MAJOR eg `11` and MINOR `.8` release.
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
| `/config/`  | Optional directory to put .cnf files for additional directives                        |
| `/data/`    | Datafiles                                                                             |
| `/logs/`    | Logfiles                                                                              |
| `/restore/` | Optional directory holding SQL dumps to import - see [Restore on startup](#restore-on-startup) |

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
| `CERT_PATH`   | (optional) Certs Path - no default, only created when set    |                 |
| `CONFIG_FILE` | (optional) Configuration File to load - Not needed to be set | `mariadb.cnf`   |
| `CONFIG_PATH` | (optional) Configuration Path                                | `/config/`      |
| `DATA_PATH`   | Data Files Path                                              | `/data/`        |
| `LOG_PATH`    | Log Files Path                                               | `/logs/`        |
| `SOCKET_FILE` | Socket Name                                                  | `mariadbd.sock` |
| `SOCKET_PATH` | Socket Path                                                  | `/run/mariadb/` |

#### MariaDB Options

| Parameter          | Description                                                                                 | Default              | `_FILE` |
| ------------------ | ------------------------------------------------------------------------------------------- | -------------------- | ------- |
| `CONFIG_PROFILE`   | Type of Configuration - `standard`, or `default`, or `none`                                 | `none`               |         |
| `DB_AUTO_UPGRADE`  | If MariaDB has changed from first time image has been used, automatically upgrade DBs and tables to latest versions | `TRUE`               |         |
| `DB_CHARACTER_SET` | Set Default Character Set                                                                   | `utf8mb4`            |         |
| `DB_COLLATION`     | Set Default Collation                                                                       | `utf8mb4_general_ci` |         |
| `DB_HOST`          | Host the internal clients connect to during initialization                                  | `127.0.0.1`          |         |
| `INIT_FILE`        | (optional) Path inside the container to an SQL file executed instead of the built in bootstrap SQL - only on first initialization |                      |         |
| `LISTEN_PORT`      | Server Listening Port                                                                       | `3306`               |         |
| `ROOT_PASS`        | Root Password for Instance (e.g. password)                                                  |                      | x       |
| `MARIADBD_ARGS`    | Add extra arguments to the mariadb execution                                                |                      |         |

* With regards to `CONFIG_PROFILE`
  - `default` - Means the default my.cnf file from MariaDB
  - `standard` - My own settings that I find work for my own DB servers.
  - `none` (also accepted: `blank`, `false`) - Only the automatically generated `00-core.cnf` is written, no tuned configuration file is created. This is the current default, so set `CONFIG_PROFILE=standard` explicitly if you want the tuned settings.
  - Any other value falls back to `default`.

* `00-core.cnf` inside `CONFIG_PATH` is generated and overwritten from the environment variables on every container start. Put your own directives into additional `<name>.cnf` files in the same directory.

* `DB_PORT` exists but is currently always derived from `LISTEN_PORT` and cannot be set independently.

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

* The `DBXX` prefixes must be numbered consecutively starting at `01` (`DB01`, `DB02`, `DB03`, ...). Gaps are not supported - the number of databases processed is derived from how many `DBXX_NAME` variables are present, so setting e.g. only `DB05_NAME` will not create anything.
* The official `MYSQL_DATABASE` / `MARIADB_DATABASE`, `MYSQL_USER` / `MARIADB_USER` and `MYSQL_PASSWORD` / `MARIADB_PASSWORD` variables are mapped onto `DB_NAME`, `DB_USER` and `DB_PASS`, which in turn become `DB01_*` when those are unset.

##### Restore on startup

This image can import SQL dumps into databases created during initialization using per-database environment variables. Set `DB01_RESTORE_FILE`, `DB02_RESTORE_FILE`, ... to point to a SQL dump file that is readable inside the container.

| Parameter           | Description                                                                     | Default           | `_FILE` | Advanced |
| ------------------- | ------------------------------------------------------------------------------- | ----------------- | ------- | -------- |
| `DBXX_RESTORE_FILE` | Path and file inside container containing database dump to restore.              |                   | x       |          |
| `DBXX_RESTORE_MODE` | Restore using logic                                                             | `${RESTORE_MODE}` | x       |          |
|                     | `INIT` / `FRESH` restores only on database initialization (database must be empty) |                   |         |          |
|                     | `ONCE` / `SINGLE` restores the file once, overwriting the database even if it contains data |          |         |          |
|                     | `ALWAYS` / `FORCE` restores the database, overwriting on each container startup. |                   |         |          |
| `RESTORE_MODE`      | Default restore mode used for every database that has no `DBXX_RESTORE_MODE` set | `INIT`            |         |          |

>> `ROOT_PASS` must be set so the importer can authenticate as root.
>> If `DBxx_RESTORE_FILE` is set but the matching `DBxx_NAME` is missing the restore will be skipped and an error logged.
>> Supported input formats: plain SQL and common compressed formats — gzip (`.gz`), bzip2 (`.bz2`), xz (`.xz`) and zstd (`.zst`).
>> Modes that only run once (`ONCE`, `SINGLE`, `INIT`, `FRESH`) write a file into ${DATA_PATH}/.restore_<db_name> to prevent re-importing. Delete this file to allow re-importing for that database.
>> Any other value is rejected with an error and the restore for that database is skipped.

#### Logging Options

| Parameter                  | Description                                                  | Default            |
| -------------------------- | ------------------------------------------------------------ | ------------------ |
| `ENABLE_LOG_ERROR`         | Enable Error Logging                                         | `TRUE`             |
| `ENABLE_LOG_GENERAL_QUERY` | Log all connections and queries to server (performance hit!) | `FALSE`            |
| `ENABLE_LOG_SLOW_QUERY`    | Log all slow queries                                         | `FALSE`            |
| `LOG_LEVEL`                | Log Level for warnings `0` to `9`                            | `2`                |
| `LOG_FILE_ERROR`           | Error Log File Name                                          | `error.log`        |
| `LOG_FILE_GENERAL_QUERY`   | General Query Log File name                                  | `general.log`      |
| `LOG_FILE_SLOW_QUERY`      | Slow Query Log File Name                                     | `slowqueries.log`  |

#### Monitoring Options

Zabbix monitoring is configured automatically when monitoring is enabled in the base image. See the [container-base](https://github.com/nfrastack/container-base/) documentation for `CONTAINER_ENABLE_MONITORING` and `CONTAINER_MONITORING_BACKEND`. Companion Zabbix server templates live in the [zabbix_templates](zabbix_templates) folder.

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

This image comes with [Mysql Tuner](https://github.com/major/MySQLTuner-perl). Simply enter inside the container and execute `mysqltuner` along with your arguments.

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
