#!/bin/bash

WEB_PORT=3000

echo "🚀 Starting X-UI on port ${WEB_PORT}..."

# تنظیم X-UI روی پورت ۳۰۰۰
#/usr/local/x-ui/x-ui setting -port ${WEB_PORT} -webBasePath /xui

/usr/local/x-ui/x-ui setting -port 2053 -webBasePath /xui/ || true



echo "🔧 Building nginx.conf for fixed port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
# اجرای مستقیم X-UI
/usr/local/x-ui/x-ui
