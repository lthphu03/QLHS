USE school_mgr;
GO

-- ============================================
-- TẦNG PHÁP LÝ (Legal Compliance Layer)
-- ============================================

PRINT N'📋 Tạo các bảng tầng pháp lý...';
GO

-- Bảng Quy định pháp luật
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LegalRegulation')
BEGIN
    CREATE TABLE LegalRegulation (
        id INT IDENTITY(1,1) PRIMARY KEY,
        code NVARCHAR(255) NOT NULL UNIQUE,
        name NVARCHAR(MAX) NOT NULL,
        type NVARCHAR(255) NOT NULL,
        issuing_agency NVARCHAR(MAX) NOT NULL,
        issue_date DATE NOT NULL,
        effective_date DATE NOT NULL,
        status NVARCHAR(255) NOT NULL DEFAULT 'ACTIVE',
        summary NVARCHAR(MAX) NULL,
        full_text_url NVARCHAR(MAX) NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    PRINT N'✅ Đã tạo bảng LegalRegulation';
END
ELSE
    PRINT N'⚠️ Bảng LegalRegulation đã tồn tại';
GO

-- Bảng Điều khoản pháp lý
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'LegalArticle')
BEGIN
    CREATE TABLE LegalArticle (
        id INT IDENTITY(1,1) PRIMARY KEY,
        regulation_id INT NOT NULL,
        article_number NVARCHAR(255) NOT NULL,
        title NVARCHAR(MAX) NULL,
        content NVARCHAR(MAX) NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_LegalArticle_Regulation FOREIGN KEY (regulation_id) 
            REFERENCES LegalRegulation(id) ON DELETE CASCADE
    );
    CREATE INDEX idx_LegalArticle_regulation ON LegalArticle(regulation_id);
    PRINT N'✅ Đã tạo bảng LegalArticle';
END
ELSE
    PRINT N'⚠️ Bảng LegalArticle đã tồn tại';
GO

-- Bảng Yêu cầu nghiệp vụ
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Requirement')
BEGIN
    CREATE TABLE Requirement (
        id INT IDENTITY(1,1) PRIMARY KEY,
        code NVARCHAR(255) NOT NULL UNIQUE,
        name NVARCHAR(MAX) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        category NVARCHAR(255) NOT NULL,
        priority NVARCHAR(255) NOT NULL DEFAULT 'MEDIUM',
        regulation_id INT NULL,
        article_id INT NULL,
        status NVARCHAR(255) NOT NULL DEFAULT 'ACTIVE',
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Requirement_Regulation FOREIGN KEY (regulation_id) 
            REFERENCES LegalRegulation(id) ON DELETE NO ACTION ON UPDATE NO ACTION,
        CONSTRAINT FK_Requirement_Article FOREIGN KEY (article_id) 
            REFERENCES LegalArticle(id) ON DELETE NO ACTION ON UPDATE NO ACTION
    );
    CREATE INDEX idx_Requirement_regulation ON Requirement(regulation_id);
    CREATE INDEX idx_Requirement_article ON Requirement(article_id);
    CREATE INDEX idx_Requirement_category ON Requirement(category);
    PRINT N'✅ Đã tạo bảng Requirement';
END
ELSE
    PRINT N'⚠️ Bảng Requirement đã tồn tại';
GO

-- Bảng Biện pháp kiểm soát
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Control')
BEGIN
    CREATE TABLE Control (
        id INT IDENTITY(1,1) PRIMARY KEY,
        code NVARCHAR(255) NOT NULL UNIQUE,
        name NVARCHAR(MAX) NOT NULL,
        description NVARCHAR(MAX) NOT NULL,
        control_type NVARCHAR(255) NOT NULL,
        implementation NVARCHAR(MAX) NOT NULL,
        responsible NVARCHAR(MAX) NULL,
        frequency NVARCHAR(255) NULL,
        status NVARCHAR(255) NOT NULL DEFAULT 'ACTIVE',
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE()
    );
    CREATE INDEX idx_Control_type ON Control(control_type);
    PRINT N'✅ Đã tạo bảng Control';
END
ELSE
    PRINT N'⚠️ Bảng Control đã tồn tại';
GO

-- Bảng Mapping: Luật → Yêu cầu → Chức năng hệ thống
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RequirementSystemMapping')
BEGIN
    CREATE TABLE RequirementSystemMapping (
        id INT IDENTITY(1,1) PRIMARY KEY,
        requirement_id INT NOT NULL,
        control_id INT NULL,
        system_feature NVARCHAR(MAX) NOT NULL,
        module_name NVARCHAR(500) NOT NULL,
        implementation_status NVARCHAR(255) NOT NULL DEFAULT 'PENDING',
        implementation_note NVARCHAR(MAX) NULL,
        test_status NVARCHAR(255) NOT NULL DEFAULT 'NOT_TESTED',
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Mapping_Requirement FOREIGN KEY (requirement_id) 
            REFERENCES Requirement(id) ON DELETE CASCADE,
        CONSTRAINT FK_Mapping_Control FOREIGN KEY (control_id) 
            REFERENCES Control(id) ON DELETE SET NULL
    );
    CREATE INDEX idx_Mapping_requirement ON RequirementSystemMapping(requirement_id);
    CREATE INDEX idx_Mapping_control ON RequirementSystemMapping(control_id);
    CREATE INDEX idx_Mapping_module ON RequirementSystemMapping(module_name);
    PRINT N'✅ Đã tạo bảng RequirementSystemMapping';
END
ELSE
    PRINT N'⚠️ Bảng RequirementSystemMapping đã tồn tại';
GO

PRINT N'';
PRINT N'🎉 HOÀN TẤT TẠO CÁC BẢNG TẦNG PHÁP LÝ!';
PRINT N'';
PRINT N'📊 Các bảng đã tạo:';
PRINT N'   1. LegalRegulation - Văn bản pháp luật';
PRINT N'   2. LegalArticle - Điều khoản pháp lý';
PRINT N'   3. Requirement - Yêu cầu nghiệp vụ';
PRINT N'   4. Control - Biện pháp kiểm soát';
PRINT N'   5. RequirementSystemMapping - Mapping luật → chức năng';
PRINT N'';
PRINT N'💡 Tiếp theo: Chạy file seed để thêm dữ liệu mẫu';
PRINT N'   node server/prisma/seed_legal.js';
GO
