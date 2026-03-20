@echo off
chcp 65001 >nul
color 0E
title Frontend Client - Port 5173

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                               ║
echo ║              FRONTEND CLIENT - ĐANG KHỞI ĐỘNG...             ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

cd client

REM Kiểm tra node_modules
if not exist node_modules (
    echo ⚠️  Dependencies chưa được cài đặt!
    echo    Đang cài đặt...
    call npm install
)

echo.
echo ✓ Đang khởi động client...
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🌐 Truy cập: http://localhost:5173
echo 📧 Email: admin@school.com
echo 🔑 Password: admin123
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

npm run dev
