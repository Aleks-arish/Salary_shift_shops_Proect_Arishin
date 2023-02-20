USE [Salary_work_shift_shop]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Лёша
-- Create date: 10.02.2023
-- Description:	Расчитать премию за смены работы
-- Продажи разбиты на приоритеты, в зависимости от приоритета определяется коэффициент премии
-- За одну смену может быть несколько продаж с разными приоритетами, что бы получить сумму премии, необходимо сложить произведения продаж и коэффициентов приоритетов
-- Что бы не создовать отдельную тоблицу с суммой премии, сделал цикл по строчный по приоритетам через курсор
--В каждой итерации получаем сумму премии за каждый день по всему приоритету, в следующей строке прибавляем сумму премии к уже ранее добавленому значению
-- V23.01
-- =============================================
CREATE PROCEDURE [dbo].[sp_Calculate_premium] 
AS
BEGIN
	SET NOCOUNT ON;

--  Убираем старые премии
  Update [SWS].[Work_shifts]
	SET [Premium] = Null

  Declare @Prioritet nvarchar(50)
  --Курсор делается по справочнику приоритетов
  DECLARE vend_cursor CURSOR  
    FOR SELECT [Prioritet_prize].[ID] Prioritet FROM [RS].[Prioritet_prize]  

  OPEN vend_cursor

  FETCH NEXT FROM vend_cursor INTO @Prioritet; 

  WHILE @@FETCH_STATUS = 0  

  BEGIN
	--Получаем суммму премии по оределённому приоритету
	  Update ws
		SET ws.[Premium] = ISNULL(ws.[Premium],0) + sp.Summ * pd.Coefficient
	  FROM [SWS].[Work_shifts] ws
	  INNER JOIN [HR].[Subdivision] sudb_ws ON ws.[Subdivision_id_request] = sudb_ws.id
	  INNER JOIN [DS].[Sales_personal] sp ON sp.Work_shifts_id = ws.ID
	  INNER JOIN [HR].[Shop_type] st ON sudb_ws.Shop_type_id = st.ID
	  INNER JOIN [HR].[Subformat] sf ON sudb_ws.Subformat_id = sf.ID
	  INNER JOIN [RS].[Prize_data] pd ON pd.Prioritet_id = sp.Prioritet_id AND pd.Position_ID = ws.Position_id_request AND pd.Shop_type_id = st.ID AND pd.Subformat_id = sf.ID
	  Where sp.Prioritet_id = @Prioritet


	  FETCH NEXT FROM vend_cursor INTO @Prioritet
  END

  CLOSE vend_cursor

  DEALLOCATE  vend_cursor


-- Проверяющие запросы
  

----SELECT ws.[ID]
----	  ,emp.Full_name [FIO]
----      ,TOE.[Name] [Type_of_employment]
----	  ,per.Rate
----      ,pos_ws.[Name] [Position_ws]
----      ,RFW.[Name] [Reason_for_working]
----      ,ws.[Date_work]
----      ,ws.[Hours]
----      ,ws.[Of_them_at_night]
----      ,ws.[Oklad]
----	  ,ws.[Oklad_night]
----	  ,sudb_ws.[Name] [Subdivision_ws]
----	  ,st.[Name] [Shop_type]
----	  ,sf.[Name] [Subformat]
----	  ,pp.[Name] [Prioritet_prize]
----	  ,pd.Coefficient
----	  ,sp.Summ
----	  ,sp.Summ*pd.Coefficient [Premium_fact]
----      ,ws.[Premium]
----  FROM [SWS].[Work_shifts] ws
----  INNER JOIN [SWS].[Reason_for_working] RFW ON ws.Reason_for_working_id = RFW.ID
----  INNER JOIN [HR].[Position] pos_ws ON ws.Position_id_request = pos_ws.id
----  INNER JOIN [HR].[Subdivision] sudb_ws ON ws.[Subdivision_id_request] = sudb_ws.id
----  INNER JOIN [HR].[Personal] per ON ws.Personal_ID = per.ID
----  INNER JOIN [HR].[Type_of_employment] TOE ON per.Type_of_employment_ID = TOE.ID
----  INNER JOIN [HR].[Employees] emp ON per.Employees_id = emp.ID
----  INNER JOIN [DS].[Sales_personal] sp ON sp.Work_shifts_id = ws.ID
----  INNER JOIN [RS].[Prioritet_prize] pp ON sp.Prioritet_id = pp.ID
----  INNER JOIN [HR].[Shop_type] st ON sudb_ws.Shop_type_id = st.ID
----  INNER JOIN [HR].[Subformat] sf ON sudb_ws.Subformat_id = sf.ID
----  INNER JOIN [RS].[Prize_data] pd ON pd.Prioritet_id = pp.ID AND pd.Position_ID = ws.Position_id_request AND pd.Shop_type_id = st.ID AND pd.Subformat_id = sf.ID


  

----SELECT ws.[ID]
----	  ,emp.Full_name [FIO]
----      ,TOE.[Name] [Type_of_employment]
----	  ,per.Rate
----      ,pos_ws.[Name] [Position_ws]
----      ,RFW.[Name] [Reason_for_working]
----      ,ws.[Date_work]
----      ,ws.[Hours]
----      ,ws.[Of_them_at_night]
----      ,ws.[Oklad]
----	  ,ws.[Oklad_night]
----	  ,sudb_ws.[Name] [Subdivision_ws]
----	  ,st.[Name] [Shop_type]
----	  ,sf.[Name] [Subformat]
----	  ,Sum(sp.Summ * pd.Coefficient) [Premium_Total]
----      ,ws.[Premium]
----  FROM [SWS].[Work_shifts] ws
----  INNER JOIN [SWS].[Reason_for_working] RFW ON ws.Reason_for_working_id = RFW.ID
----  INNER JOIN [HR].[Position] pos_ws ON ws.Position_id_request = pos_ws.id
----  INNER JOIN [HR].[Subdivision] sudb_ws ON ws.[Subdivision_id_request] = sudb_ws.id
----  INNER JOIN [HR].[Personal] per ON ws.Personal_ID = per.ID
----  INNER JOIN [HR].[Type_of_employment] TOE ON per.Type_of_employment_ID = TOE.ID
----  INNER JOIN [HR].[Employees] emp ON per.Employees_id = emp.ID
----  INNER JOIN [DS].[Sales_personal] sp ON sp.Work_shifts_id = ws.ID
----  INNER JOIN [RS].[Prioritet_prize] pp ON sp.Prioritet_id = pp.ID
----  INNER JOIN [HR].[Shop_type] st ON sudb_ws.Shop_type_id = st.ID
----  INNER JOIN [HR].[Subformat] sf ON sudb_ws.Subformat_id = sf.ID
----  INNER JOIN [RS].[Prize_data] pd ON pd.Prioritet_id = pp.ID AND pd.Position_ID = ws.Position_id_request AND pd.Shop_type_id = st.ID AND pd.Subformat_id = sf.ID
----  Group By ws.[ID]
----	  ,emp.Full_name 
----      ,TOE.[Name] 
----	  ,per.Rate
----      ,pos_ws.[Name] 
----      ,RFW.[Name] 
----      ,ws.[Date_work]
----      ,ws.[Hours]
----      ,ws.[Of_them_at_night]
----      ,ws.[Oklad]
----	  ,ws.[Oklad_night]
----	  ,sudb_ws.[Name] 
----	  ,st.[Name] 
----	  ,sf.[Name] 
----	  ,ws.[Premium]



END
GO


