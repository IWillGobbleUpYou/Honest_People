use master
drop database if exists honest_people;
create database honest_people
Go
use honest_people
														--Клиент
create table Client(
id_Client int primary key identity(1,1),				--ID клиента
Client_Name varchar(100) not null,						--Наименование
SurName varchar(50) not null,							--Фамилия
First_Name varchar(50) not null,						--Имя
Middle_Name varchar(50) not null,						--Отчество
City varchar(100) not null,								--Город
Street varchar(100) not null,							--Улица
House int not null,										--Дом
Corpus int null,										--Корпус
Building int null,										--Строение
Number_License varchar(20) null,						--Номер лицензии
Bank_Details int null,									--Банковские реквизиты
TIN varchar(12) null,									--ИНН	 
Certificate_From_A_Narcologist bit,						--Справка от нарколога
Certificate_From_A_Psychologist bit,					--Справка от психолога
Medical_Certificate bit,								--Мед справка
Certificate_From_A_Autoschool bit,						--Сертификат из автошколы
Wallet_Number int,										--Номер кошелька
Number varchar(11) not null unique						--Телефон 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),								
Email varchar(100) null									--Электронная почта

foreign key(id_Client) references Client(id_Client)
);

--EXEC sp_rename 'Individual.Last_Name', 'SurName', 'COLUMN';
														--Физ. Лицо
create table Individual(
id_Client int primary key,								--ID клиента
Passport varchar(10) not null unique,					--Паспорт
SurName varchar(50) not null,							--Фамилия
First_Name varchar(50) not null,						--Имя
Middle_Name varchar(50) not null,						--Отчество
City varchar(100) not null,								--Город
Street varchar(100) not null,							--Улица
House int not null,										--Дом
Corpus int null,										--Корпус
Building int null,										--Строение
Number varchar(11) not null								--Телефон 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),								
Email varchar(100) null									--Электронная почта

foreign key (id_Client) references Client(id_Client)
);
														--Юр. Лицо (Организация)
create table Entity(
id_Client int primary key,								--ID клиента
Type_of_entity varchar(6) not null						--Тип
	check(Type_of_entity in ('АО', 'ПАО', 'ЗАО', 'ФГБУ','ГБОУ','ОАО','ООО')),
Name_Entity varchar(100) not null,						--Название
TIN varchar(10) not null unique,						--ИНН	 
RRC varchar(9) not null,								--КПП
Number_license varchar(20) not null,					--Номер лицензии
City varchar(100) not null,								--Город
Street varchar(100) not null,							--Улица
House int not null,										--Дом
Corpus int null,										--Корпус
Building int null,										--Строение
Number varchar(11) not null								--Телефон 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
Email varchar(100) null									--Электронная почта

foreign key (id_Client) references Client(id_Client)
);

														--Посредник 
create table Agent(
id_Agent int primary key,								--ID клиента
Passport varchar(10) not null unique,					--Паспорт
SurName varchar(50) not null,							--Фамилия
First_Name varchar(50) not null,						--Имя
Middle_Name varchar(50) not null,						--Отчество
City varchar(100) not null,								--Город
Street varchar(100) not null,							--Улица
House int not null,										--Дом
Corpus int null,										--Корпус
Building int null,										--Строение
Number varchar(11) not null								--Телефон 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),								
Email varchar(100) null									--Электронная почта

foreign key (id_Agent) references Client(id_Client)
);

														--ИП
create table IE(
id_Client int primary key,								--Код клиента
Name_IE varchar(100) not null,							--Наименование ИП
TIN varchar(12) not null unique,						--ИНН
Number varchar(11) not null								--Телефон 79991234567 - +7(999)123-45-67 ('+[0-9]([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')
	check(number like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
Email varchar(100) null									--Электронная почта

foreign key (id_Client) references Client(id_Client)
);
														--Валюта
create table Cash(
id_Cash int primary key identity(1,1),					--Код валюты
Cash_Name varchar(50) not null,							--Название валюты
Comments varchar(50) null,								--Комментарии
);

														--Услуги
create table Uslugi(
id_Uslugi int primary key identity(1,1),				--Код услуги
Name_Usligi varchar(50) not null,						--Название услуги
Price money not null,									--Стоимость услуги
Opisanie varchar(255) not null,							--Описание услуги
Comments varchar(255) null,								--Комментарии
Passport bit,											--Необхомость паспорта
Agent bit,												--Необхомость посредника
Certificate_From_A_Narcologist bit,						--Справка от нарколога
Certificate_From_A_Psychologist bit,					--Справка от психолога
Medical_Certificate bit,								--Мед справка
Certificate_From_A_Autoschool bit,						--Сертификат из автошколы
Crypto bit,												--Оплата криптовалютой
id_Cash int	not null									--Код валюты

foreign key (id_Cash) references Cash(id_Cash)
);

														--Заказ-наряд
create table Zakaz_Naryad(
Number_ZN int identity(1,1),							--Номер заказ-наряда
id_Client int not null,									--Код клиента
id_Agent int null,										--Код посредника
id_Uslugi int not null,									--Код услуги
Date_obr date not null									--Дата обращения
	default(getdate()),
--Time_obr time not null,									--Время обращения
StatusZN bit not null									--Статус ЗН (0 - открыт, 1 - закрыт)
	default(0)

primary key (Number_ZN, id_Client, id_Uslugi),

foreign key (id_Client) references Client(id_Client),
foreign key (id_Uslugi) references Uslugi(id_Uslugi)
);

														--Банк
create table Bank(
id_Bank int primary key identity(1,1),					--Код банка
Bank_Name varchar(255) not null,						--Название банка
--Legal_Adress varchar(255) not null,						--Юридический Адрес
City varchar(100) not null,								--Город
Street varchar(100) not null,							--Улица
House int not null,										--Дом
Corpus int null,										--Корпус
Building int null,										--Строение
Corr_Invoice varchar(20) not null,						--Корр. счёт
Bic varchar(9) not null,								--БИК банка
TIN varchar(10) not null,								--ИНН банка 
RRC varchar(9) not null,								--КПП банка
);
														--Договор
create table Contracts(
number_Contract int primary key identity(1,1),			--Номер договора
Number_ZN int not null,									--Номер заказ-наряда
id_Client int not null,									--Код клиент
id_Agent int null,										--Код посредника
id_Uslugi int not null,									--Код услуги
Price money not null,									--Стоимость	
id_Cash int not null,									--Код валюты	
id_Bank int null,										--Код банка
Date_of_registration date not null						--Дата оформления
	default(getdate()),

foreign key (Number_ZN, id_Client, id_Uslugi) references Zakaz_Naryad(Number_ZN, id_Client, id_Uslugi),
foreign key (id_Agent) references Agent(id_Agent),
foreign key (id_Cash) references Cash(id_Cash),
foreign key (id_Bank) references Bank(id_Bank)

);
	
--ALTER TABLE dbo.Invoice ADD Wallet_Number int NULL;

														--Счёт
create table Invoice(
id_Invoice int identity(1,1),							--Код счёта
id_Client int not null,									--Код клиента
id_Cash int not null,									--Код валюты
id_Bank int null,										--Код банка
Type_Invoice bit,										--Категория счёта !!! Не понял
Cripto bit,												--Счёт криптой?
Wallet_Number int,										--Номер кошелька
Comments varchar(255) null								--Комментарии

primary key (id_Invoice, id_Client),

foreign key (id_Client) references Client(id_Client	),	------
foreign key (id_Bank) references Bank(id_Bank),
foreign key (id_Cash) references Cash(id_Cash)
);

														--Документ об оплате
create table payment_Doc(
number_Receipt int identity(1,1),						--Номер чека
number_Contract int not null,							--Номер договора
id_Cash int not null,									--Код валюты
id_Bank int null,										--Код банка
sum_pay money not null,									--Сумма документа
related_Doc varchar(255) null,							--Связанный документ
Date_of_payment date not null							--Дата оплаты
	default(getdate())

primary key (number_Receipt, number_Contract),


foreign key (number_Contract) references Contracts(number_Contract),
foreign key (id_Cash) references Cash(id_Cash),
foreign key (id_Bank) references Bank(id_Bank)
);

														--Курс валюты
create table rate(
numerator int not null,									--Числитель
denominator int not null,								--Знаметаль
--date_Today date not null,								--Дата значения курса
date_Today  datetime not null							--Дата значения курса [оплаты]
	default(getdate()),
rate decimal(10,3)
	check (rate >= 0)--Значение курса

primary key (numerator, denominator, date_Today),

foreign key (numerator) references Cash(id_cash),
foreign key (denominator) references Cash(id_cash)
);