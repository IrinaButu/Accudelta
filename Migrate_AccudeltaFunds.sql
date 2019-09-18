
/****************************************************************************************************************
 * Migrate Schema
 ****************************************************************************************************************/
PRINT '****************************************************************************************************************'
PRINT '* Migrate Schema'
PRINT '****************************************************************************************************************'
PRINT ''



/****************************************************************************************************************
 * Create Foreign Key Constraints
 ****************************************************************************************************************/
PRINT '****************************************************************************************************************'
PRINT '* Create Foreign Key Constraints'
PRINT '****************************************************************************************************************'
PRINT ''


/****************************************************************************************************************
 * Create User Defined Functions/Stored Procedures
 ****************************************************************************************************************/
PRINT '****************************************************************************************************************'
PRINT '* Create User Defined Functions/Stored Procedures'
PRINT '****************************************************************************************************************'
PRINT ''
 
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SP_FillFundsTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_FillFundsTable]
GO 
-- =============================================
-- Author:	Irina
-- Create date: 17 September 2019
-- Description:	fill Funds table records
-- =============================================
CREATE PROCEDURE [dbo].[SP_FillFundsTable]
	@RecordsNumber INT = NULL
AS
BEGIN
    CREATE TABLE #Funds(
	[FundId] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	 CONSTRAINT [PK_Funds] PRIMARY KEY CLUSTERED 
	(
		[FundId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	IF ISNULL(@RecordsNumber, 0) = 0
		SET @RecordsNumber = 1000000
		 
	DECLARE @i int = 1
	WHILE @i < @RecordsNumber
	BEGIN

		INSERT INTO #Funds
			   ([FundId]
			   ,[Name]
			   ,[Description])
		 VALUES
			   (@i
			   ,' Name of Fund ' + convert(varchar,@i)
			   ,' Desc of Fund ' + convert(varchar,@i))

		SET @i = @i + 1

	END

    -- Selecting the records from temproary table. This is just to know the records inserted or not.
    -- SELECT * FROM #Customers;
     
    -- By using MERGE statement, inserting the record if not present and updating if exist.
    MERGE Funds AS TargetTable                            -- Inserting or Updating the table.
    USING #Funds AS SourceTable                           -- Records from the temproary table (records from csv file).
    ON (TargetTable.[FundId] = SourceTable.[FundId])      -- Defining condition to decide which records are alredy present
    WHEN NOT MATCHED BY TARGET                                -- If the records in the Customer table is not matched?
        THEN INSERT ([FundId],[Name],[Description])
		     VALUES(SourceTable.[FundId], SourceTable.[Name], SourceTable.[Description])
    WHEN MATCHED                                              -- If not matched then UPDATE
        THEN UPDATE SET
            TargetTable.[FundId] = SourceTable.[FundId],
            TargetTable.[Name] = SourceTable.[Name],
            TargetTable.[Description] = SourceTable.[Description];
           
	  
    return 1;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SP_FillValuesTable]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_FillValuesTable]
GO 
-- =============================================
-- Author:	Irina
-- Create date: 17 September 2019
-- Description:	fill Values table records
-- =============================================
CREATE PROCEDURE [dbo].[SP_FillValuesTable]
	@RecordsNumber INT = NULL
AS
BEGIN
    CREATE TABLE #Values(
	[ValueId] [int] NOT NULL,
	[Date] [datetime2](7) NULL,
	[Val] [int] NOT NULL,
	[FundId] [int] NOT NULL,
	 CONSTRAINT [PK_ValuesTemp] PRIMARY KEY CLUSTERED 
	(
		[ValueId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	IF ISNULL(@RecordsNumber, 0) = 0
		SET @RecordsNumber = 1000000

	DECLARE @i INT = 1
	WHILE @i < @RecordsNumber
	BEGIN

		INSERT INTO #Values
			   ([ValueId]
			   ,[Date]
			   ,[Val]
			   ,[FundId])
		 VALUES
			   (@i
			   ,DATEADD(day,@i,getdate())
			   ,@i
			   ,@i)

		SET @i = @i + 1

	END

    -- Selecting the records from temproary table. This is just to know the records inserted or not.
    -- SELECT * FROM #Customers;
     
    -- By using MERGE statement, inserting the record if not present and updating if exist.
    MERGE [Values] AS TargetTable                            -- Inserting or Updating the table.
    USING #Values AS SourceTable                           -- Records from the temproary table (records from csv file).
    ON (TargetTable.ValueId = SourceTable.ValueId)      -- Defining condition to decide which records are alredy present
    WHEN NOT MATCHED BY TARGET                                -- If the records in the Customer table is not matched?
        THEN INSERT ([ValueId],[Date],[Val],[FundId])
		     VALUES(SourceTable.[ValueId], SourceTable.[Date], SourceTable.[Val], SourceTable.[FundId])
    WHEN MATCHED                                              -- If not matched then UPDATE
        THEN UPDATE SET
            TargetTable.[ValueId] = SourceTable.[ValueId],
            TargetTable.[Date] = SourceTable.[Date],
            TargetTable.[Val] = SourceTable.[Val],
            TargetTable.[FundId] = SourceTable.[FundId];
         
	DROP TABLE #Values;    

    return 1;
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SP_FillDbFromFile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[SP_FillDbFromFile]
GO 

-- ===============================================
-- Author:	Irina
-- Create date: 17 September 2019
-- Description:	fill Funds table records from file
-- ===============================================
CREATE PROCEDURE [dbo].[SP_FillDbFromFile]
	@FilePath AS NVARCHAR(MAX)
AS
BEGIN
    CREATE TABLE #Funds(
	fund_id [int] NOT NULL,
	fund_name [nvarchar](max) NULL,
	fund_description [nvarchar](max) NULL,
	value_date [datetime] NULL,
	value_value [int]  NOT NULL
	 CONSTRAINT [PK_Funds] PRIMARY KEY CLUSTERED 
	(
		fund_id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	-- Inserting all the from csv to temproary table using BULK INSERT
	DECLARE @sql as NVARCHAR(MAX)
	SET @sql = 'BULK INSERT #Funds
				FROM ''' + @FilePath + '''
				WITH ( FIELDTERMINATOR = '','', ROWTERMINATOR = ''\n'' );'

	-- Execute the SQL query
	EXEC sp_executesql @sql

    -- Selecting the records from temproary table. This is just to know the records inserted or not.
    --SELECT * FROM #Funds;
     
	
    -- By using MERGE statement, inserting the record if not present and updating if exist.
    MERGE Funds AS TargetTable                            -- Inserting or Updating the table.
    USING #Funds AS SourceTable                           -- Records from the temproary table (records from csv file).
    ON (TargetTable.[FundId] = SourceTable.fund_id)      -- Defining condition to decide which records are alredy present
    WHEN NOT MATCHED BY TARGET                                -- If the records in the Customer table is not matched?
        THEN INSERT ([FundId],[Name],[Description])
				VALUES(SourceTable.fund_id, SourceTable.fund_name, SourceTable.fund_description)
    WHEN MATCHED                                              -- If not matched then UPDATE
        THEN UPDATE SET
            TargetTable.[FundId] = SourceTable.fund_id,
            TargetTable.[Name] = SourceTable.fund_name,
            TargetTable.[Description] = SourceTable.fund_description;
     
	 drop table #Funds;
	         
    --SELECT * FROM Funds;
	return 1
END

/****************************************************************************************************************
 * Create Triggers
 ****************************************************************************************************************/
PRINT '****************************************************************************************************************'
PRINT '* Create Triggers'
PRINT '****************************************************************************************************************'
PRINT ''


/****************************************************************************************************************
 * Migrate data
 ****************************************************************************************************************/
PRINT '****************************************************************************************************************'
PRINT '* Migrate data'
PRINT '****************************************************************************************************************'
PRINT ''

