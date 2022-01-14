--��� ���� ��������� ����� � ���� ��������� ����������� (�����������)
--���������� ���� ����

--�������� ������
--��� ����������
--������� ����� ��������� � �������� ������� ����������
--��������� ��������� ���� ����� (� ������)
--���������� �������� ������� ������ ��������� � ���� ���������� ������� �����
--������� ��������� ��������, �� ��� ������� ������� ����������

with slct as
(
	select 
		Contracts.id_Agent as Contractsid_Agent, 
		Agent.SurName +' '+ Agent.First_Name +' '+ Agent.Middle_Name as FIO, 
		count(Zakaz_Naryad.id_Uslugi) as countUs,
		sum(Contracts.Price) as Cash, 
		count(distinct Zakaz_Naryad.id_Client) as countCl
	from Agent
		left join Zakaz_Naryad on Zakaz_Naryad.id_Agent = Agent.id_Agent
		join Contracts on Contracts.Number_ZN = Zakaz_Naryad.Number_ZN
	group by Contracts.id_Agent, Agent.SurName +' '+ Agent.First_Name +' '+ Agent.Middle_Name 
),
slct1 as
(
	select 
		slct.Contractsid_Agent, 
		slct.FIO, 
		slct.countUs,
		slct.Cash, 
		slct.countCl, 
		--Contracts.id_Agent, 
		AVG(Contracts.Price) as SrCash
	from Contracts
		inner join slct on Contracts.id_Agent = slct.Contractsid_Agent
	group by 
		slct.Contractsid_Agent, 
		slct.FIO, 
		slct.countUs,
		slct.Cash, 
		slct.countCl, 
		Contracts.id_Agent
)
select * from slct1

/*
select id_Agent, FIO as '���', sum(countUs) as '���������� �����', sum(Cash) as '��������� ��������� ����� RUB',
sum(countCl) as '���������� ���������� �������� � ���������� �������', Null as SrCash

from
(
	select Contracts.id_Agent, Agent.SurName+' '+Agent.First_Name+' '+Agent.Middle_Name as FIO, count(Zakaz_Naryad.id_Uslugi) as countUs,
	sum(Contracts.Price) as Cash, count(distinct Zakaz_Naryad.id_Client) as countCl, null as SrCash
	from Agent
	
	left join Zakaz_Naryad on Zakaz_Naryad.id_Agent = Agent.id_Agent
	join Contracts on Contracts.Number_ZN = Zakaz_Naryad.Number_ZN--,
	--Cash where Contracts.id_Cash = 1
	group by Contracts.id_Agent, Agent.SurName +' '+Agent.First_Name+' '+Agent.Middle_Name 
)as Result1	
group by id_Agent, FIO
Union

--� �������� ���������� ���������� ���������� ���� ���� ������ (�������� �����������). ���������� ����� ��������

select id_Agent, Null as FIO, Null as countUs, Null as Cash, Null as countCl, sum(SrCash)	 as '������� ��������� ��������'
from
(
	select Contracts.id_Agent, AVG(Contracts.Price) as  SrCash, Null as FIO, Null as countUs, Null as Cash, Null as countCl
	from Contracts
	group by Contracts.id_Agent
) as Temp
group by id_Agent, FIO
*/