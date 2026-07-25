#!/bin/bash

WEB_PORT=3000

echo "🚀 Starting X-UI on port ${WEB_PORT}..."

# شروع X-UI در پس‌زمینه
/usr/local/x-ui/x-ui &

sleep 3

# تنظیم X-UI
/usr/local/x-ui/x-ui setting -port ${WEB_PORT} -webBasePath /xui

# کانفیگ nginx برای پورت ۳۰۰۰
cat > /etc/nginx/nginx.conf << EOF
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen ${WEB_PORT};
        listen [::]:${WEB_PORT};
        server_name _;

        location / {
            proxy_pass http://127.0.0.1:${WEB_PORT};
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
        
        location /xui/ {
            proxy_pass http://127.0.0.1:${WEB_PORT}/xui/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

# تست و اجرای nginx
nginx -t
nginx -g "daemon off;"
