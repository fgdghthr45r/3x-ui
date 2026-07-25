#!/bin/bash

WEB_PORT=3000

echo "🚀 Starting X-UI on port ${WEB_PORT}..."

# تنظیم X-UI روی پورت ۳۰۰۰
/usr/local/x-ui/x-ui setting -port ${WEB_PORT} -webBasePath /xui

# اجرای مستقیم X-UI
/usr/local/x-ui/x-ui
