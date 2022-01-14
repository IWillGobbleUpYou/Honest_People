--При формировании документа об оплате проверить соответствие кода валюты в договоре и в документе об оплате.
--Проверить, что документ об оплате формируется после даты оформления договора.
--При создании документа об оплате контролировать стоимость (в случае перебор, составить отрицательный документ)

use honest_people
go

--drop trigger PaymentDoc_insert
create trigger PaymentDoc_insert
on payment_Doc
instead of insert
as
begin
	declare @i int
	set @i = 1;

	while @i <= (select max(id) from (select row_number() over(order by number_Receipt) as id, inserted.* from inserted) as t1)
	begin

		if (
		((select SumPay from
		(
				select 
					payment_Doc.number_Contract as PD_NumberContract, sum(payment_Doc.sum_pay) as SumPay,
					Contracts.Price
				from payment_Doc
					inner join Contracts on payment_Doc.number_Contract = Contracts.number_Contract
				where payment_Doc.number_Contract = (select number_Contract from (select row_number() over(order by number_Receipt) as id, * from inserted) as t where id = @i)
						and payment_Doc.sum_pay > 0
				group by 
				 payment_Doc.number_Contract,Contracts.Price
		) as t1) + (select sum_pay from (select row_number() over(order by number_Receipt) as id, * from inserted) as t where id = @i))

		>

		(select Price from
		(
				select 
					payment_Doc.number_Contract as PD_NumberContract, sum(payment_Doc.sum_pay) as SumPay,
					Contracts.Price
				from payment_Doc
					inner join Contracts on payment_Doc.number_Contract = Contracts.number_Contract
				where payment_Doc.number_Contract = (select number_Contract from (select row_number() over(order by number_Receipt) as id, * from inserted) as t where id = @i)
				group by 
				 payment_Doc.number_Contract,Contracts.Price
		) as t1)
		)
		begin
			
	
			if (
				(select PD_IdCash from
				(
					select 
						row_number() over(order by number_Receipt) as id, 
						inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
						Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
					from inserted
						inner join Contracts on inserted.number_Contract = Contracts.number_Contract
				) as table1
				where id = @i
				) 
			=
				(select C_IdCash from
				(
					select 
						row_number() over(order by number_Receipt) as id, 
						inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
						Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
					from inserted
						inner join Contracts on inserted.number_Contract = Contracts.number_Contract
				) as table1
				where id = @i
				)
			)
			begin
	
					if (
						(select Date_of_payment from
						(
							select 
								row_number() over(order by number_Receipt) as id, 
								inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
								Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
							from inserted
								inner join Contracts on inserted.number_Contract = Contracts.number_Contract
						) as table1
						where id = @i
						) 
					>=
						(select Date_of_registration from
						(
							select 
								row_number() over(order by number_Receipt) as id, 
								inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
								Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
							from inserted
								inner join Contracts on inserted.number_Contract = Contracts.number_Contract
						) as table1
						where id = @i
						)
					)
					begin
						print 'Производим МИНУСОВУЮ вставку (Валюта совпадает, Дата оплаты больше даты оформления договора)' -- + convert(varchar(2),@i)					
						--print '--------------------------------------------------------- '  + convert(varchar(2),@i)
						insert into payment_Doc
						select 
							number_Contract, id_Cash, id_Bank, 

							(
							(select price from Contracts where number_Contract = (select number_Contract from (select row_number() over(order by number_Receipt) as id, * from inserted) as t where id = @i))
							-
							((select sum(sum_pay) from payment_Doc where sum_pay > 0 and number_Contract = (select number_Contract from (select row_number() over(order by number_Receipt) as id, * from inserted) as t where id = @i))
							+
							sum_pay)
							) as sum_pay
						
							, related_Doc, Date_of_payment from
						(
							select row_number() over(order by number_Receipt) as id, * from inserted
						) as insert1
						where id = @i

						set @i = @i + 1

					end
					else
					begin
						print 'Дата оплаты меньше даты оформления договора' --+ convert(varchar(2),@i)					
						--print '--------------------------------------------------------- '  + convert(varchar(2),@i)
						set @i = @i + 1
					end

				end
				else 
				begin
					print 'Валюта не равна' --+ convert(varchar(2),@i)					
					--print '--------------------------------------------------------- '  + convert(varchar(2),@i)
					set @i = @i + 1
				end

		end

		else
		begin
	
			if (
				(select PD_IdCash from
				(
					select 
						row_number() over(order by number_Receipt) as id, 
						inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
						Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
					from inserted
						inner join Contracts on inserted.number_Contract = Contracts.number_Contract
				) as table1
				where id = @i
				) 
			=
				(select C_IdCash from
				(
					select 
						row_number() over(order by number_Receipt) as id, 
						inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
						Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
					from inserted
						inner join Contracts on inserted.number_Contract = Contracts.number_Contract
				) as table1
				where id = @i
				)
			)
			begin
	
				if (
					(select Date_of_payment from
					(
						select 
							row_number() over(order by number_Receipt) as id, 
							inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
							Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
						from inserted
							inner join Contracts on inserted.number_Contract = Contracts.number_Contract
					) as table1
					where id = @i
					) 
				>=
					(select Date_of_registration from
					(
						select 
							row_number() over(order by number_Receipt) as id, 
							inserted.number_Receipt, inserted.number_Contract as PD_NumberContract, inserted.id_Cash as PD_IdCash, inserted.id_Bank, inserted.related_Doc, inserted.Date_of_payment,
							Contracts.number_Contract as C_NumberContract, Contracts.Number_ZN, Contracts.id_Client, Contracts.id_Uslugi, Contracts.Price, Contracts.id_cash as C_IdCash, Contracts.Date_of_registration
						from inserted
							inner join Contracts on inserted.number_Contract = Contracts.number_Contract
					) as table1
					where id = @i
					)
				)
				begin
					print 'Производим вставку (Валюта совпадает, Дата оплаты больше даты оформления договора)' -- + convert(varchar(2),@i)					
					--print '--------------------------------------------------------- '  + convert(varchar(2),@i)
					insert into payment_Doc
					select number_Contract, id_Cash, id_Bank, sum_pay, related_Doc, Date_of_payment from
					(
						select row_number() over(order by number_Receipt) as id, * from inserted
					) as insert1
					where id = @i

					set @i = @i + 1

				end
				else
				begin
					print 'Дата оплаты меньше даты оформления договора' --+ convert(varchar(2),@i)					
					--print '--------------------------------------------------------- '  + convert(varchar(2),@i)
					set @i = @i + 1
				end

			end
			else 
			begin
				print 'Валюта не равна' --+ convert(varchar(2),@i)					
				--print '--------------------------------------------------------- '  + convert(varchar(2),@i)
				set @i = @i + 1
			end
		end
	end
end