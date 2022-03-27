/*****************************************************************
	Creating Pivot Tables using the crosstab() function
******************************************************************/

/*
	In PostgreSQL, pivot tables are created with the help of the crosstab() function, 
	which is part of the optional tablefunc module. 
	To start using this function, you need to install the tablefunc module for a required database. 
	In PostgreSQL 9.1 and later versions, this module is installed by running a simple command:
*/

create extension tablefunc;


-- Sample 1 
SELECT * FROM crosstab
('	SELECT customers_name, product_name, SUM(cost) AS cost
	FROM v_product_customers
	GROUP BY customers_name, product_name
	ORDER BY customers_name
', '
	SELECT ''Tweetholdar'' UNION ALL
	SELECT ''Promuton'' UNION ALL
	SELECT ''Transniollor'' UNION ALL
	SELECT ''Cleanputon'' UNION ALL
	SELECT ''Tabwoofphone'' UNION ALL
	SELECT ''Supceivra'' UNION ALL
	SELECT ''Supputommar'' UNION ALL
	SELECT ''Mictellar'' UNION ALL
	SELECT ''Armlififiator'' UNION ALL
	SELECT ''Monoculimry''')
AS ct (
	customers_name VARCHAR, 
	Tweetholdar NUMERIC,
	Promuton NUMERIC,
	Transniollor NUMERIC,
	Cleanputon NUMERIC,
	Tabwoofphone NUMERIC,
	Supceivra NUMERIC,
	Supputommar NUMERIC,
	Mictellar NUMERIC,
	Armlififiator NUMERIC,
	Monoculimry numeric
);



-- Sample 2 
SELECT *
FROM crosstab(
	'select student, subject, evaluation_result from evaluations order by 1,2'
)
AS final_result(
	Student TEXT, 
	Geography NUMERIC,
	History NUMERIC,
	Language NUMERIC,
	Maths NUMERIC,
	Music numeric
);





