USE [Salary_work_shift_shop]
GO

--Отчёт за каждый день, где дни перевёрнуты в столбцы

SELECT Personal_ID
      ,Employees_id
	  ,[Organization]
      ,[Subdivision]
      ,[Position]
	  ,[Full_name]
	  ,[Rate]
      ,[Type_of_employment_ID]
	  ,Total_Salary
	  ,[1]
	  ,[2]
	  ,[3]
	  ,[4]
	  ,[5]
	  ,[6]
	  ,[7]
	  ,[8]
	  ,[9]
	  ,[10]
	  ,[11]
	  ,[12]
	  ,[13]
	  ,[14]
	  ,[15]
	  ,[16]
	  ,[17]
	  ,[18]
	  ,[19]
	  ,[20]
	  ,[21]
	  ,[22]
	  ,[23]
	  ,[24]
	  ,[25]
	  ,[26]
	  ,[27]
	  ,[28]
	  ,[29]
	  ,[30]
	  ,[31]
FROM (SELECT per.[ID] Personal_ID
			  ,emp.[ID] Employees_id
			  ,org.[Name] [Organization]
			  ,subd.[Name] [Subdivision]
			  ,pos.[Name] [Position]
			  ,emp.[Full_name]
			  ,per.[Rate]
			  ,toe.[Name] [Type_of_employment_ID]
			  ,DAY(ws.Date_work) day_work
			  ,ws.Oklad + ISNULL(ws.Oklad_night,0) + ISNULL(ws.Premium,0) Salary_day
			  ,SUM(ws.Oklad + ISNULL(ws.Oklad_night,0) + ISNULL(ws.Premium,0)) OVER  (PARTITION BY emp.[ID])  Total_Salary
		  FROM [HR].[Personal] per
		  INNER JOIN [HR].[Subdivision] subd ON per.Subdivision_id = Subd.ID
		  INNER JOIN [HR].[Position] pos ON per.Position_id = pos.ID
		  INNER JOIN [HR].[Organization] org ON Subd.Organization_id = org.ID
		  INNER JOIN [HR].[Employees] emp ON per.Employees_id = emp.ID
		  INNER JOIN [HR].[Type_of_employment] toe ON per.Type_of_employment_id = toe.ID 
		  INNER JOIN [SWS].[Work_shifts] ws ON ws.Personal_ID = per.ID
		  ) as Salary_personal
		  Pivot
		  (
			SUM(Salary_day) FOR day_work in ([1],	[2],	[3],	[4],	[5],	[6],	[7],	[8],	[9],	[10]
											,[11],	[12],	[13],	[14],	[15],	[16],	[17],	[18],	[19],	[20]
											,[21],	[22],	[23],	[24],	[25],	[26],	[27],	[28],	[29],	[30],	[31])
		  )  AS PivotTable

GO

--Отчёт в разрезе премии за каждый приоритет
SELECT per.[ID] Personal_ID
	  ,emp.[ID] Employees_id
	  ,org.[Name] [Organization]
	  ,subd.[Name] [Subdivision]
	  ,pos.[Name] [Position]
	  ,emp.[Full_name]
	  ,per.[Rate]
	  ,toe.[Name] [Type_of_employment_ID]
	  ,ws.Date_work
	  ,rfw.[Name] Reason_for_working_id 
	  ,subd_ws.[Name] [Subdivision request]
	  ,pos_ws.[Name] [Position request]
	  ,ws.[Hours]
	  ,ws.[Of_them_at_night]
	  ,SUM(ws.Oklad + ISNULL(ws.Oklad_night,0) + ISNULL(ws.Premium,0)) OVER  (PARTITION BY emp.[ID])  Total_Salary
	  ,ws.Oklad 
	  ,ISNULL(ws.Oklad_night,0) Oklad_night 
	  ,pp.[Name]
	  ,pd.Coefficient
	  ,sp.Summ
	  ,sp.Summ*pd.Coefficient Premii
FROM [HR].[Personal] per
INNER JOIN [HR].[Subdivision] subd ON per.Subdivision_id = Subd.ID
INNER JOIN [HR].[Position] pos ON per.Position_id = pos.ID
INNER JOIN [HR].[Organization] org ON Subd.Organization_id = org.ID
INNER JOIN [HR].[Employees] emp ON per.Employees_id = emp.ID
INNER JOIN [HR].[Type_of_employment] toe ON per.Type_of_employment_id = toe.ID 
INNER JOIN [SWS].[Work_shifts] ws ON ws.Personal_ID = per.ID
INNER JOIN [SWS].[Reason_for_working] rfw ON ws.Reason_for_working_id =  rfw.ID 
INNER JOIN [HR].[Subdivision] subd_ws ON ws.Subdivision_id_request = Subd_ws.ID
INNER JOIN [HR].[Position] pos_ws ON ws.Position_id_request = pos_ws.ID
INNER JOIN [RS].[Prize_data] pd ON pd.Position_ID = ws.Position_id_request AND pd.Shop_type_id = subd_ws.Shop_type_id AND pd.Subformat_id = subd_ws.Subformat_id
INNER JOIN [RS].[Prioritet_prize] pp ON pp.ID = pd.Prioritet_id
INNER JOIN [DS].[Sales_personal] sp ON sp.Work_shifts_id = ws.ID AND sp.Prioritet_id = pp.ID 