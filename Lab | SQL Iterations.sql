-- Lab | SQL Iterations

-- Write a query to find what is the total business done by each store.
select st.store_id, sum(pa.amount) as 'Total amount made by store' from store st
join staff sta
on st.store_id = sta.store_id
join payment pa
on sta.staff_id = pa.staff_id
group by store_id
order by sum(pa.amount) desc; 

-- Convert the previous query into a stored procedure.
delimiter //
create procedure income_store()
begin
	select st.store_id, sum(pa.amount) as 'Total amount made by store' from store st
	join staff sta
	on st.store_id = sta.store_id
	join payment pa
	on sta.staff_id = pa.staff_id
	group by store_id
	order by sum(pa.amount) desc;
end
// delimiter ;
-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
drop procedure if exists income_store;


delimiter //
create procedure income_store(in store smallint)
begin
	select st.store_id, sum(pa.amount) as 'Total amount made by store' from store st
	join staff sta
	on st.store_id = sta.store_id
	join payment pa
	on sta.staff_id = pa.staff_id
	where store = st.store_id
	group by store_id
	order by sum(pa.amount) desc;
end
// delimiter ;

call income_store(2);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.
drop procedure if exists income_store;

delimiter //
create procedure income_store(in store smallint, out total_sales_value float)
begin
	select income into total_sales_value from (
		select st.store_id, sum(pa.amount) as income from store st
		join staff sta
		on st.store_id = sta.store_id
		join payment pa
		on sta.staff_id = pa.staff_id
		where store = st.store_id
		group by store_id
		order by sum(pa.amount) desc
        ) sub1;
end
// delimiter ;

call income_store(1, @total_sales_value);
select @total_sales_value;


-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.
drop procedure if exists income_store;

delimiter //
create procedure income_store(in store smallint, out total_sales_value float, out flag varchar(10))
begin

	declare flag_color varchar(10) default "";
    
	select income into total_sales_value from (
		select st.store_id, sum(pa.amount) as income from store st
		join staff sta
		on st.store_id = sta.store_id
		join payment pa
		on sta.staff_id = pa.staff_id
		where store = st.store_id
		group by store_id
		order by sum(pa.amount) desc
        ) sub1;
        
	if total_sales_value > 30000 then
		set flag_color = "green_flag";
	else
		set flag_color = "red_flag";
	end if;
    
	select flag_color into flag;
        
end
// delimiter ;

call income_store(2, @total_sales_value, @flag);
select @total_sales_value, @flag;





