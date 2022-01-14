--Передаём в процедуру код клиента посредника, код клиента и код услуги (неограниченное количество пар значений (код клиента / код услуги)
--Формируем каждой паре значений заказ-наряд и договор.

create procedure Proc2
(
	@values varchar(max)	

)as 
begin
	declare
	@id_Agent	int,
	@id_Client	int,
	@id_Uslugi	int,

	@delimeter1 varchar = ';',
	@delimeter2 varchar = ',',
	@indexdelimeter1 int,
	@indexdelimeter2 int,
	
	@Price		money,
	@id_Cash	int,
	@id_Bank	int,
	@Number_ZN	int,
	@number		int = 1,
	@temp varchar(max),

	@check varchar(2)

	set @values = REPLACE(REPLACE(REPLACE(@values, CHAR(10), ''), CHAR(13), ''), CHAR(9), '')
	set @check =  REVERSE(@values)
	if CHARINDEX(@delimeter1,@check,0)!=1
		set @values = concat(@values, ';')
	
	set @indexdelimeter1 = CHARINDEX(@delimeter1,@values,@number)
	while (@indexdelimeter1 != 0)
	begin
		set @indexdelimeter2 = CHARINDEX(@delimeter2,@values, @number)
		if @indexdelimeter2 !=0		
		begin
			set @temp = SUBSTRING(@values, @number, (@indexdelimeter2-@number))
			if (@temp='NULL')
				set @id_Agent = 0
			else
				set @id_Agent = Cast(@temp as int)
			set @number = @indexdelimeter2+1

			set @indexdelimeter2 = CHARINDEX(@delimeter2,@values, @number)
			set @temp = SUBSTRING(@values, @number, (@indexdelimeter2-@number))
			if (@temp='NULL')
				set @id_Client = 0
			else
				set @id_Client = Cast(@temp as int)
			set @number = @indexdelimeter2+1
			------------chat
--			set @indexdelimeter2 = CHARINDEX(@delimeter2,@values, @number)
			set @temp = SUBSTRING(@values, @number, (@indexdelimeter1-@number))
			if (@temp='NULL')
				set @id_Uslugi = 0
			else
				set @id_Uslugi = Cast(@temp as int)
			set @number = @indexdelimeter1+1
			------------
		end

		begin

			set @id_Cash = (select id_Cash from Uslugi where id_Uslugi = @id_Uslugi)
	
			insert into Zakaz_Naryad(id_Client, id_Agent, id_Uslugi)
			values (@id_Client, @id_Agent, @id_Uslugi)
		end
		begin
		
			set @Number_ZN = (select max(Number_ZN) from Zakaz_Naryad)
			set @Price = (select Price from Uslugi where id_Uslugi = @id_Uslugi)
			set @id_Cash = (select id_Cash from Uslugi where id_Uslugi = @id_Uslugi)
			set @id_Bank = (select id_Bank from Invoice where id_Client= @id_Client and id_Cash = @id_Cash)

			insert into Contracts(Number_ZN, id_Client,	id_Agent, id_Uslugi, Price, id_Cash, id_Bank)
			values(@Number_ZN, @id_Client, @id_Agent, @id_Uslugi, @Price, @id_Cash, @id_Bank)
		end
			set @indexdelimeter1 = CHARINDEX(@delimeter1,@values,@number)

	end
end
go

--drop proc proc2 
--
exec proc2 @values = '
5,2,5;
5,3,4;'

--2,3,4;
--1,5,3;


--@id_Agent = 5, @id_Client = 1, @id_Uslugi = 1