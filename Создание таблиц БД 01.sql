Use Salary_work_shift_shop_arhiv

CREATE TABLE [HR].[Position]
(

	[ID] INT ,
	[Name] nvarchar(100) NULL,
	[Type] nvarchar(50) NULL,
	CONSTRAINT pk_ndx_position_ID PRIMARY KEY NONCLUSTERED (ID)
);


GO

CREATE TABLE [HR].[Type_of_employment]
(

	[ID] INT ,
	[Name] nvarchar(50) NULL,
	CONSTRAINT pk_ndx_type_of_employment_ID PRIMARY KEY NONCLUSTERED (ID)
);


GO

CREATE TABLE [HR].[Subformat]
(

	[ID] INT ,
	[Name] nvarchar(100) NULL,
	CONSTRAINT pk_ndx_Subformat_ID PRIMARY KEY NONCLUSTERED (ID)
);

GO

CREATE TABLE [HR].[Shop_type]
(

	[ID] INT ,
	[Name] nvarchar(100) NULL,
	CONSTRAINT pk_ndx_shop_type_ID PRIMARY KEY NONCLUSTERED (ID)
);


GO

CREATE TABLE [HR].[Organization]
(

	[ID] INT ,
	[Name] nvarchar(50) NULL,
	CONSTRAINT pk_ndx_organization_ID PRIMARY KEY NONCLUSTERED (ID)
);

GO

CREATE TABLE [HR].[Subdivision]
(

	[ID] INT ,
	[Name] nvarchar(100) NULL,
	[Shop_type_id] INT NULL,
	[Subformat_id] INT NULL,
	[Organization_id] INT NULL,
	CONSTRAINT pk_ndx_subdivision_id PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_subdivision_shop_type_id FOREIGN KEY ([Shop_type_id]) REFERENCES [HR].[Shop_type](id),
	CONSTRAINT fk_subdivision_organization_id FOREIGN KEY ([Organization_id]) REFERENCES [HR].[Organization](id),
	CONSTRAINT fk_subdivision_subformat_id FOREIGN KEY ([Subformat_id]) REFERENCES [HR].[Subformat](id)
);


Go



CREATE TABLE [HR].[Employees]
(

	[ID] INT ,
	[Full_name] nvarchar(50) NULL,
	[Age] int NULL,
	CONSTRAINT pk_ndx_employees_ID PRIMARY KEY NONCLUSTERED (ID)
);

GO

CREATE TABLE [HR].[Personal]
(

	[ID] INT ,
	[Rate] nvarchar(50) NULL,
	[Type_of_employment_id] int NULL,
	[Subdivision_id] int NULL,
	[Position_id] int NULL,
	[Employees_id] int NULL,
	CONSTRAINT pk_ndx_personal_ID PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_personal_subdivision_id FOREIGN KEY ([Subdivision_id]) REFERENCES [HR].[Subdivision](id),
	CONSTRAINT fk_personal_position_id FOREIGN KEY ([Position_ID]) REFERENCES [HR].[Position](id),
	CONSTRAINT fk_personal_employees_id FOREIGN KEY ([Employees_id]) REFERENCES [HR].[Employees](ID)
);


GO

CREATE TABLE [RS].[Oklad]
(

	[ID] INT ,
	[Hourly_cost] numeric(18,4) NULL,
	[Subdivision_id] INT NULL,
	[Position_id] INT NULL,
	CONSTRAINT pk_ndx_oklad_ID PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_oklad_subdivision_id FOREIGN KEY ([Subdivision_id]) REFERENCES [HR].[Subdivision](id), 
	CONSTRAINT fk_oklad_position_id FOREIGN KEY ([Position_id]) REFERENCES [HR].[Position](id)
);


GO

CREATE TABLE [RS].[Prioritet_prize]
(

	[ID] INT Not NULL,
	[Name] nvarchar(50) NULL,
	CONSTRAINT pk_ndx_prioritet_prize_ID PRIMARY KEY NONCLUSTERED (ID)
);

GO

CREATE TABLE [RS].[Prize_data]
(

	[ID] INT ,
	[Coefficient] numeric(18,4) NULL,
	[Shop_type_id] INT NULL,
	[Subformat_id] INT NULL,
	[Prioritet_id] INT NULL,
	[Position_ID] INT NULL,
	CONSTRAINT pk_ndx_prize_data_id PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_prize_data_shop_type_id FOREIGN KEY ([Shop_type_id]) REFERENCES [HR].[Shop_type](id),
	CONSTRAINT fk_prize_data_subformat_id FOREIGN KEY ([Subformat_id]) REFERENCES [HR].[Subformat](id),
	CONSTRAINT fk_prize_data_prioritet_prize_id FOREIGN KEY ([Prioritet_id]) REFERENCES [RS].[Prioritet_prize](ID),
	CONSTRAINT fk_prize_data_position_id FOREIGN KEY ([Position_ID]) REFERENCES [HR].[Position](id)
);


GO


CREATE TABLE [AWH].[Absences]
(

	[ID] INT ,
	[Name] nvarchar(5) NULL,
	[Is_work_shifts] tinyint NULL,
	[Description] nvarchar(500) NULL,
	CONSTRAINT pk_ndx_Absences_ID PRIMARY KEY NONCLUSTERED (ID)
);

GO

CREATE TABLE [AWH].[Working_time]
(

	[ID] INT ,
	[date_work] nvarchar(5) NULL,
	[Hours] numeric(4,2) NULL,
	[Of_them_at_night] numeric(4,2) NULL,
	[Absences_id] INT NULL,
	[Personal_id] INT NULL,
	CONSTRAINT pk_ndx_working_time_ID PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_working_time_absences_id_id FOREIGN KEY ([Absences_id]) REFERENCES [AWH].[Absences](ID),
	CONSTRAINT fk_working_time_personal_id FOREIGN KEY ([Personal_id]) REFERENCES [HR].[Personal](ID)
);




GO

CREATE TABLE [AWH].[Data_absences]
(

	[ID] INT ,
	[date_absences] nvarchar(5) NULL,
	[Total_hours] tinyint NULL,
	[Of_them_at_night] nvarchar(500) NULL,
	[Absences_id] INT NULL,
	[Personal_id] INT NULL,
	CONSTRAINT pk_ndx_data_absences_ID PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_data_absences_absences_id FOREIGN KEY ([Absences_id]) REFERENCES [AWH].[Absences](ID),
	CONSTRAINT fk_data_absences_personal_id FOREIGN KEY ([Personal_id]) REFERENCES [HR].[Personal](ID)
);


GO

CREATE TABLE [SWS].[Reason_for_working]
(

	[ID] INT ,
	[Name] nvarchar(150) NULL,
	[Shop_salary] tinyint NULL,
	CONSTRAINT pk_ndx_data_absences_ID PRIMARY KEY NONCLUSTERED (ID)
);

GO

CREATE TABLE [SWS].[Work_shifts]
(

	[ID] INT ,
	[Personal_ID] INT NULL,
	[Position_id_request] INT NULL,
	[Subdivision_id_request] INT NULL,
	[Reason_for_working_id] INT NULL,
	[Date_work] date NULL,
	[Hours] numeric(4,2) NULL,
	[Of_them_at_night] numeric(4,2) NULL,
	[Oklad] numeric(18,4) NULL,
	[Premium] numeric(29,4) NULL,
	[Oklad_night] numeric(18,4) NULL,
	CONSTRAINT pk_ndx_Work_shifts_id PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_work_shifts_personal_id FOREIGN KEY ([Personal_ID]) REFERENCES [HR].[Personal](ID),
	CONSTRAINT fk_work_shifts_Position_id FOREIGN KEY ([Position_id_request]) REFERENCES [HR].[Position](ID),
	CONSTRAINT fk_work_shifts_subdivision_id FOREIGN KEY ([Subdivision_id_request]) REFERENCES [HR].[Subdivision] (ID),
	CONSTRAINT fk_work_shifts_reason_for_working_id FOREIGN KEY ([Reason_for_working_id])  REFERENCES [SWS].[Reason_for_working](ID)
);


GO

CREATE TABLE [DS].[Sales_personal]
(

	[Personal_id] INT,
	[Prioritet_id] INT NULL,
	[ID] INT NOT NULL,
	[Summ] [numeric](29, 9) NULL,
	[Date_sales] date NULL,
	[Working_time_ID] INT NULL,
	[Work_shifts_id] INT NULL,
	CONSTRAINT pk_ndx_sales_personal_id PRIMARY KEY NONCLUSTERED (ID),
	CONSTRAINT fk_sales_personal_personal_id FOREIGN KEY ([Personal_id]) REFERENCES [HR].[Personal](id),
	CONSTRAINT fk_sales_personal_prioritet_prize_id FOREIGN KEY ([Prioritet_id]) REFERENCES [RS].[Prioritet_prize](ID),
	CONSTRAINT fk_sales_personal_working_time_ID FOREIGN KEY (Working_time_ID) REFERENCES [AWH].[Working_time](ID),
	CONSTRAINT fk_sales_personal_work_shifts_id FOREIGN KEY (Work_shifts_id) REFERENCES [SWS].[Work_shifts] (ID)
);


GO

--CONSTRAINT fk_work_shifts__id FOREIGN KEY ()  REFERENCES  (ID)

