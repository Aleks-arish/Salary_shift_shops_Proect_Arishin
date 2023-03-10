USE [Salary_work_shift_shop]
GO
/****** Object:  StoredProcedure [dbo].[sp_Calculate_oklad]    Script Date: 11.02.2023 1:21:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Лёша
-- Create date: 10.02.2023
-- Description:	Расчитать оклада за смены работы
-- Стоимость часа определяется по должности подработки 
-- Стоимость оклада сравнивается с местом где числится сотрдник и в оплату идёт та где оплата больше
-- Умножаем часы на стоимость оклада, учитываем что часы за работу в ночь рассчитываем в отдельном поле
-- Стоимость за работу в ночь умножается на коэффиуиент 1,2
-- V23.01
-- =============================================
ALTER PROCEDURE [dbo].[sp_Calculate_oklad] 
AS
BEGIN
	SET NOCOUNT ON;

    
  Update ws
		SET ws.[Oklad] = Case When ok_ws.Hourly_cost > ok_per.Hourly_cost Then ok_ws.Hourly_cost Else ok_per.Hourly_cost END * (ws.[Hours] - [Of_them_at_night]),
			ws.[Oklad_night] = Case When ok_ws.Hourly_cost > ok_per.Hourly_cost Then ok_ws.Hourly_cost Else ok_per.Hourly_cost END * 1.2 * [Of_them_at_night]
  FROM [SWS].[Work_shifts] ws
  INNER JOIN [SWS].[Reason_for_working] RFW ON ws.Reason_for_working_id = RFW.ID
  INNER JOIN [HR].[Position] pos_ws ON ws.Position_id_request = pos_ws.id
  INNER JOIN [HR].[Subdivision] sudb_ws ON ws.[Subdivision_id_request] = sudb_ws.id
  INNER JOIN [RS].[Oklad] ok_ws ON ok_ws.Position_id = pos_ws.id AND ok_ws.Subdivision_id = sudb_ws.id
  INNER JOIN [HR].[Personal] per ON ws.Personal_ID = per.ID
  INNER JOIN [HR].[Type_of_employment] TOE ON per.Type_of_employment_ID = TOE.ID
  INNER JOIN [HR].[Employees] emp ON per.Employees_id = emp.ID
  INNER JOIN [HR].[Subdivision] sudb_per ON per.Subdivision_id = sudb_per.id
  INNER JOIN [RS].[Oklad] ok_per ON ok_per.Position_id =  pos_ws.id AND ok_per.Subdivision_id = sudb_per.id 

-- Проверяющие запросы
  
----SELECT ws.[ID]
----	  ,emp.Full_name [FIO]
----      ,TOE.[Name] [Type_of_employment]
----	  ,per.Rate
----      ,pos_ws.[Name] [Position_ws]
----      ,sudb_ws.[Name] [Subdivision_ws]
----      ,RFW.[Name] [Reason_for_working]
----      ,ws.[Date_work]
----      ,ws.[Hours]
----      ,ws.[Of_them_at_night]
----	  ,ok_ws.Hourly_cost [Hourly_cost_ws]
----	  ,ok_ws.Hourly_cost * 1.2 [Hourly_cost_night_ws]
----	  ,sudb_per.[Name] [Subdivision_per]
----	  ,ok_per.Hourly_cost [Hourly_cost_per]
----	  ,ok_per.Hourly_cost * 1.2 [Hourly_cost_night_per]
----      ,ws.[Oklad]
----	  ,ws.[Oklad_night]
----      ,ws.[Premium]
----  FROM [SWS].[Work_shifts] ws
----  INNER JOIN [SWS].[Reason_for_working] RFW ON ws.Reason_for_working_id = RFW.ID
----  INNER JOIN [HR].[Position] pos_ws ON ws.Position_id_request = pos_ws.id
----  INNER JOIN [HR].[Subdivision] sudb_ws ON ws.[Subdivision_id_request] = sudb_ws.id
----  INNER JOIN [RS].[Oklad] ok_ws ON ok_ws.Position_id = pos_ws.id AND ok_ws.Subdivision_id = sudb_ws.id
----  INNER JOIN [HR].[Personal] per ON ws.Personal_ID = per.ID
----  INNER JOIN [HR].[Type_of_employment] TOE ON per.Type_of_employment_ID = TOE.ID
----  INNER JOIN [HR].[Employees] emp ON per.Employees_id = emp.ID
----  INNER JOIN [HR].[Subdivision] sudb_per ON per.Subdivision_id = sudb_per.id
----  INNER JOIN [RS].[Oklad] ok_per ON ok_per.Position_id =  pos_ws.id AND ok_per.Subdivision_id = sudb_per.id

----    Select pos.[Name] [Position]
----		,sudb.[Name] [Subdivision]
----		,ok.Hourly_cost FROM [RS].[Oklad] ok
----  INNER JOIN [HR].[Position] pos ON ok.Position_id = pos.id
----  INNER JOIN [HR].[Subdivision] sudb ON ok.Subdivision_id = sudb.id


END
