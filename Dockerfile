FROM docker.io/tiredofit/alpine:3.17
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV MARIADB_VERSION=10.4.28 \
    MYSQLTUNER_VERSION=v1.9.9 \
    S6_SERVICES_GRACETIME=60000 \
    CONTAINER_NAME=mariadb-db \
    ZABBIX_AGENT_TYPE=classic \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    CONTAINER_ENABLE_SCHEDULING=TRUE \
    IMAGE_NAME="tiredofit/mariadb:10.4" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-mariadb/"

### Install Required Dependencies
RUN export CPU=`cat /proc/cpuinfo | grep -c processor` && \
    \
    apk update && \
    apk upgrade && \
    \
    # Install Dependencies
    apk add -t .mariadb-builddeps \
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
                libxml2-dev \
                linux-headers \
                lz4-dev \
                lzo-dev \
                ncurses-dev \
                openssl-dev \
                && \
    \
    apk add -t .mariadb-rundeps \
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
                openssl \
                libstdc++ \
                libxml2 \
                perl \
                perl-doc \
                pigz \
                proj \
                pwgen \
                xz \
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
    sed -i 's/END()/ENDIF()/' libmariadb/cmake/ConnectorName.cmake && \
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
        -DWITH_EMBEDDED_SERVER=OFF \
        -DWITH_UNIT_TESTS=OFF \
        -DENABLED_PROFILING=OFF \
        -DENABLE_DEBUG_SYNC=OFF \
        && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    \
    # Install
    make install && \
    \
    # Patch for missing PAM Plugin
    sed -i 's/^.*auth_pam_tool_dir.*$/#auth_pam_tool_dir not exists/' /usr/bin/mysql_install_db && \
    \
    ### Fetch and Install MySQLTuner
    mkdir -p /usr/src/mysqltuner && \
    curl -sSL https://github.com/major/MySQLTuner-perl/archive/${MYSQLTUNER_VERSION}.tar.gz | tar xvfz - --strip 1 -C /usr/src/mysqltuner && \
    cd /usr/src/mysqltuner && \
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
    make && \
    make install && \
    \
    # Fetch and compile pixz 
    mkdir -p /usr/src/pixz && \
    cd /usr/src/pixz && \
    git clone https://github.com/vasi/pixz.git /usr/src/pixz && \
    ./autogen.sh && \
    ./configure && \
    make -j$(getconf _NPROCESSORS_ONLN) && \
    make install && \
    \
    # Create needed directories and set permissions
    mkdir -p /var/lib/mysql && \
    mkdir -p /run/mysqld && \
    mkdir /etc/mysql/conf.d && \
    chown -R mariadb:mariadb /var/lib/mysql && \
    chown -R mariadb:mariadb /run/mysqld && \
    \
    # Clean everything
    rm -rf /usr/src/* && \
    rm -rf /tmp/* && \
    rm -rf /usr/sql-bench && \
    rm -rf /usr/mysql-test && \
    rm -rf /usr/data && \
    rm -rf /usr/lib/python2.7 && \
    rm -rf /usr/bin/mysql_client_test && \
    rm -rf /usr/bin/mysqltest && \
    \
    # Remove packages
    apk del .mariadb-builddeps && \
    rm -rf /var/cache/apk/*

### Networking
EXPOSE 3306

### Add folders
ADD install /
