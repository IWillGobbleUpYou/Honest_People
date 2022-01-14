--������� ������� �������� �������� � ����������� �� ��������� ����� �� ��� ���������
--1 - ����
--2 - �����
--3 - ������
--4 - ����� � ������
--5 - �������
--6 - ����
--7 - ����




select Date_of_payment as '����', sum_pay as '����� ���������� ���������', Cash_Name as '������ ���������', Rub as 'RUB', Dol as 'DOL', Bitc as 'BIT', Eth as 'ETH'
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