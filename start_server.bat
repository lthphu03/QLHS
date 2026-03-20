@echo off
chcp 65001 >nul
color 0B
title Backend Server - Port 3001

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                               ║
echo ║              BACKEND SERVER - ĐANG KHỞI ĐỘNG...              ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

cd server

REM Kiểm tra .env
if not exist .env (
    echo ❌ Không tìm thấy file .env!
    echo.
    echo Vui lòng tạo file .env từ .env.example
    pause
    exit /b 1
)

REM Kiểm tra node_modules
if not exist node_modules (
    echo ⚠️  Dependencies chưa được cài đặt!
    echo    Đang cài đặt...
    call npm install
)

echo.
echo ✓ Đang khởi động server...
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

npm run dev
