#!/bin/bash -ex
# -----------------------------------------------------------------------------
#
# Package	 : apache-iceberg
# Version	 : apache-iceberg-1.6.0
# Source repo	 : https://github.com/apache/iceberg
# Tested on	 : UBI 9.3
# Language       : Java
# Travis-Check   : false
# Script License : Apache License, Version 2 or later
# Maintainer	 : Prachi Gaonkar <prachi.gaonkar@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------

PACKAGE_NAME=iceberg
SCRIPT_PACKAGE_VERSION=apache-iceberg-1.6.0
PACKAGE_VERSION=${1:-${SCRIPT_PACKAGE_VERSION}}
PACKAGE_VERSION_AZURE=${2:-3.30.0}
PACKAGE_URL=https://github.com/apache/${PACKAGE_NAME}.git
SCRIPT_PATH=$(dirname $(realpath $0))
BUILD_HOME=$(pwd)

#Install deps
yum install -y  git java-17-openjdk java-17-openjdk-devel
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PATH=$JAVA_HOME/bin:$PATH

#Build ppc64le supported Azurite Image
cd $BUILD_HOME
git clone https://github.com/Azure/Azurite.git && cd Azurite
git checkout v${PACKAGE_VERSION_AZURE}
sed  -i '5 a \\n#Add ppc64le dependencies \nRUN apk add python3 python3-dev g++ make pkgconfig libsecret-dev' Dockerfile
docker build --rm -t mcr.microsoft.com/azure-storage/azurite-ppc64le .

#Clone iceberg code
cd $BUILD_HOME
git clone ${PACKAGE_URL}
cd ${PACKAGE_NAME}
git checkout ${PACKAGE_VERSION}

#Apply patch
git apply $BUILD_HOME/${PACKAGE_NAME}_${PACKAGE_VERSION}.patch


ret=0
# Invoke Build without Tests
./gradlew build -x test -x integrationTest || ret=$?
if [ "$ret" -ne 0 ]
then
        echo "Build fail."
        exit 1
fi

echo "Build is successful."

ret=0
#Invoke Build with Unit and Integration tests (minus one task)
./gradlew build -x iceberg-kafka-connect:iceberg-kafka-connect-runtime:integrationTest|| ret=$?
if [ "$ret" -ne 0 ]
then
        echo "Build with Tests fail."
        exit 2
fi


echo "Build with testcases successful."
