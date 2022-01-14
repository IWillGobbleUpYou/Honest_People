--Выводим историю операций платёжных с накоплением за последний месяц по всём операциям
--1 - Дата
--2 - сумма
--3 - валюта
--4 - сумма в рублях
--5 - доллары
--6 - биты
--7 - эфир




select Date_of_payment as 'Дата', sum_pay as 'Сумма очередного документа', Cash_Name as 'Валюта документа', Rub as 'RUB', Dol as 'DOL', Bitc as 'BIT', Eth as 'ETH'
from 
(
	select id_Cash, Date_of_payment, sum_pay, coalesce(sum(sum_pay) over (order by Date_of_payment 
			rows between unbounded preceding and current row), 0) as Rub, 0 as Dol, 0 as Bitc, 0 as Eth
	from payment_Doc
	Rub where (id_Cash = 1)
	group by id_Cash, Date_of_payment, sum_pay
	Having sum(id_Cash) = 1 
union

	select id_Cash, Date_of_payment, sum_pay, 0 as Rub, coalesce(sum(sum_pay) over (order by Date_of_payment 
			rows between unbounded preceding and current row), 0) as Dol, 0 as Bitc, 0 as Eth
	from payment_Doc
	Dol where (id_Cash = 2)
	group by id_Cash, Date_of_payment, sum_pay
	Having sum(id_Cash) = 2 
union

	select id_Cash, Date_of_payment, sum_pay, 0 as Rub, 0 as Dol, coalesce(sum(sum_pay) over (order by Date_of_payment 
			rows between unbounded preceding and current row), 0) as Bitc, 0 as Eth
	from payment_Doc
	Bitc where id_Cash = 3
	group by id_Cash, Date_of_payment, sum_pay
	Having sum(id_Cash) = 3 
union

	select id_Cash, Date_of_payment, sum_pay, 0 as Rub, 0 as Dol, 0 as Bitc, coalesce(sum(sum_pay) over (order by Date_of_payment 
			rows between unbounded preceding and current row), 0) as Eth
	from payment_Doc
	Eth where (id_Cash = 4)
	group by id_Cash, Date_of_payment, sum_pay
	Having sum(id_Cash) = 4 
) as Total
join Cash on Total.id_Cash = Cash.id_Cash
order by Date_of_payment