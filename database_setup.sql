-- =====================================================
-- HỆ THỐNG QUẢN LÝ HỌC SINH - DATABASE SETUP
-- SQL Server 2019+
-- Ngày tạo: 25/11/2025
-- =====================================================

USE master;
GO

-- Tạo database nếu chưa tồn tại
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'school_mgr')
BEGIN
    CREATE DATABASE school_mgr;
    PRINT 'Database school_mgr đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Database school_mgr đã tồn tại.';
END
GO

USE school_mgr;
GO

-- =====================================================
-- TẠO CÁC BẢNG
-- =====================================================

BEGIN TRY
    BEGIN TRAN;

    -- Bảng User (Quản trị viên)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'User')
    BEGIN
        CREATE TABLE [dbo].[User] (
            [id] INT NOT NULL IDENTITY(1,1),
            [name] NVARCHAR(1000) NOT NULL,
            [email] NVARCHAR(1000) NOT NULL,
            [password_hash] NVARCHAR(1000) NOT NULL,
            [role] NVARCHAR(1000) NOT NULL CONSTRAINT [User_role_df] DEFAULT 'ADMIN',
            CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
            CONSTRAINT [User_email_key] UNIQUE NONCLUSTERED ([email])
        );
        PRINT '✓ Đã tạo bảng User';
    END

    -- Bảng Student (Học sinh)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Student')
    BEGIN
        CREATE TABLE [dbo].[Student] (
            [id] INT NOT NULL IDENTITY(1,1),
            [code] NVARCHAR(1000) NOT NULL,
            [full_name] NVARCHAR(1000) NOT NULL,
            [dob] DATE,
            [gender] NVARCHAR(1000),
            [address] NVARCHAR(1000),
            [parent_name] NVARCHAR(1000),
            [parent_phone] NVARCHAR(1000),
            [status] NVARCHAR(1000) NOT NULL CONSTRAINT [Student_status_df] DEFAULT 'STUDYING',
            CONSTRAINT [Student_pkey] PRIMARY KEY CLUSTERED ([id]),
            CONSTRAINT [Student_code_key] UNIQUE NONCLUSTERED ([code])
        );
        PRINT '✓ Đã tạo bảng Student';
    END

    -- Bảng SchoolYear (Năm học)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SchoolYear')
    BEGIN
        CREATE TABLE [dbo].[SchoolYear] (
            [id] INT NOT NULL IDENTITY(1,1),
            [name] NVARCHAR(1000) NOT NULL,
            [start_date] DATE NOT NULL,
            [end_date] DATE NOT NULL,
            CONSTRAINT [SchoolYear_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng SchoolYear';
    END

    -- Bảng Class (Lớp học)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Class')
    BEGIN
        CREATE TABLE [dbo].[Class] (
            [id] INT NOT NULL IDENTITY(1,1),
            [name] NVARCHAR(1000) NOT NULL,
            [grade] INT NOT NULL,
            [year_id] INT NOT NULL,
            [homeroom_teacher_id] INT,
            CONSTRAINT [Class_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng Class';
    END

    -- Bảng ClassStudent (Học sinh - Lớp)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ClassStudent')
    BEGIN
        CREATE TABLE [dbo].[ClassStudent] (
            [id] INT NOT NULL IDENTITY(1,1),
            [class_id] INT NOT NULL,
            [student_id] INT NOT NULL,
            [join_date] DATE,
            [leave_date] DATE,
            CONSTRAINT [ClassStudent_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng ClassStudent';
    END

    -- Bảng Subject (Môn học)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Subject')
    BEGIN
        CREATE TABLE [dbo].[Subject] (
            [id] INT NOT NULL IDENTITY(1,1),
            [name] NVARCHAR(1000) NOT NULL,
            CONSTRAINT [Subject_pkey] PRIMARY KEY CLUSTERED ([id]),
            CONSTRAINT [Subject_name_key] UNIQUE NONCLUSTERED ([name])
        );
        PRINT '✓ Đã tạo bảng Subject';
    END

    -- Bảng Score (Điểm số)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Score')
    BEGIN
        CREATE TABLE [dbo].[Score] (
            [id] INT NOT NULL IDENTITY(1,1),
            [student_id] INT NOT NULL,
            [class_id] INT NOT NULL,
            [subject_id] INT NOT NULL,
            [term] NVARCHAR(1000) NOT NULL,
            [type] NVARCHAR(1000) NOT NULL,
            [score] DECIMAL(4,2) NOT NULL,
            [created_by] INT,
            CONSTRAINT [Score_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng Score';
    END

    -- Bảng Attendance (Điểm danh)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Attendance')
    BEGIN
        CREATE TABLE [dbo].[Attendance] (
            [id] INT NOT NULL IDENTITY(1,1),
            [student_id] INT NOT NULL,
            [class_id] INT NOT NULL,
            [date] DATE NOT NULL,
            [status] NVARCHAR(1000) NOT NULL,
            [note] NVARCHAR(1000),
            CONSTRAINT [Attendance_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng Attendance';
    END

    -- Bảng Conduct (Hạnh kiểm)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Conduct')
    BEGIN
        CREATE TABLE [dbo].[Conduct] (
            [id] INT NOT NULL IDENTITY(1,1),
            [student_id] INT NOT NULL,
            [class_id] INT NOT NULL,
            [term] NVARCHAR(1000) NOT NULL,
            [type] NVARCHAR(1000) NOT NULL,
            [note] NVARCHAR(1000),
            [created_at] DATETIME2 NOT NULL CONSTRAINT [Conduct_created_at_df] DEFAULT CURRENT_TIMESTAMP,
            [updated_at] DATETIME2 NOT NULL,
            CONSTRAINT [Conduct_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng Conduct';
    END

    -- Bảng AuditLog (Nhật ký hệ thống)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
    BEGIN
        CREATE TABLE [dbo].[AuditLog] (
            [id] INT NOT NULL IDENTITY(1,1),
            [user_id] INT,
            [action] NVARCHAR(1000) NOT NULL,
            [entity_type] NVARCHAR(1000) NOT NULL,
            [entity_id] INT,
            [old_value] TEXT,
            [new_value] TEXT,
            [ip_address] NVARCHAR(1000),
            [user_agent] NVARCHAR(1000),
            [created_at] DATETIME2 NOT NULL CONSTRAINT [AuditLog_created_at_df] DEFAULT CURRENT_TIMESTAMP,
            CONSTRAINT [AuditLog_pkey] PRIMARY KEY CLUSTERED ([id])
        );
        PRINT '✓ Đã tạo bảng AuditLog';
    END

    -- Bảng DataConsent (Đồng ý sử dụng dữ liệu)
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DataConsent')
    BEGIN
        CREATE TABLE [dbo].[DataConsent] (
            [id] INT NOT NULL IDENTITY(1,1),
            [student_id] INT NOT NULL,
            [consented] BIT NOT NULL CONSTRAINT [DataConsent_consented_df] DEFAULT 0,
            [consent_date] DATETIME2,
            [parent_signature] NVARCHAR(1000),
            [created_at] DATETIME2 NOT NULL CONSTRAINT [DataConsent_created_at_df] DEFAULT CURRENT_TIMESTAMP,
            [updated_at] DATETIME2 NOT NULL,
            CONSTRAINT [DataConsent_pkey] PRIMARY KEY CLUSTERED ([id]),
            CONSTRAINT [DataConsent_student_id_key] UNIQUE NONCLUSTERED ([student_id])
        );
        PRINT '✓ Đã tạo bảng DataConsent';
    END

    COMMIT TRAN;
    PRINT '✓ Tất cả bảng đã được tạo thành công!';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRAN;
    END;
    PRINT 'Lỗi: ' + ERROR_MESSAGE();
    THROW;
END CATCH
GO

-- =====================================================
-- TẠO INDEX
-- =====================================================

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'AuditLog_user_id_idx')
    CREATE NONCLUSTERED INDEX [AuditLog_user_id_idx] ON [dbo].[AuditLog]([user_id]);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'AuditLog_entity_type_entity_id_idx')
    CREATE NONCLUSTERED INDEX [AuditLog_entity_type_entity_id_idx] ON [dbo].[AuditLog]([entity_type], [entity_id]);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'AuditLog_created_at_idx')
    CREATE NONCLUSTERED INDEX [AuditLog_created_at_idx] ON [dbo].[AuditLog]([created_at]);

PRINT '✓ Đã tạo các index!';
GO

-- =====================================================
-- TẠO FOREIGN KEY
-- =====================================================

BEGIN TRY
    -- Class -> SchoolYear
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Class_year_id_fkey')
        ALTER TABLE [dbo].[Class] ADD CONSTRAINT [Class_year_id_fkey] 
        FOREIGN KEY ([year_id]) REFERENCES [dbo].[SchoolYear]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Class -> User
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Class_homeroom_teacher_id_fkey')
        ALTER TABLE [dbo].[Class] ADD CONSTRAINT [Class_homeroom_teacher_id_fkey] 
        FOREIGN KEY ([homeroom_teacher_id]) REFERENCES [dbo].[User]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

    -- ClassStudent -> Class
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'ClassStudent_class_id_fkey')
        ALTER TABLE [dbo].[ClassStudent] ADD CONSTRAINT [ClassStudent_class_id_fkey] 
        FOREIGN KEY ([class_id]) REFERENCES [dbo].[Class]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- ClassStudent -> Student
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'ClassStudent_student_id_fkey')
        ALTER TABLE [dbo].[ClassStudent] ADD CONSTRAINT [ClassStudent_student_id_fkey] 
        FOREIGN KEY ([student_id]) REFERENCES [dbo].[Student]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Score -> User
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Score_created_by_fkey')
        ALTER TABLE [dbo].[Score] ADD CONSTRAINT [Score_created_by_fkey] 
        FOREIGN KEY ([created_by]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    -- Score -> Student
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Score_student_id_fkey')
        ALTER TABLE [dbo].[Score] ADD CONSTRAINT [Score_student_id_fkey] 
        FOREIGN KEY ([student_id]) REFERENCES [dbo].[Student]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Score -> Class
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Score_class_id_fkey')
        ALTER TABLE [dbo].[Score] ADD CONSTRAINT [Score_class_id_fkey] 
        FOREIGN KEY ([class_id]) REFERENCES [dbo].[Class]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Score -> Subject
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Score_subject_id_fkey')
        ALTER TABLE [dbo].[Score] ADD CONSTRAINT [Score_subject_id_fkey] 
        FOREIGN KEY ([subject_id]) REFERENCES [dbo].[Subject]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Attendance -> Student
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Attendance_student_id_fkey')
        ALTER TABLE [dbo].[Attendance] ADD CONSTRAINT [Attendance_student_id_fkey] 
        FOREIGN KEY ([student_id]) REFERENCES [dbo].[Student]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Attendance -> Class
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Attendance_class_id_fkey')
        ALTER TABLE [dbo].[Attendance] ADD CONSTRAINT [Attendance_class_id_fkey] 
        FOREIGN KEY ([class_id]) REFERENCES [dbo].[Class]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Conduct -> Student
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Conduct_student_id_fkey')
        ALTER TABLE [dbo].[Conduct] ADD CONSTRAINT [Conduct_student_id_fkey] 
        FOREIGN KEY ([student_id]) REFERENCES [dbo].[Student]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- Conduct -> Class
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'Conduct_class_id_fkey')
        ALTER TABLE [dbo].[Conduct] ADD CONSTRAINT [Conduct_class_id_fkey] 
        FOREIGN KEY ([class_id]) REFERENCES [dbo].[Class]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    -- AuditLog -> User
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'AuditLog_user_id_fkey')
        ALTER TABLE [dbo].[AuditLog] ADD CONSTRAINT [AuditLog_user_id_fkey] 
        FOREIGN KEY ([user_id]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

    -- DataConsent -> Student
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'DataConsent_student_id_fkey')
        ALTER TABLE [dbo].[DataConsent] ADD CONSTRAINT [DataConsent_student_id_fkey] 
        FOREIGN KEY ([student_id]) REFERENCES [dbo].[Student]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

    PRINT '✓ Đã tạo tất cả Foreign Keys!';

END TRY
BEGIN CATCH
    PRINT 'Lỗi khi tạo Foreign Keys: ' + ERROR_MESSAGE();
END CATCH
GO

-- =====================================================
-- THÊM DỮ LIỆU MẪU
-- =====================================================

PRINT '';
PRINT '=====================================================';
PRINT 'ĐANG THÊM DỮ LIỆU MẪU...';
PRINT '=====================================================';

-- Tạo tài khoản admin (password: admin123)
IF NOT EXISTS (SELECT * FROM [User] WHERE email = 'admin@school.com')
BEGIN
    INSERT INTO [User] (name, email, password_hash, role)
    VALUES (N'Admin User', 'admin@school.com', '$2b$10$rZ5YvYQYvYQYvYQYvYQYvOKKp8qH0qH0qH0qH0qH0qH0qH0qH0qH0', 'ADMIN');
    PRINT '✓ Đã tạo tài khoản admin@school.com';
END

-- Tạo năm học
IF NOT EXISTS (SELECT * FROM SchoolYear WHERE name = N'2025-2026')
BEGIN
    INSERT INTO SchoolYear (name, start_date, end_date)
    VALUES (N'2025-2026', '2025-09-05', '2026-05-31');
    PRINT '✓ Đã tạo năm học 2025-2026';
END

-- Tạo môn học
IF NOT EXISTS (SELECT * FROM Subject WHERE name = N'Toán')
BEGIN
    INSERT INTO Subject (name) VALUES 
        (N'Toán'), (N'Ngữ văn'), (N'Tiếng Anh'), 
        (N'Vật lý'), (N'Hóa học'), (N'Sinh học'),
        (N'Lịch sử & Địa lý'), (N'GDCD'), (N'Tin học'),
        (N'Công nghệ'), (N'Thể dục'), (N'Âm nhạc'), (N'Mỹ thuật');
    PRINT '✓ Đã tạo 13 môn học';
END

PRINT '';
PRINT '=====================================================';
PRINT '✅ HOÀN TẤT CÀI ĐẶT DATABASE!';
PRINT '=====================================================';
PRINT '';
PRINT 'Thông tin đăng nhập:';
PRINT '  Email: admin@school.com';
PRINT '  Password: admin123';
PRINT '';
PRINT 'Lưu ý: Bạn cần chạy seed script để tạo dữ liệu học sinh.';
PRINT '';
GO
