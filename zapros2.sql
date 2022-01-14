--Статистика за год (на год назад)
--12 строк - месяцы
--2 количество договоров
--3 сумма средств за месяц (В рублях)
--4 ФИО/Название организации (наибольших обращений)
--5 сумма средств внесённых топовым клиентом (не рубли)

select * from
(
	select * from
	(
		select Layer1.monthstat as 'Месяц', Kol_Contracts as 'Количество Договоров', SumPriceRUB as 'Сумма средств за месяц [RUB]',
		Client_Name as 'Топовый клиент', SumPriceTop as 'Сумма средств внесённых топовым клиентом' from 
		(
			select monthstat, Kol_Contracts from
			(
				select monthstat, SUM(Kol_Contracts) as Kol_Contracts from
				(
					select
					case when month(Date_of_registration) >= 10 then concat(year(Date_of_registration),'.',month(Date_of_registration)) 
							else concat(year(Date_of_registration),'.0',month(Date_of_registration)) end as monthstat,
						count(distinct Contracts.number_Contract) as Kol_Contracts
						from Contracts
					left join payment_Doc on Contracts.number_Contract = payment_Doc.number_Contract
					where (payment_Doc.Date_of_payment >= (GETDATE() - datepart(dd,GETDATE()))- 365+1) AND (payment_Doc.Date_of_payment <= GETDATE())
					group by payment_Doc.Date_of_payment, Date_of_registration
				)as Temp1
			group by monthstat
			)as Result1
		) as Layer1
		


		full join 
		(
			select * from (
				select distinct monthprice as monthstat, sum(SumPriceRUB) as SumPriceRUB from
				(
					select case when month(Contracts.Date_of_registration) >= 10 then concat(year(Contracts.Date_of_registration),'.',month(Contracts.Date_of_registration)) 
							else concat(year(Contracts.Date_of_registration),'.0',month(Contracts.Date_of_registration)) end as monthprice,
							sum(Contracts.Price) as SumPriceRUB
					from Contracts
					where (id_cash = 1)
					group by Contracts.Date_of_registration
					) as Prepare2
				group by monthprice
				) as Result2
			)as Layer2
		on Layer1.monthstat = Layer2.monthstat
		full join
		(	
			select * from
			(
		
			select top (12) Client.Client_Name as Client_Name, monthdate from
				(
					select ROW_NUMBER() over (partition by monthdate order by counts desc) as rang, monthdate, id_Client, counts from
					(
						select distinct Client.id_Client as id_Client,
						case when month(Date_of_registration) >= 10 then concat(year(Date_of_registration),'.',month(Date_of_registration)) 
						else concat(year(Date_of_registration),'.0',month(Date_of_registration)) end as  monthdate,
						count(Contracts.number_Contract) as counts 
						from Contracts
						join Client on Contracts.id_Client = Client.id_Client
						group by Client.id_Client, Date_of_registration
					) as Temp
				) as Result 
				join Client on Result.id_Client = Client.id_Client
				where rang = 1
			)as Layer
		) as TopClient 
		on TopClient.monthdate = Layer1.monthstat
		full join 
		(
			select * from (
					select distinct monthtopprice as monthstat, sum(SumPriceTop) as SumPriceTop from
					(
						select case when month(Contracts.Date_of_registration) >= 10 then concat(year(Contracts.Date_of_registration),'.',month(Contracts.Date_of_registration)) 
							else concat(year(Contracts.Date_of_registration),'.0',month(Contracts.Date_of_registration)) end as monthtopprice,
							sum(Contracts.Price) as SumPriceTop
						from Contracts
						group by Contracts.Date_of_registration
					) as Prepare3
					group by monthtopprice
				) as Result3
			)as Layer3
			on Layer1.monthstat = Layer3.monthstat
		)as Total
	) UnpivotTable
go








--	January = SUM(case when month(Date_of_registration) = 1 then 1 else 0 end),
--	February = SUM(case when month(Date_of_registration) = 2 then 1 else 0 end),
--	March = SUM(case when month(Date_of_registration) = 3 then 1 else 0 end),
--	April = SUM(case when month(Date_of_registration) = 4 then 1 else 0 end),
--	May = SUM(case when month(Date_of_registration) = 5 then 1 else 0 end),
--	June = SUM(case when month(Date_of_registration) = 6 then 1 else 0 end),
--	Jule = SUM(case when month(Date_of_registration) = 7 then 1 else 0 end),
--	August = SUM(case when month(Date_of_registration) = 8 then 1 else 0 end),
--	September = SUM(case when month(Date_of_registration) = 9 then 1 else 0 end),
--	October = SUM(case when month(Date_of_registration) = 10 then 1 else 0 end),
--	November = SUM(case when month(Date_of_registration) = 11 then 1 else 0 end),
--	December = SUM(case when month(Date_of_registration) = 12 then 1 else 0 end) 
