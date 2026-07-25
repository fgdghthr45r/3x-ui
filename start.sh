#!/bin/bash

# Start X-UI in background
echo "🚀 Starting X-UI..."
/usr/local/x-ui/x-ui &

# Wait for X-UI to be ready
sleep 3

# Configure X-UI panel
echo "🔧 Applying panel settings via x-ui CLI..."
/usr/local/x-ui/x-ui setting -port 2053 -webBasePath /xui

# Set default port if not provided
WEB_PORT=${WEB_PORT:-3000}

# Create nginx config directly with the actual port value
echo "🔧 Creating nginx.conf for port: ${WEB_PORT}"
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
            proxy_pass http://127.0.0.1:2053;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
        
        location /xui/ {
            proxy_pass http://127.0.0.1:2053/xui/;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

# Test nginx config
echo "🔍 Testing nginx configuration..."
nginx -t

if [ $? -eq 0 ]; then
    echo "✅ nginx configuration is valid"
    echo "🌐 Starting nginx on port ${WEB_PORT}..."
    nginx -g "daemon off;"
else
    echo "❌ nginx configuration failed"
    exit 1
fi
