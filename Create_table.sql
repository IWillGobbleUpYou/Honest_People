use master
drop database if exists honest_people;
create database honest_people
Go
use honest_people
														--������
create table Client(
id_Client int primary key identity(1,1),				--ID �������
Client_Name varchar(100) not null,						--������������
SurName varchar(50) not null,							--�������
First_Name varchar(50) not null,						--���
Middle_Name varchar(50) not null,						--��������
City varchar(100) not null,								--�����
Street varchar(100) not null,							--�����
House int not null,										--���
Corpus int null,										--������
Building int null,										--��������
Number_License varchar(20) null,						--����� ��������
Bank_Details int null,									--���������� ���������
TIN varchar(12) null,									--���	 
Certificate_From_A_Narcologist bit,						--������� �� ���������
Certificate_From_A_Psychologist bit,					--������� �� ���������
Medical_Certificate bit,								--��� �������
Certificate_From_A_Autoschool bit,						--���������� �� ���������
Wallet_Number int,										--����� ��������
Number varchar(11) not null unique						--������� 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),								
Email varchar(100) null									--����������� �����

foreign key(id_Client) references Client(id_Client)
);

--EXEC sp_rename 'Individual.Last_Name', 'SurName', 'COLUMN';
														--���. ����
create table Individual(
id_Client int primary key,								--ID �������
Passport varchar(10) not null unique,					--�������
SurName varchar(50) not null,							--�������
First_Name varchar(50) not null,						--���
Middle_Name varchar(50) not null,						--��������
City varchar(100) not null,								--�����
Street varchar(100) not null,							--�����
House int not null,										--���
Corpus int null,										--������
Building int null,										--��������
Number varchar(11) not null								--������� 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),								
Email varchar(100) null									--����������� �����

foreign key (id_Client) references Client(id_Client)
);
														--��. ���� (�����������)
create table Entity(
id_Client int primary key,								--ID �������
Type_of_entity varchar(6) not null						--���
	check(Type_of_entity in ('��', '���', '���', '����','����','���','���')),
Name_Entity varchar(100) not null,						--��������
TIN varchar(10) not null unique,						--���	 
RRC varchar(9) not null,								--���
Number_license varchar(20) not null,					--����� ��������
City varchar(100) not null,								--�����
Street varchar(100) not null,							--�����
House int not null,										--���
Corpus int null,										--������
Building int null,										--��������
Number varchar(11) not null								--������� 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
Email varchar(100) null									--����������� �����

foreign key (id_Client) references Client(id_Client)
);

														--��������� 
create table Agent(
id_Agent int primary key,								--ID �������
Passport varchar(10) not null unique,					--�������
SurName varchar(50) not null,							--�������
First_Name varchar(50) not null,						--���
Middle_Name varchar(50) not null,						--��������
City varchar(100) not null,								--�����
Street varchar(100) not null,							--�����
House int not null,										--���
Corpus int null,										--������
Building int null,										--��������
Number varchar(11) not null								--������� 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),								
Email varchar(100) null									--����������� �����

foreign key (id_Agent) references Client(id_Client)
);

														--��
create table IE(
id_Client int primary key,								--��� �������
Name_IE varchar(100) not null,							--������������ ��
TIN varchar(12) not null unique,						--���
Number varchar(11) not null								--������� 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
Email varchar(100) null									--����������� �����

foreign key (id_Client) references Client(id_Client)
);
														--������
create table Cash(
id_Cash int primary key identity(1,1),					--��� ������
Cash_Name varchar(50) not null,							--�������� ������
Comments varchar(50) null,								--�����������
);

														--������
create table Uslugi(
id_Uslugi int primary key identity(1,1),				--��� ������
Name_Usligi varchar(50) not null,						--�������� ������
Price money not null,									--��������� ������
Opisanie varchar(255) not null,							--�������� ������
Comments varchar(255) null,								--�����������
Passport bit,											--����������� ��������
Agent bit,												--����������� ����������
Certificate_From_A_Narcologist bit,						--������� �� ���������
Certificate_From_A_Psychologist bit,					--������� �� ���������
Medical_Certificate bit,								--��� �������
Certificate_From_A_Autoschool bit,						--���������� �� ���������
Crypto bit,												--������ �������������
id_Cash int	not null									--��� ������

foreign key (id_Cash) references Cash(id_Cash)
);

														--�����-�����
create table Zakaz_Naryad(
Number_ZN int identity(1,1),							--����� �����-������
id_Client int not null,									--��� �������
id_Agent int null,										--��� ����������
id_Uslugi int not null,									--��� ������
Date_obr date not null									--���� ���������
	default(getdate()),
--Time_obr time not null,									--����� ���������
StatusZN bit not null									--������ �� (0 - ������, 1 - ������)
	default(0)

primary key (Number_ZN, id_Client, id_Uslugi),

foreign key (id_Client) references Client(id_Client),
foreign key (id_Uslugi) references Uslugi(id_Uslugi)
);

														--����
create table Bank(
id_Bank int primary key identity(1,1),					--��� �����
Bank_Name varchar(255) not null,						--�������� �����
--Legal_Adress varchar(255) not null,						--����������� �����
City varchar(100) not null,								--�����
Street varchar(100) not null,							--�����
House int not null,										--���
Corpus int null,										--������
Building int null,										--��������
Corr_Invoice varchar(20) not null,						--����. ����
Bic varchar(9) not null,								--��� �����
TIN varchar(10) not null,								--��� ����� 
RRC varchar(9) not null,								--��� �����
);
														--�������
create table Contracts(
number_Contract int primary key identity(1,1),			--����� ��������
Number_ZN int not null,									--����� �����-������
id_Client int not null,									--��� ������
id_Agent int null,										--��� ����������
id_Uslugi int not null,									--��� ������
Price money not null,									--���������	
id_Cash int not null,									--��� ������	
id_Bank int null,										--��� �����
Date_of_registration date not null						--���� ����������
	default(getdate()),

foreign key (Number_ZN, id_Client, id_Uslugi) references Zakaz_Naryad(Number_ZN, id_Client, id_Uslugi),
foreign key (id_Agent) references Agent(id_Agent),
foreign key (id_Cash) references Cash(id_Cash),
foreign key (id_Bank) references Bank(id_Bank)

);
	
--ALTER TABLE dbo.Invoice ADD Wallet_Number int NULL;

														--����
create table Invoice(
id_Invoice int identity(1,1),							--��� �����
id_Client int not null,									--��� �������
id_Cash int not null,									--��� ������
id_Bank int null,										--��� �����
Type_Invoice bit,										--��������� ����� !!! �� �����
Cripto bit,												--���� �������?
Wallet_Number int,										--����� ��������
Comments varchar(255) null								--�����������

primary key (id_Invoice, id_Client),

foreign key (id_Client) references Client(id_Client	),	------
foreign key (id_Bank) references Bank(id_Bank),
foreign key (id_Cash) references Cash(id_Cash)
);

														--�������� �� ������
create table payment_Doc(
number_Receipt int identity(1,1),						--����� ����
number_Contract int not null,							--����� ��������
id_Cash int not null,									--��� ������
id_Bank int null,										--��� �����
sum_pay money not null,									--����� ���������
related_Doc varchar(255) null,							--��������� ��������
Date_of_payment date not null							--���� ������
	default(getdate())

primary key (number_Receipt, number_Contract),


foreign key (number_Contract) references Contracts(number_Contract),
foreign key (id_Cash) references Cash(id_Cash),
foreign key (id_Bank) references Bank(id_Bank)
);

														--���� ������
create table rate(
numerator int not null,									--���������
denominator int not null,								--���������
--date_Today date not null,								--���� �������� �����
date_Today  datetime not null							--���� �������� ����� [������]
	default(getdate()),
rate decimal(10,3)
	check (rate >= 0)--�������� �����

primary key (numerator, denominator, date_Today),

foreign key (numerator) references Cash(id_cash),
foreign key (denominator) references Cash(id_cash)
);