/* stacking one rowset atop another */
SELECT ename AS ename_and_dname, 
	  deptno
FROM emp
WHERE deptno = 10
UNION ALL
SELECT '----------', 
	  NULL
FROM t1
UNION ALL
SELECT dname, 
	  deptno
FROM dept;


/* combining related rows */
SELECT e.ename, 
	  d.loc
FROM emp e, 
	dept d
WHERE e.deptno = d.deptno
	 AND e.deptno = 10;

SELECT e.ename, 
	  d.loc
FROM emp e
	JOIN dept d ON e.deptno = d.deptno
WHERE e.deptno = 10;




/* finding rows in common between two tables */
DROP VIEW V;

CREATE VIEW V
AS
	SELECT ename, 
		  job, 
		  sal
	FROM emp
	WHERE job = 'CLERK';

SELECT e.empno, 
	  v.*, 
	  e.deptno
FROM V v
	LEFT JOIN emp e ON v.ename = e.ename
				    AND v.job = e.job
				    AND v.sal = e.sal;

SELECT e.empno, 
	  v.*, 
	  e.deptno
FROM V v, 
	emp e
WHERE v.ename = e.ename
	 AND v.job = e.job
	 AND v.sal = e.sal;



/* retrieving values from one table that do not exist in another */
SELECT deptno
FROM dept
WHERE deptno NOT IN
(
    SELECT deptno
    FROM emp
);

SELECT deptno
FROM dept
EXCEPT
SELECT deptno
FROM emp;

-- be mindful of NULLs when using NOT IN
CREATE TABLE new_dept(deptno INTEGER);
INSERT INTO new_dept(deptno)
VALUES(10);
INSERT INTO new_dept(deptno)
VALUES(50);
INSERT INTO new_dept(deptno)
VALUES(NULL);

-- returns no rows because "NULL OR False" evaluates to NULL and "NOT NULL" evaluates to NULL
SELECT *
FROM dept
WHERE deptno NOT IN
(
    SELECT deptno
    FROM new_dept
);

-- equivalent OR example to above IN example shows that NOT IN is evaluating "NOT NULL", which evaluates to NULL
SELECT *
FROM dept
WHERE NOT(deptno = 10
		OR deptno = 50
		OR deptno = NULL);

-- using correlated subquery avoid issue with NULL evaluations by avoiding OR operations with NULL
SELECT deptno
FROM dept d
WHERE NOT EXISTS
(
    SELECT null -- items in SELECT list unimportant when using correlated subquery with EXISTS/NOT EXISTS since we only care if it returns a result or not
    FROM emp e
    WHERE d.deptno = e.deptno
);

SELECT deptno
FROM new_dept nd
WHERE NOT EXISTS
(
    SELECT 1
    FROM emp e
    WHERE nd.deptno = e.deptno
);




/* retrieving rows from one table that do not correspond to rows in another */
SELECT *
FROM dept d
WHERE NOT EXISTS
(
    SELECT 1
    FROM emp e
    WHERE d.deptno = e.deptno
);

SELECT d.*
FROM dept d
	LEFT JOIN emp e ON d.deptno = e.deptno
WHERE e.deptno IS NULL;

-- result set before filtering for NULL
SELECT e.ename, 
	  e.deptno AS emp_deptno, 
	  d.*
FROM dept d
	LEFT JOIN emp e ON d.deptno = e.deptno;