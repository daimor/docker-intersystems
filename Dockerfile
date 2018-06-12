FROM centos:latest

LABEL maintainer="Dmitry Maslennikov <mrdaimor@gmail.com>"

# update OS + dependencies & run Caché silent instal
RUN yum -y update \
 && yum -y install \
            which \
            tar \
            hostname \
            net-tools \
            wget \
            java-1.8.0-openjdk-devel \
 && yum -y clean all

ARG version=2018.1.1.643.0
ARG product=IRIS

ENV TMP_INSTALL_DIR=/tmp/distrib

# vars for Caché silent install
ENV ISC_PACKAGE_INSTANCENAME=IRIS \
    ISC_PACKAGE_INSTALLDIR="/usr/irissys/" \
    ISC_PACKAGE_UNICODE="Y" \
    ISC_PACKAGE_CLIENT_COMPONENTS=""

# set-up and install Caché from distrib_tmp dir 
WORKDIR ${TMP_INSTALL_DIR}

ADD $product-$version-lnxrhx64.tar.gz .

# cache distributive
RUN ./$product-$version-lnxrhx64/irisinstall_silent \
 && iris stop $ISC_PACKAGE_INSTANCENAME quietly \
# Caché container main process PID 1 (https://github.com/zrml/ccontainermain)
 && curl -L https://github.com/daimor/ccontainermain/releases/download/0.7/ccontainermain -o /ccontainermain \
 && chmod +x /ccontainermain \
# clean temp folder
 && rm -rf $TMP_INSTALL_DIR 

WORKDIR ${ISC_PACKAGE_INSTALLDIR}

# TCP sockets that can be accessed if user wants to (see 'docker run -p' flag)
EXPOSE 51773 52773 53773

ENTRYPOINT ["/ccontainermain", "-cconsole", "-iris"]