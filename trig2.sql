--При добавлении услуги проверить, чтобы сумма договора не была меньше стоимости услуги.
--Проверить, что код валюты услуги совпадает с кодом валюты договора.

--drop trigger Contracts_insert
use honest_people
go
create trigger Contracts_insert
on Contracts
instead of insert
as
begin
	declare @UslugiPrice money;	
	declare @UslugiId_Cash int;
	declare	@Number_ZN int; 
	declare	@id_Client int; 
	declare	@id_Agent int; 
	declare	@id_Uslugi int;
	declare @ContractsPrice money;
	declare @ContractsId_cash int;
	declare @ContractsId_Bank int;
	declare @Date_of_registration date;

	declare Contracts_cursor cursor for
	select
		Uslugi.Price as UslugiPrice,							
		Uslugi.id_Cash as UslugiId_Cash,
		inserted.Number_ZN,
		inserted.id_Client, 
		inserted.id_Agent,
		inserted.id_Uslugi,
		inserted.Price as ContractsPrice,
		inserted.id_Cash as ContractsId_cash,
		inserted.id_Cash as ContractsId_Bank,

		Date_of_registration
	from Uslugi
		inner join inserted on Uslugi.id_Uslugi = inserted.id_Uslugi

	open Contracts_cursor
	fetch next from Contracts_cursor into @UslugiPrice, @UslugiId_Cash, @Number_ZN, @id_Client, @id_Agent, @id_Uslugi, @ContractsPrice, @ContractsId_cash, @ContractsId_Bank, @Date_of_registration
	while @@FETCH_STATUS = 0
		begin
			if( @UslugiPrice <= @ContractsPrice)
			begin
				if( @UslugiId_Cash = @ContractsId_cash)
				begin
					print 'сумма договора больше или равна стоимости услуги и коды валют равны'
					insert into Contracts
					values (@Number_ZN, @id_Client,@id_Agent, @id_Uslugi, @ContractsPrice, @ContractsId_cash, @ContractsId_Bank, @Date_of_registration)
				end
				else
				begin
					print 'сумма договора больше стоимости услуги, но коды валют не равны'
				end
			end
			else
			begin
				print 'сумма договора меньше стоимости услуги'
			end
			fetch next from Contracts_cursor into @UslugiPrice, @UslugiId_Cash, @Number_ZN, @id_Client, @id_Agent, @id_Uslugi, @ContractsPrice, @ContractsId_cash, @ContractsId_Bank, @Date_of_registration
		end

	close Contracts_cursor
	deallocate Contracts_cursor
end

--drop trigger Contracts_insert 
--on Contracts
--instead of insert
