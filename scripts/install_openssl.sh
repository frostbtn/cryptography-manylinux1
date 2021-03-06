#!/bin/bash
set -xe

OPENSSL_URL="ftp://ftp.openssl.org/source"
OPENSSL_NAME="openssl-1.0.2h"
OPENSSL_SHA256="1d4007e53aad94a5b2002fe045ee7bb0b3d98f1a47f8b2bc851dcd1c74332919"

function check_sha256sum {
    local fname=$1
    local sha256=$2
    echo "${sha256}  ${fname}" > ${fname}.sha256
    sha256sum -c ${fname}.sha256
    rm ${fname}.sha256
}

curl -#O ${OPENSSL_URL}/${OPENSSL_NAME}.tar.gz
check_sha256sum ${OPENSSL_NAME}.tar.gz ${OPENSSL_SHA256}
tar zxvf ${OPENSSL_NAME}.tar.gz
cd ${OPENSSL_NAME}
if [[ $1 == "x86_64" ]]; then
    echo "Configuring for x86_64"
    ./Configure linux-x86_64 no-ssl2 no-comp enable-ec_nistp_64_gcc_128 shared --prefix=/usr/local --openssldir=/usr/local
else
    echo "Configuring for i686"
    ./Configure linux-generic32 no-ssl2 no-comp shared --prefix=/usr/local --openssldir=/usr/local
fi
make depend
make install
