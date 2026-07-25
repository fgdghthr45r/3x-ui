#!/bin/bash

# دریافت پورت از Railway
WEB_PORT=${PORT:-3000}

echo "🚀 Starting X-UI directly on port ${WEB_PORT}..."

# تنظیم X-UI روی پورت مورد نظر
/usr/local/x-ui/x-ui setting -port ${WEB_PORT} -webBasePath /xui

# اجرای مستقیم X-UI در foreground
/usr/local/x-ui/x-ui
