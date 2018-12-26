/* at most questions */



/*
QUESTION #4
find students who take at most two courses
*/

-- my solution
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING COUNT(t.cno) <= 2;

-- MySQL and PostgreSQL solution
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING COUNT(*) <= 2;

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
							   age) AS cnt
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE cnt <= 2;

-- Original Rozenshtein solution
SELECT DISTINCT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
	 AND s.sno NOT IN
(
    SELECT t1.sno
    FROM take t1, 
	    take t2, 
	    take t3
    WHERE t1.sno = t2.sno
		AND t2.sno = t3.sno
		AND t1.cno < t2.cno
		AND t2.cno < t3.cno
);




/*
QUESTION #5
find students who are older than at most two other students
*/

-- my solution
SELECT s.*
FROM student s, 
(
    SELECT TOP 3 age, 
			  COUNT(*) AS cnt
    FROM student
    GROUP BY age
) x
WHERE s.age = x.age;

-- MySQL and PostgreSQL solution
SELECT s1.*
FROM student s1
WHERE 2 >=
(
    SELECT COUNT(*)
    FROM student s2
    WHERE s2.age < s1.age
)
ORDER BY s1.age;

-- DB2, Oracle, and SQL Server solution
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
WHERE dr <= 3;

-- Original Rozenshtein solution
SELECT *
FROM student
WHERE sno NOT IN
(
    SELECT DISTINCT 
		 s1.sno
    FROM student s1, 
	    student s2, 
	    student s3, 
	    student s4
    WHERE s1.age > s2.age
		AND s2.age > s3.age
		AND s3.age > s4.age
)
ORDER BY age;