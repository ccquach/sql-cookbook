/* sorting mixed alphanumeric data */

-- NOTE: TRANSLATE function requires SQL Server 2017

CREATE VIEW V
AS
	SELECT ename + ' ' + STR(deptno) AS data
	FROM emp;

SELECT data, 
	  TRANSLATE(data, '0123456789', '##########') AS translate, 
	  replace(TRANSLATE(data, '0123456789', '##########'), '#', '') AS chars, 
	  replace(data, replace(TRANSLATE(data, '0123456789', '##########'), '#', ''), '') AS nums
FROM V;

SELECT data
FROM V
ORDER BY replace(TRANSLATE(data, '0123456789', '##########'), '#', '');



/* dealing with nulls */

-- non-null comm asc, all nulls last
SELECT ename, 
	  sal, 
	  comm
FROM
(
    SELECT ename, 
		 sal, 
		 comm,
		 CASE
			WHEN comm IS NULL
			THEN 0
			ELSE 1
		 END AS is_null
    FROM emp
) x
ORDER BY is_null DESC, 
	    comm;

-- non-null comm desc, all nulls last
SELECT ename, 
	  sal, 
	  comm
FROM
(
    SELECT ename, 
		 sal, 
		 comm,
		 CASE
			WHEN comm IS NULL
			THEN 0
			ELSE 1
		 END AS is_null
    FROM emp
) x
ORDER BY is_null DESC, 
	    comm DESC;

-- non-null comm asc, all nulls first
SELECT ename, 
	  sal, 
	  comm
FROM
(
    SELECT ename, 
		 sal, 
		 comm,
		 CASE
			WHEN comm IS NULL
			THEN 0
			ELSE 1
		 END AS is_null
    FROM emp
) x
ORDER BY is_null, 
	    comm;

-- non-null comm desc, all nulls first
SELECT ename, 
	  sal, 
	  comm
FROM
(
    SELECT ename, 
		 sal, 
		 comm,
		 CASE
			WHEN comm IS NULL
			THEN 0
			ELSE 1
		 END AS is_null
    FROM emp
) x
ORDER BY is_null, 
	    comm DESC;


/* sorting on a data dependent key */
SELECT ename, 
	  sal, 
	  job, 
	  comm
FROM emp
ORDER BY CASE
		   WHEN job = 'SALESMAN'
		   THEN comm
		   ELSE sal
	    END;

SELECT ename, 
	  sal, 
	  job, 
	  comm,
	  CASE
		 WHEN job = 'SALESMAN'
		 THEN comm
		 ELSE sal
	  END AS ordered
FROM emp
ORDER BY 5;