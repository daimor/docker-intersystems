#!/bin/sh

if [ -z "$FIELDTEST" ]; then
  FILE="/wrc/distrib/$ISC_PRODUCT-$ISC_BUILD-lnxrhx64.tar.gz"
else 
  FILE="/wrc/FieldTest/$FIELDTEST/$ISC_PRODUCT-$ISC_BUILD-lnxrhx64.tar.gz"
fi

wget -qO /dev/null --keep-session-cookies \
 --save-cookies /dev/stdout \
 --post-data="UserName=$WRC_USERNAME&Password=$WRC_PASSWORD" \
 'https://login.intersystems.com/login/SSO.UI.Login.cls?referrer=https%253A//wrc.intersystems.com/wrc/login.csp' \
 | wget -O $ISC_PRODUCT-$ISC_BUILD-lnxrhx64.tar.gz --load-cookies /dev/stdin \
 "https://wrc.intersystems.com/wrc/WRC.StreamServer.cls?FILE=$FILE"