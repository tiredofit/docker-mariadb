FROM tiredofit/alpine:3.8
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV MARIADB_VERSION=10.3.9 \
    ZABBIX_HOSTNAME=mariadb-db \
    ENABLE_SMTP=FALSE

### Install Required Dependencies
RUN export CPU=`cat /proc/cpuinfo | grep -c processor` && \
    \
    # Add testing repo
    echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    \
    # Install Dependencies
    apk add -t .mariadb-builddeps \
        alpine-sdk \
        bison \
        boost-dev \
        cmake \
        curl-dev \
        gnutls-dev \
        libaio-dev \
        libressl-dev \
        libxml2-dev \
        linux-headers \
        ncurses-dev \
        && \
    \
    apk add -t .mariadb-rundeps \
        boost \
        geos \
        gnutls \
        ncurses-libs \
        libaio \
        libcurl \
        libressl \
        libstdc++ \
        libxml2 \
        pwgen \
        proj4 \
        && \
    \
    # Add group and user for mysql
    addgroup -S -g 3306 mariadb && \
    adduser -S -D -H -u 3306 -G mariadb -g "MariaDB" mariadb && \
    \
    # Download and unpack mariadb
    mkdir -p /etc/mysql && \
    mkdir -p /usr/src/mariadb && \
    curl -sSL https://downloads.mariadb.com/MariaDB/mariadb-${MARIADB_VERSION}/source/mariadb-${MARIADB_VERSION}.tar.gz | tar xvfz - --strip 1 -C /usr/src/mariadb && \
    \
    # Build maridb
    mkdir -p /tmp/_ && \
    cd /usr/src/mariadb && \
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
        -DENABLED_LOCAL_INFILE=ON \
        -DINSTALL_INFODIR=share/mysql/docs \
        -DINSTALL_MANDIR=/tmp/_/share/man \
        -DINSTALL_PLUGINDIR=lib/mysql/plugin \
        -DINSTALL_SCRIPTDIR=bin \
        # -DINSTALL_INCLUDEDIR=/tmp/_/include/mysql \
        -DINSTALL_DOCREADMEDIR=/tmp/_/share/mysql \
        -DINSTALL_SUPPORTFILESDIR=share/mysql \
        -DINSTALL_MYSQLSHAREDIR=share/mysql \
        -DINSTALL_DOCDIR=/tmp/_/share/mysql/docs \
        -DINSTALL_SHAREDIR=share/mysql \
        -DWITH_READLINE=ON \
        -DWITH_ZLIB=system \
        -DWITH_SSL=system \
        -DWITH_LIBWRAP=OFF \
        -DWITH_JEMALLOC=no \
        -DWITH_EXTRA_CHARSETS=complex \
        -DPLUGIN_ARCHIVE=STATIC \
        -DPLUGIN_BLACKHOLE=DYNAMIC \
        -DPLUGIN_INNOBASE=STATIC \
        -DPLUGIN_PARTITION=AUTO \
        -DPLUGIN_CONNECT=NO \
        -DPLUGIN_TOKUDB=NO \
        -DPLUGIN_FEEDBACK=NO \
        -DPLUGIN_OQGRAPH=NO \
        -DPLUGIN_FEDERATED=NO \
        -DPLUGIN_FEDERATEDX=NO \
        -DWITHOUT_FEDERATED_STORAGE_ENGINE=1 \
        -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
        -DWITHOUT_PBXT_STORAGE_ENGINE=1 \
        -DWITHOUT_ROCKSDB_STORAGE_ENGINE=1 \
        -DWITH_EMBEDDED_SERVER=OFF \
        -DWITH_UNIT_TESTS=OFF \
        -DENABLED_PROFILING=OFF \
        -DENABLE_DEBUG_SYNC=OFF \
        && \
    make -j${CPU} && \
    \
    # Install
    make -j${CPU} install && \
    \
    # Clean everything
    rm -rf /usr/src && \
    rm -rf /tmp/_ && \
    rm -rf /usr/sql-bench && \
    rm -rf /usr/mysql-test && \
    rm -rf /usr/data && \
    rm -rf /usr/lib/python2.7 && \
    rm -rf /usr/bin/mysql_client_test && \
    rm -rf /usr/bin/mysqltest && \
    \
    # Remove packages
    apk del .mariadb-builddeps && \
    \
    # Create needed directories
    mkdir -p /var/lib/mysql && \
    mkdir -p /run/mysqld && \
    mkdir /etc/mysql/conf.d && \
    \
    # Set permissions
    chown -R mariadb:mariadb /var/lib/mysql && \
    chown -R mariadb:mariadb /run/mysqld && \
    rm -rf /var/cache/apk/*

### Networking
EXPOSE 3306

### Files Setup
ADD install/ /
