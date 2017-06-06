FROM centos:6

MAINTAINER Dmitry Maslennikov <mrdaimor@gmail.com>

# update OS + dependencies & run Caché silent instal
RUN yum -y update \
 && yum -y install which tar hostname net-tools wget \
 && yum -y clean all

ARG version=2016.2.1.803.0
ARG product=cache

ENV TMP_INSTALL_DIR=/tmp/distrib

# vars for Caché silent install
ENV ISC_PACKAGE_INSTANCENAME=$product \
    ISC_PACKAGE_INSTALLDIR="/opt/$product/" \
    ISC_PACKAGE_UNICODE="Y" \
    ISC_PACKAGE_CLIENT_COMPONENTS=""

# set-up and install Caché from distrib_tmp dir 
WORKDIR ${TMP_INSTALL_DIR}

ADD $product-$build-lnxrhx64.tar.gz

# cache distributive
RUN [[ -d "$product-$version-lnxrhx64" ]] && ./$product-$version-lnxrhx64/cinstall_silent || ./cinstall_silent \
 && ccontrol stop $ISC_PACKAGE_INSTANCENAME quietly \
# Caché container main process PID 1 (https://github.com/zrml/ccontainermain)
 && curl -L https://github.com/daimor/ccontainermain/raw/master/distrib/linux/ccontainermain -o /ccontainermain \
 && chmod +x /ccontainermain \
 && rm -rf $TMP_INSTALL_DIR 

WORKDIR ${ISC_PACKAGE_INSTALLDIR}

# TCP sockets that can be accessed if user wants to (see 'docker run -p' flag)
EXPOSE 57772 1972

ENTRYPOINT ["/ccontainermain", "-cconsole", "-i", $product]