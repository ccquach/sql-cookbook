/* exactly questions */



/*
QUESTION #9
find professors who teach exactly one course
*/

-- my solution (also MySQL and PostgreSQL solution)
SELECT p.*
FROM professor p, 
	teach t
WHERE p.lname = t.lname
GROUP BY p.lname, 
	    p.dept, 
	    p.salary, 
	    p.age
HAVING COUNT(*) = 1;

-- DB2, Oracle, and SQL Server solution
SELECT lname, 
	  dept, 
	  salary, 
	  age
FROM
(
    SELECT p.*, 
		 COUNT(*) OVER(PARTITION BY p.lname) AS cnt
    FROM professor p, 
	    teach t
    WHERE p.lname = t.lname
) x
WHERE cnt = 1;

-- Original Rozenshtein solution
SELECT p.*
FROM professor p, 
	teach t
WHERE p.lname = t.lname
	 AND p.lname NOT IN
(
    SELECT t1.lname
    FROM teach t1, 
	    teach t2
    WHERE t1.lname = t2.lname
		AND t1.cno < t2.cno
);



/*
QUESTION #10
find students who only take CS112 and CS114
*/

-- my solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 COUNT(*) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS cnt, 
		 SUM(CASE
			    WHEN t.cno IN('CS112', 'CS114')
			    THEN 1
			    ELSE 0
			END) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS takes_CS112_and_CS114
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE cnt = 2
	 AND takes_CS112_and_CS114 = 2;

-- MySQL and PostgreSQL solution
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING COUNT(*) = 2
	  AND MAX(CASE
			    WHEN t.cno = 'CS112'
			    THEN 1
			    ELSE 0
			END) + MAX(CASE
						WHEN t.cno = 'CS114'
						THEN 1
						ELSE 0
					 END) = 2;

-- DB2, Oracle, and SQL Server solution
SELECT sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 COUNT(*) OVER(PARTITION BY s.sno) AS cnt, 
		 SUM(CASE
			    WHEN t.cno IN('CS112', 'CS114')
			    THEN 1
			    ELSE 0
			END) OVER(PARTITION BY s.sno) AS both, 
		 ROW_NUMBER() OVER(PARTITION BY s.sno
		 ORDER BY s.sno) AS rn
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE cnt = 2
	 AND both = 2
	 AND rn = 1;

-- Original Rozenshtein solution
SELECT s1.*
FROM student s1, 
	take t1, 
	take t2
WHERE s1.sno = t1.sno
	 AND s1.sno = t2.sno
	 AND t1.cno = 'CS112'
	 AND t2.cno = 'CS114'
	 AND s1.sno NOT IN
(
    SELECT s2.sno
    FROM student s2, 
	    take t3, 
	    take t4, 
	    take t5
    WHERE s2.sno = t3.sno
		AND s2.sno = t4.sno
		AND s2.sno = t5.sno
		AND t3.cno > t4.cno
		AND t4.cno > t5.cno
);

-- original with modified subquery
SELECT s1.*
FROM student s1, 
	take t1, 
	take t2
WHERE s1.sno = t1.sno
	 AND s1.sno = t2.sno
	 AND t1.cno = 'CS112'
	 AND t2.cno = 'CS114'
	 AND s1.sno NOT IN
(
    SELECT t3.sno
    FROM take t3, 
	    take t4, 
	    take t5
    WHERE t3.sno = t4.sno
		AND t3.sno = t5.sno
		AND t3.cno > t4.cno
		AND t4.cno > t5.cno
);





/*
QUESTION #11
find students who are older than exactly two other students
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
WHERE dr = 3;

-- MySQL and PostgreSQL solution
SELECT s1.*
FROM student s1
WHERE 2 =
(
    SELECT COUNT(*)
    FROM student s2
    WHERE s2.age < s1.age
);

-- Original Rozenshtein solution
SELECT s5.*
FROM student s5, 
	student s6, 
	student s7
WHERE s5.age > s6.age
	 AND s6.age > s7.age
	 AND s5.sno NOT IN
(
    SELECT s1.sno
    FROM student s1, 
	    student s2, 
	    student s3, 
	    student s4
    WHERE s1.age > s2.age
		AND s2.age > s3.age
		AND s3.age > s4.age
);