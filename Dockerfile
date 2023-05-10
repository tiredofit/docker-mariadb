ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.18

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG MARIADB_VERSION
ARG MYSQLTUNER_VERSION

ENV MARIADB_VERSION=${MARIADB_VERSION:-"10.6.12"} \
    MYSQLTUNER_VERSION=${MYSQLTUNER_VERSION:-"v1.9.9"} \
    MARIADB_REPO_URL=https://github.com/MariaDB/server \
    MYSQLTUNER_REPO_URL=https://github.com/major/MySQLTuner-perl \
    S6_SERVICES_GRACETIME=60000 \
    CONTAINER_NAME=mariadb-db \
    ZABBIX_AGENT_TYPE=modern \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="tiredofit/mariadb" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-mariadb/"

### Install Required Dependencies
RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install .mariadb-builddeps \
                    alpine-sdk \
                    asciidoc \
                    autoconf \
                    automake \
                    bison \
                    boost-dev \
                    bzip2-dev \
                    cmake \
                    curl-dev \
                    gnutls-dev \
                    libaio-dev \
                    libarchive-dev \
                    libevent-dev \
                    libxml2-dev \
                    linux-headers \
                    lz4-dev \
                    lzo-dev \
                    ncurses-dev \
                    pcre2-dev \
                    python3-dev \
                    py3-pip \
                    readline-dev \
                    xz-dev \
                    zlib-dev \
                    && \
    \
    package install .mariadb-rundeps \
                    aws-cli \
                    boost \
                    bzip2 \
                    geos \
                    gnutls \
                    ncurses-libs \
                    libaio \
                    libarchive \
                    libcurl \
                    lzo \
                    lz4 \
                    lz4-libs \
                    libstdc++ \
                    libxml2 \
                    perl \
                    perl-doc \
                    pigz \
                    proj \
                    pwgen \
                    py3-cryptography \
                    xz \
                    zstd \
                    && \
    \
    pip3 install blobxfer && \
    \
    addgroup -S -g 3306 mariadb && \
    adduser -S -D -H -u 3306 -G mariadb -g "MariaDB" mariadb && \
    \
    clone_git_repo "${MARIADB_REPO_URL}" "mariadb-${MARIADB_VERSION}" && \
    sed -i 's/END()/ENDIF()/' libmariadb/cmake/ConnectorName.cmake && \
    mkdir -p /tmp/_ && \
    cmake . \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCOMMON_C_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
        -DCOMMON_CXX_FLAGS="-O3 -s -fno-omit-frame-pointer -pipe" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DSYSCONFDIR=/etc/mysql \
        -DMYSQL_DATADIR=/var/lib/mysql \
        -DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock \
        -DDEFAULT_CHARSET=utf8mb4 \
        -DDEFAULT_COLLATION=utf8mb4_general_ci \
        -DINSTALL_INFODIR=share/mysql/docs \
        -DINSTALL_MANDIR=/tmp/_/share/man \
        -DINSTALL_PLUGINDIR=lib/mysql/plugin \
        -DINSTALL_SCRIPTDIR=bin \
        -DINSTALL_DOCREADMEDIR=/tmp/_/share/mysql \
        -DINSTALL_SUPPORTFILESDIR=share/mysql \
        -DINSTALL_MYSQLSHAREDIR=share/mysql \
        -DINSTALL_DOCDIR=/tmp/_/share/mysql/docs \
        -DINSTALL_SHAREDIR=share/mysql \
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
        -DWITH_PCRE=system \
        -DWITH_READLINE=ON \
        -DWITH_ROCKSDB_BZIP2=OFF \
        -DWITH_ROCKSDB_JEMALLOC=OFF \
        -DWITH_ROCKSDB_LZ4=OFF \
        -DWITH_ROCKSDB_SNAPPY=OFF \
        -DWITH_ROCKSDB_ZSTD=OFF \
        -DWITH_SSL=bundled \
        -DWITH_SYSTEMD=no \
        -DWITH_UNIT_TESTS=OFF \
        -DWITH_VALGRIND=OFF \
        -DWITH_ZLIB=system \
        -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
        -DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
        -DWITHOUT_PBXT_STORAGE_ENGINE=1 \
        && \
    \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    \
    # Patch for missing PAM Plugin
    sed -i 's/^.*auth_pam_tool_dir.*$/#auth_pam_tool_dir not exists/' /usr/bin/mysql_install_db && \
    \
    ### Fetch and Install MySQLTuner
    clone_git_repo "${MYSQLTUNER_REPO_URL}" "${MYSQLTUNER_VERSION}" && \
    mkdir -p /usr/share/mysqltuner && \
    cp -R basic_passwords.txt /usr/share/mysqltuner && \
    cp -R vulnerabilities.csv /usr/share/mysqltuner && \
    mv mysqltuner.pl /usr/sbin/mysqltuner && \
    chmod +x /usr/sbin/mysqltuner && \
    \
    ### Fetch and install parallel PBZip2
    mkdir -p /usr/src/pbzip2 && \
    curl -ssL https://launchpad.net/pbzip2/1.1/1.1.13/+download/pbzip2-1.1.13.tar.gz | tar xvfz - --strip=1 -C /usr/src/pbzip2 && \
    cd /usr/src/pbzip2 && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    strip /usr/bin/pbzip2 && \
    \
    # Fetch and compile pixz
    clone_git_repo "https://github.com/vasi/pixz" && \
    ./autogen.sh && \
    ./configure && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    strip /usr/local/bin/pixz && \
    \
    package remove .mariadb-builddeps && \
    package cleanup && \
    \
    rm -rf \
            /root/.cache \
            /tmp/* \
            /usr/bin/mysql_client_test \
            /usr/bin/mysqltest \
            /usr/data \
            /usr/mysql-test \
            /usr/sql-bench \
            /usr/src/*

EXPOSE 3306

COPY install /
