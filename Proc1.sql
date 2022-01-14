--Передаётся в процедуру номер договора, сумма, код счета
--Оформляем документ об оплате.
use honest_people
go
--drop procedure proc1
create procedure Proc1
(	
	@number_Contract int,
	@price money,
	@id_Invoice int
)
as
begin
	declare 
	@id_Bank int,
	@id_Cash int,
	@flag bit = 0
	if (@flag = 0)
	begin
		set @id_Bank = (select id_Bank from Invoice where id_Invoice = @id_Invoice)
		set @id_Cash = (select id_Cash from Invoice where id_Invoice = @id_Invoice)
	
		insert into payment_Doc(number_Contract, id_Cash, id_Bank, sum_pay)
		values (@number_Contract, @id_Cash, @id_Bank, @price)
		set @flag = 1
	end
	
End
go
exec Proc1 @number_Contract = 6, @price = 2.00, @id_Invoice = 2;