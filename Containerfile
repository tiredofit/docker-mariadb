# SPDX-FileCopyrightText: © 2025 Nfrastack <code@nfrastack.com>
#
# SPDX-License-Identifier: MIT

ARG \
    BASE_IMAGE

FROM ${BASE_IMAGE}

LABEL \
        org.opencontainers.image.title="MariaDB" \
        org.opencontainers.image.description="Relational database engine" \
        org.opencontainers.image.url="https://hub.docker.com/r/nfrastack/mariadb" \
        org.opencontainers.image.documentation="https://github.com/nfrastack/container-mariadb/blob/main/README.md" \
        org.opencontainers.image.source="https://github.com/nfrastack/container-mariadb.git" \
        org.opencontainers.image.authors="Nfrastack <code@nfrastack.com>" \
        org.opencontainers.image.vendor="Nfrastack <https://www.nfrastack.com>" \
        org.opencontainers.image.licenses="MIT"

ARG \
    MARIADB_VERSION="11.8.9" \
    MARIADB_REPO_URL="https://github.com/mariadb/server" \
    MYSQLTUNER_REPO_URL="https://github.com/major/MySQLTuner-perl" \
    MYSQLTUNER_VERSION="v2.9.1"

COPY CHANGELOG.md /usr/src/container/CHANGELOG.md
COPY LICENSE /usr/src/container/LICENSE
COPY README.md /usr/src/container/README.md

ENV \
    S6_SERVICES_GRACETIME=60000 \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="nfrastack/mariadb" \
    IMAGE_REPO_URL="https://github.com/nfrastack/container-mariadb/"

EXPOSE 3306

RUN echo "" && \
    MARIADB_BUILD_DEPS_ALPINE=" \
                                alpine-sdk \
                                asciidoc \
                                autoconf \
                                automake \
                                bison \
                                boost-dev \
                                cmake \
                                curl-dev \
                                gnutls-dev \
                                libaio-dev \
                                libarchive-dev \
                                libevent-dev \
                                libxml2-dev \
                                linux-headers \
                                ncurses-dev \
                                pcre2-dev \
                                readline-dev \
                                zlib-dev \
                              " \
                              && \
    MARIADB_RUN_DEPS_ALPINE=" \
                               boost \
                               geos \
                               gnutls \
                               ncurses-libs \
                               libaio \
                               libarchive \
                               libcurl \
                               libstdc++ \
                               libxml2 \
                               proj \
                               pwgen \
                            " \
                            && \
    \
    MYSQLTUNER_RUN_DEPS_ALPINE=" \
                                  perl \
                                  perl-doc \
                               " \
                               && \
    \
    source /container/base/functions/container/build && \
    container_build_log image && \
    create_user mariadb 3306 mariadb 3306 /dev/null && \
    package update && \
    package upgrade && \
    package install \
                        MARIADB_BUILD_DEPS \
                        MARIADB_RUN_DEPS \
                        MYSQLTUNER_RUN_DEPS \
                        && \
    clone_git_repo "${MARIADB_REPO_URL}" "mariadb-${MARIADB_VERSION}" && \
    sed -i 's/END()/ENDIF()/' libmariadb/cmake/ConnectorName.cmake && \
    sed -i "\@#include <string>@a#include <cstdint>" wsrep-lib/include/wsrep/provider_options.hpp && \
    mkdir -p /tmp/_ && \
    cmake . \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCOMMON_C_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
        -DCOMMON_CXX_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DSYSCONFDIR=/etc/mariadb \
        -DMYSQL_DATADIR=/var/lib/mariadb \
        -DMYSQL_UNIX_ADDR=/run/mariadb/mariadbd.sock \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_general_ci \
        -DINSTALL_INFODIR=share/mariadb/docs \
        -DINSTALL_MANDIR=/tmp/_/share/man \
        -DINSTALL_PLUGINDIR=lib/mariadb/plugin \
        -DINSTALL_SCRIPTDIR=bin \
        -DINSTALL_DOCREADMEDIR=/tmp/_/share/mariadb \
        -DINSTALL_SUPPORTFILESDIR=share/mariadb \
        -DINSTALL_MYSQLSHAREDIR=share/mariadb \
        -DINSTALL_DOCDIR=/tmp/_/share/mariadb/docs \
        -DINSTALL_SHAREDIR=share/mariadb \
        -DCONNECT_WITH_MYSQL=ON \
        -DCONNECT_WITH_LIBXML2=system \
        -DCONNECT_WITH_ODBC=NO \
        -DCONNECT_WITH_JDBC=NO \
        -DENABLED_PROFILING=OFF \
        -DENABLED_LOCAL_INFILE=ON \
        -DENABLE_DEBUG_SYNC=OFF \
        -DPLUGIN_ARCHIVE=YES \
        -DPLUGIN_ARIA=YES \
        -DPLUGIN_AUTH_GSSAPI=NO \
        -DPLUGIN_AUTH_GSSAPI_CLIENT=OFF \
        -DPLUGIN_BLACKHOLE=YES \
        -DPLUGIN_CASSANDRA=NO \
        -DPLUGIN_CONNECT=NO \
        -DPLUGIN_CRACKLIB_PASSWORD_CHECK=NO \
        -DPLUGIN_CSV=YES \
        -DPLUGIN_FEDERATED=NO \
        -DPLUGIN_FEDERATEDX=NO \
        -DPLUGIN_FEEDBACK=NO \
        -DPLUGIN_INNOBASE=STATIC \
        -DPLUGIN_MROONGA=NO \
        -DPLUGIN_MYISAM=YES \
        -DPLUGIN_OQGRAPH=NO \
        -DPLUGIN_PARTITION=AUTO \
        -DPLUGIN_ROCKSDB=NO \
        -DPLUGIN_SPHINX=NO \
        -DPLUGIN_TOKUDB=NO \
        -DWITH_ASAN=OFF \
        -DWITHOUT_DEBUG=ON \
        -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
        -DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
        -DWITHOUT_PBXT_STORAGE_ENGINE=1 \
        -DWITH_EMBEDDED_SERVER=OFF \
        -DWITH_EXTRA_CHARSETS=complex \
        -DWITH_INNODB_BZIP2=OFF \
        -DWITH_INNODB_LZ4=OFF \
        -DWITH_INNODB_LZMA=ON \
        -DWITH_INNODB_LZO=OFF \
        -DWITH_INNODB_SNAPPY=OFF \
        -DWITH_JEMALLOC=NO \
        -DWITH_LIBARCHIVE=system \
        -DWITH_LIBNUMA=NO \
        -DWITH_LIBWRAP=OFF \
        -DWITH_LIBWSEP=OFF \
        -DWITH_MARIABACKUP=ON \
        -DWITH_PAM=OFF \
        -DWITH_PCRE=system \
        -DWITH_READLINE=ON \
        -DWITH_ROCKSDB_BZIP2=OFF \
        -DWITH_ROCKSDB_JEMALLOC=OFF \
        -DWITH_ROCKSDB_LZ4=OFF \
        -DWITH_ROCKSDB_SNAPPY=OFF \
        -DWITH_ROCKSDB_ZSTD=OFF \
        -DWITH_SSL=bundled \
        -DWITH_SYSTEMD=no \
        -DWITH_TOKU=OFF \
        -DWITH_UNIT_TESTS=OFF \
        -DWITH_VALGRIND=OFF \
        -DWITH_ZLIB=system \
        && \
    make -j $(( $(nproc) > 1 ? $(nproc) - 1 : 1 )) && \
    make install && \
    mkdir -p /etc/mariadb && \
    chown mariadb:mariadb /etc/mariadb && \
    container_build_log add "MariaDB" "${MARIADB_VERSION}" "${MARIADB_REPO_URL}" && \
    \
    clone_git_repo "${MYSQLTUNER_REPO_URL}" "${MYSQLTUNER_VERSION}" && \
    mkdir -p /usr/share/mysqltuner && \
    cp -R basic_passwords.txt /usr/share/mysqltuner && \
    cp -R vulnerabilities.csv /usr/share/mysqltuner && \
    mv mysqltuner.pl /usr/local/bin/mysqltuner && \
    chmod +x /usr/local/bin/mysqltuner && \
    container_build_log add "MySQLTuner" "${MYSQLTUNER_VERSION}" "${MYSQLTUNER_REPO_URL}" && \
    package remove \
                    MARIADB_BUILD_DEPS \
                    && \
    package cleanup && \
    rm -rf \
            /usr/bin/{mysql_client_test,mysqltest} \
            /usr/{data,mysql-test,sql-bench}

COPY rootfs /
