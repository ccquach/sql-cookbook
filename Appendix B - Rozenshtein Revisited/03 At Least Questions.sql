/* at least questions */


/*
QUESTION #6
find students who take at least two classes
*/

-- my solution (also the MySQL and PostgreSQL solution)
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING COUNT(*) >= 2;

-- DB2, Oracle, and SQL Server solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 COUNT(*) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS cnt
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE cnt >= 2;

-- Original Rozenshtein solution
SELECT *
FROM student
WHERE sno IN
(
    SELECT t1.sno
    FROM take t1, 
	    take t2
    WHERE t1.sno = t2.sno
		AND t1.cno > t2.cno
);




/*
QUESTION #7
find students who take both CS112 and CS114, in additon to any other classes
*/

-- my solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 SUM(CASE
			    WHEN t.cno IN('CS112', 'CS114')
			    THEN 1
			    ELSE 0
			END) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS takes_both
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE takes_both = 2;

-- MySQL and PostgreSQL solution
SELECT s.sno, 
	  s.sname, 
	  s.age
FROM student s, 
	take t
WHERE s.sno = t.sno
	 AND t.cno IN('CS112', 'CS114')
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING MIN(t.cno) != MAX(t.cno);

-- DB2, Oracle, and SQL Server solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 MIN(t.cno) OVER(PARTITION BY s.sno) AS min_cno, 
		 MAX(t.cno) OVER(PARTITION BY s.sno) AS max_cno
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
		AND t.cno IN('CS112', 'CS114')
) x
WHERE min_cno != max_cno;

-- Original Rozenshtein solutions
SELECT s.*, 
	  t1.*, 
	  t2.*
FROM student s, 
	take t1, 
	take t2
WHERE s.sno = t1.sno
	 AND t1.sno = t2.sno
	 AND t1.cno = 'CS112'
	 AND t2.cno = 'CS114';

SELECT s.*
FROM student s, 
	take t1
WHERE s.sno = t1.sno
	 AND t1.cno = 'CS114'
	 AND 'CS112' = ANY
(
    SELECT t2.cno
    FROM take t2
    WHERE t1.sno = t2.sno
		AND t2.cno != 'CS114'
);




/*
QUESTION #8
find students who are older than at least two other students
*/

-- my solution (also DB2, Oracle, and SQL Server solution)
SELECT sno, 
	  sname, 
	  age
FROM
(
    SELECT *, 
		 DENSE_RANK() OVER(
		 ORDER BY age) AS dr
    FROM student
) x
WHERE dr >= 3
ORDER BY sno;

-- MySQL and PostgreSQL solution
SELECT s1.*
FROM student s1
WHERE 2 <=
(
    SELECT COUNT(*)
    FROM student s2
    WHERE s2.age < s1.age
);

-- Original Rozenshtein solution
SELECT DISTINCT 
	  s1.*
FROM student s1, 
	student s2, 
	student s3
WHERE s1.age > s2.age
	 AND s2.age > s3.age;