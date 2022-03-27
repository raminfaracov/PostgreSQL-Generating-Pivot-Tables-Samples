/***********************************************************************
	Creating Own Function for generate Pivot Table using Dynamic SQL
************************************************************************/

-- This is simple example for generate pivot table using dynnamic SQL 
CREATE OR REPLACE FUNCTION generate_pivot_table
(
	p_tablename text, 
	p_pivot_fieldname text, 
	p_group_field_list text[], 
	p_count_sum text
)
RETURNS text
LANGUAGE plpgsql
AS $function$
declare
	v_sql text; 
	t_case text; 
	t_group text; 
	t_group1 text; 
	array_values text[];	
	p_val text;
	p_del text;
	tbl_alias text = 'tb1'; 
	temp_tablename text = 'test.my_temp_table';
	i int4;
begin
	v_sql = format('select array_agg(distinct %s::text) from %s where %s is not null', p_pivot_fieldname, p_tablename, p_pivot_fieldname);

	execute v_sql into array_values;

	if (array_values is null) then 
		raise notice 'ERROR: All values of pivot field are null';
	end if; 

		t_case = '';
		p_del = ''; 
	
	for i in array_lower(array_values, 1)..array_upper(array_values, 1)
	loop
		p_val = array_values[i];
		t_case = t_case || p_del || format('case when %s.%s = ''%s'' then %s.p_val else 0 end as "%s"', tbl_alias, p_pivot_fieldname, p_val, tbl_alias, p_val);
		p_del = ', '; 	
	end loop;


		p_del = ', ';
		t_group = p_pivot_fieldname || p_del;
		t_group1 = '';
	for i in array_lower(p_group_field_list, 1)..array_upper(p_group_field_list, 1)
	loop
		p_val = p_group_field_list[i];
		t_group = t_group || format('%s', p_val) || p_del;
		t_group1 = t_group1 || format('%s.%s', tbl_alias, p_val) || p_del;
	end loop;

	v_sql = format('
		select %s %s as p_val  
		from 
			%s 
		group by 
			%s 
	', t_group, p_count_sum, p_tablename, trim(trim(t_group), ','));


	v_sql = format('
		create table %s as 
		select 
			%s 
			%s 
		from (
	', temp_tablename, t_group1, t_case) || v_sql || ') ' || tbl_alias; 


	execute 'drop table if exists ' || temp_tablename || ' CASCADE ';
	execute v_sql;

	return 'select * from ' || temp_tablename;
	
END;
$function$;



-- Sample 1 
select * 
from 
	test.generate_pivot_table
	(
		'test.evaluations', 
		'subject', 
		'{student}'::text[], 
		'sum(evaluation_result)'
	);

select * from test.my_temp_table;




