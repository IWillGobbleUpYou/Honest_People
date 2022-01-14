--������� ���-5 ����������� ���������� � �������� ��������
--1 ���
--2 ���������� ��������, ������� �� ����� (�� ���������)
--3 ���������� �����
--4 ����� ���������� ��������
--5 ���� (������������ ������) 

select TOP 5 Result1.id_Agent, FIO as '���', countCl as '���������� ���������� ��������', countUs as '���������� �����', Cash_Agent as '����� ���������� ��������', (Cash_Agent - Dolg) as '������������ ������'

from
(
	select Contracts.id_Agent, Agent.SurName+' '+Agent.First_Name+' '+Agent.Middle_Name as FIO, count(distinct Zakaz_Naryad.id_Client) as countCl, count(Zakaz_Naryad.id_Uslugi) as countUs, sum(Contracts.Price) as Cash_Agent
	from Agent
	left join Zakaz_Naryad on Zakaz_Naryad.id_Agent = Agent.id_Agent
	join Contracts on Contracts.Number_ZN = Zakaz_Naryad.Number_ZN
	group by Contracts.id_Agent, Agent.SurName +' '+Agent.First_Name+' '+Agent.Middle_Name 
)as Result1
full join ( 
	select Contracts.id_Agent, sum(payment_Doc.sum_pay) as  Dolg
	from payment_Doc
	left join Contracts on payment_Doc.number_Contract =  Contracts.number_Contract
	group by Contracts.id_Agent
) as Temp
on Result1.id_Agent = Temp.id_Agent
order by countUs desc
