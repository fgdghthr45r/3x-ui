FROM debian:12-slim

ENV TZ=Asia/Tehran

RUN apt update && apt install -y \
    curl \
    bash \
    ca-certificates \
    tzdata \
    sqlite3 \
    socat \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime

# Install X-UI
RUN mkdir -p /usr/local/x-ui \
    && curl -L \
    https://github.com/Sir-MmD/vpn-ui/releases/download/v1.7.9/vpn-ui-amd64 \
    -o /usr/local/x-ui/x-ui \
    && chmod +x /usr/local/x-ui/x-ui

# Create directories
RUN mkdir -p /etc/x-ui /var/log/x-ui /etc/nginx

# Create nginx.conf template
RUN echo 'events {\n    worker_connections 1024;\n}\n\nhttp {\n    include /etc/nginx/mime.types;\n    default_type application/octet-stream;\n\n    server {\n        listen 3000;\n        listen [::]:3000;\n        server_name _;\n\n        location / {\n            proxy_pass http://127.0.0.1:2053;\n            proxy_set_header Host \$host;\n            proxy_set_header X-Real-IP \$remote_addr;\n            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;\n            proxy_set_header X-Forwarded-Proto \$scheme;\n        }\n    }\n}' > /etc/nginx/nginx.conf.template

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
