@echo off
chcp 65001 >nul
color 0A
title Hệ thống Quản lý Học sinh - Setup

echo.
echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                               ║
echo ║        HỆ THỐNG QUẢN LÝ HỌC SINH - CÀI ĐẶT TỰ ĐỘNG          ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.

REM Kiểm tra Node.js
echo [1/5] Kiểm tra Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js chưa được cài đặt!
    echo.
    echo Vui lòng cài Node.js từ: https://nodejs.org
    echo Sau đó chạy lại file này.
    pause
    exit /b 1
)
echo ✓ Node.js đã được cài đặt
echo.

REM Kiểm tra SQL Server
echo [2/5] Kiểm tra SQL Server...
sqlcmd -S localhost\SQLEXPRESS -E -Q "SELECT @@VERSION" >nul 2>&1
if errorlevel 1 (
    echo ❌ SQL Server chưa được cài đặt hoặc chưa chạy!
    echo.
    echo Vui lòng:
    echo 1. Cài SQL Server Express từ: https://www.microsoft.com/sql-server/sql-server-downloads
    echo 2. Hoặc khởi động SQL Server service trong Services
    pause
    exit /b 1
)
echo ✓ SQL Server đang chạy
echo.

REM Tạo database
echo [3/5] Tạo database...
if exist database_setup.sql (
    sqlcmd -S localhost\SQLEXPRESS -E -i database_setup.sql >nul 2>&1
    if errorlevel 1 (
        echo ❌ Lỗi khi tạo database!
        pause
        exit /b 1
    )
    echo ✓ Database đã được tạo
) else (
    echo ⚠️  Không tìm thấy file database_setup.sql
)
echo.

REM Cài đặt server
echo [4/5] Cài đặt Backend Server...
cd server
if not exist node_modules (
    echo    Đang cài đặt dependencies...
    call npm install >nul 2>&1
    if errorlevel 1 (
        echo ❌ Lỗi khi cài đặt server dependencies!
        cd ..
        pause
        exit /b 1
    )
)
echo ✓ Server dependencies đã được cài đặt
echo.

REM Seed dữ liệu
echo    Đang tạo dữ liệu mẫu...
node prisma/seed_all.js >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Có lỗi khi tạo dữ liệu mẫu (có thể đã tồn tại)
) else (
    echo ✓ Dữ liệu mẫu đã được tạo
)
cd ..
echo.

REM Cài đặt client
echo [5/5] Cài đặt Frontend Client...
cd client
if not exist node_modules (
    echo    Đang cài đặt dependencies...
    call npm install >nul 2>&1
    if errorlevel 1 (
        echo ❌ Lỗi khi cài đặt client dependencies!
        cd ..
        pause
        exit /b 1
    )
)
echo ✓ Client dependencies đã được cài đặt
cd ..
echo.

echo ╔═══════════════════════════════════════════════════════════════╗
echo ║                                                               ║
echo ║                  ✅ CÀI ĐẶT HOÀN TẤT!                        ║
echo ║                                                               ║
echo ╚═══════════════════════════════════════════════════════════════╝
echo.
echo 📋 Thông tin đăng nhập:
echo    Email: admin@school.com
echo    Password: admin123
echo.
echo 🚀 Để khởi động hệ thống:
echo    1. Chạy file: start_server.bat
echo    2. Chạy file: start_client.bat
echo    3. Mở trình duyệt: http://localhost:5173
echo.
echo ⚠️  Lưu ý: Đổi mật khẩu admin ngay sau khi đăng nhập!
echo.
pause
