--4 ������ - �������� �� �������
--3 ������
--1 ������ � ������� ���� ����� ���������� ���������
--2 ������ ������� ���� ��������� ������������
--3 ���� ����� ������� ���� ��������� ������ �������

SELECT  * from
(
	SELECT  * from
	(
		select * from
		(
			select QuarterYear,
			sum(Cash) as '������� ������',
			count(Uslugi) as '������� ������',
			count(Bank) as '������� ����'
			from 
			(
				select counts, QuarterYear, Cash, ROW_NUMBER() over (partition by QuarterYear order by counts desc) as rang, 0 as Uslugi, 0 as Bank
				from
				(
					select id_Cash as Cash, datepart(QUARTER, Date_of_payment) as QuarterYear,
					count(payment_Doc.number_Receipt) as counts
					from payment_Doc
					group by datepart(QUARTER, Date_of_payment), id_Cash
				)as Temp 
				group by counts, QuarterYear, Cash  
			union
				select counts, QuarterYear, Null as Cash, Uslugi, ROW_NUMBER() over (partition by QuarterYear order by counts desc) as rang, 0 as Bank
				from
				(
					select id_Uslugi as Uslugi, datepart(QUARTER, Date_obr) as QuarterYear,
					count(Zakaz_Naryad.Number_ZN) as counts
					from Zakaz_Naryad
					group by datepart(QUARTER, Date_obr), id_Uslugi
				)as Temp2
				group by counts, QuarterYear, Uslugi 
			union
				select counts, QuarterYear, Null as Cash, Null as Uslugi, Bank,ROW_NUMBER() over (partition by QuarterYear order by counts desc) as rang
				from
				(
					select id_Bank as Bank, datepart(QUARTER, Date_of_payment) as QuarterYear, 0 as rang,
					count(payment_Doc.number_Receipt) as counts
					from payment_Doc
					group by datepart(QUARTER, Date_of_payment), id_Bank
				)as Temp3
				group by counts, QuarterYear, Bank
			)as Result where rang = 1
			group by counts, QuarterYear, Bank
		)as Total
		where "������� ������" is not null
	)as Res
	unpivot (a for [����������] in ([������� ������], [������� ������], [������� ����])) as unpvt
) as unpivotTABLE
pivot
(
	max(a)
	for QuarterYear in ([1],[2],[3],[4])
) pvt 

