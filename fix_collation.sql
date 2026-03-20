USE school_mgr;
GO

-- Fix collation cho bảng Student
DECLARE @sql NVARCHAR(MAX);

-- Drop constraint Student_code_key
SELECT @sql = 'ALTER TABLE Student DROP CONSTRAINT ' + name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Student') AND name LIKE '%code%';
IF @sql IS NOT NULL EXEC sp_executesql @sql;

ALTER TABLE Student ALTER COLUMN code NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Student ALTER COLUMN full_name NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Student ALTER COLUMN address NVARCHAR(500) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE Student ALTER COLUMN parent_name NVARCHAR(255) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE Student ALTER COLUMN parent_phone NVARCHAR(255) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE Student ALTER COLUMN gender NVARCHAR(255) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE Student ALTER COLUMN status NVARCHAR(255) COLLATE Vietnamese_CI_AS;

-- Tạo lại unique constraint
ALTER TABLE Student ADD CONSTRAINT Student_code_key UNIQUE (code);

PRINT N'✅ Fixed Student table';
GO

-- Fix collation cho bảng User
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = 'ALTER TABLE [User] DROP CONSTRAINT ' + name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('[User]') AND name LIKE '%email%';
IF @sql IS NOT NULL EXEC sp_executesql @sql;

ALTER TABLE [User] ALTER COLUMN name NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE [User] ALTER COLUMN email NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE [User] ALTER COLUMN role NVARCHAR(255) COLLATE Vietnamese_CI_AS;

ALTER TABLE [User] ADD CONSTRAINT User_email_key UNIQUE (email);

PRINT N'✅ Fixed User table';
GO

-- Fix collation cho bảng Class
ALTER TABLE Class ALTER COLUMN name NVARCHAR(255) COLLATE Vietnamese_CI_AS;
PRINT N'✅ Fixed Class table';
GO

-- Fix collation cho bảng Subject
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = 'ALTER TABLE Subject DROP CONSTRAINT ' + name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Subject') AND name LIKE '%name%';
IF @sql IS NOT NULL EXEC sp_executesql @sql;

ALTER TABLE Subject ALTER COLUMN name NVARCHAR(255) COLLATE Vietnamese_CI_AS;

ALTER TABLE Subject ADD CONSTRAINT Subject_name_key UNIQUE (name);

PRINT N'✅ Fixed Subject table';
GO

-- Fix collation cho bảng SchoolYear
ALTER TABLE SchoolYear ALTER COLUMN name NVARCHAR(255) COLLATE Vietnamese_CI_AS;
PRINT N'✅ Fixed SchoolYear table';
GO

-- Fix collation cho bảng Conduct
ALTER TABLE Conduct ALTER COLUMN term NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Conduct ALTER COLUMN type NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Conduct ALTER COLUMN note NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
PRINT N'✅ Fixed Conduct table';
GO

-- Fix collation cho bảng Attendance
ALTER TABLE Attendance ALTER COLUMN status NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Attendance ALTER COLUMN note NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
PRINT N'✅ Fixed Attendance table';
GO

-- Fix collation cho bảng Score
ALTER TABLE Score ALTER COLUMN term NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Score ALTER COLUMN type NVARCHAR(255) COLLATE Vietnamese_CI_AS;
PRINT N'✅ Fixed Score table';
GO

-- Fix collation cho các bảng Legal
DECLARE @sql NVARCHAR(MAX);

SELECT @sql = 'ALTER TABLE LegalRegulation DROP CONSTRAINT ' + name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('LegalRegulation') AND name LIKE '%code%';
IF @sql IS NOT NULL EXEC sp_executesql @sql;

ALTER TABLE LegalRegulation ALTER COLUMN code NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE LegalRegulation ALTER COLUMN name NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE LegalRegulation ALTER COLUMN type NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE LegalRegulation ALTER COLUMN issuing_agency NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE LegalRegulation ALTER COLUMN status NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE LegalRegulation ALTER COLUMN summary NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE LegalRegulation ALTER COLUMN full_text_url NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;

ALTER TABLE LegalRegulation ADD CONSTRAINT LegalRegulation_code_key UNIQUE (code);

PRINT N'✅ Fixed LegalRegulation table';
GO

ALTER TABLE LegalArticle ALTER COLUMN article_number NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE LegalArticle ALTER COLUMN title NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE LegalArticle ALTER COLUMN content NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
PRINT N'✅ Fixed LegalArticle table';
GO

DECLARE @sql NVARCHAR(MAX);

SELECT @sql = 'ALTER TABLE Requirement DROP CONSTRAINT ' + name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Requirement') AND name LIKE '%code%';
IF @sql IS NOT NULL EXEC sp_executesql @sql;

ALTER TABLE Requirement ALTER COLUMN code NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Requirement ALTER COLUMN name NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE Requirement ALTER COLUMN description NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE Requirement ALTER COLUMN category NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Requirement ALTER COLUMN priority NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Requirement ALTER COLUMN status NVARCHAR(255) COLLATE Vietnamese_CI_AS;

ALTER TABLE Requirement ADD CONSTRAINT Requirement_code_key UNIQUE (code);

PRINT N'✅ Fixed Requirement table';
GO

DECLARE @sql NVARCHAR(MAX);

SELECT @sql = 'ALTER TABLE Control DROP CONSTRAINT ' + name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Control') AND name LIKE '%code%';
IF @sql IS NOT NULL EXEC sp_executesql @sql;

ALTER TABLE Control ALTER COLUMN code NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Control ALTER COLUMN name NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE Control ALTER COLUMN description NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE Control ALTER COLUMN control_type NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE Control ALTER COLUMN implementation NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE Control ALTER COLUMN responsible NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE Control ALTER COLUMN frequency NVARCHAR(255) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE Control ALTER COLUMN status NVARCHAR(255) COLLATE Vietnamese_CI_AS;

ALTER TABLE Control ADD CONSTRAINT Control_code_key UNIQUE (code);

PRINT N'✅ Fixed Control table';
GO

ALTER TABLE RequirementSystemMapping ALTER COLUMN system_feature NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE RequirementSystemMapping ALTER COLUMN module_name NVARCHAR(MAX) COLLATE Vietnamese_CI_AS;
ALTER TABLE RequirementSystemMapping ALTER COLUMN implementation_status NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE RequirementSystemMapping ALTER COLUMN implementation_note NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE RequirementSystemMapping ALTER COLUMN test_status NVARCHAR(255) COLLATE Vietnamese_CI_AS;
PRINT N'✅ Fixed RequirementSystemMapping table';
GO

ALTER TABLE AuditLog ALTER COLUMN action NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE AuditLog ALTER COLUMN entity_type NVARCHAR(255) COLLATE Vietnamese_CI_AS;
ALTER TABLE AuditLog ALTER COLUMN old_value NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE AuditLog ALTER COLUMN new_value NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE AuditLog ALTER COLUMN ip_address NVARCHAR(255) COLLATE Vietnamese_CI_AS NULL;
ALTER TABLE AuditLog ALTER COLUMN user_agent NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
PRINT N'✅ Fixed AuditLog table';
GO

ALTER TABLE DataConsent ALTER COLUMN parent_signature NVARCHAR(MAX) COLLATE Vietnamese_CI_AS NULL;
PRINT N'✅ Fixed DataConsent table';
GO

PRINT N'';
PRINT N'🎉 ĐÃ FIX COLLATION CHO TẤT CẢ CÁC BẢNG!';
PRINT N'Tất cả các cột text đã được chuyển sang Vietnamese_CI_AS';
GO
