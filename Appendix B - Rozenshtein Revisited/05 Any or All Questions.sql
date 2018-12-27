/* any or all questions */



/*
QUESTION #12
find students who take all courses
*/

-- my solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 COUNT(*) OVER(PARTITION BY s.sno) AS cnt
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE cnt =
(
    SELECT COUNT(*)
    FROM courses
);

-- MySQL and PostgreSQL solution
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING COUNT(*) =
(
    SELECT COUNT(*)
    FROM courses
);

-- DB2 and SQL Server solution (FAILS with error: Use of DISTINCT is not allowed with the OVER clause.)
SELECT *
FROM
(
    SELECT s.*, 
		 COUNT(t.cno) OVER(PARTITION BY s.sno) AS cnt, 
		 COUNT(DISTINCT c.title) OVER() AS total, 
		 ROW_NUMBER() OVER(PARTITION BY s.sno
		 ORDER BY c.cno) AS rn
    FROM courses c
	    LEFT JOIN take t ON c.cno = t.cno
	    LEFT JOIN student s ON t.sno = s.sno
) x
WHERE cnt = total
	 AND rn = 1;





/*
QUESTION #13
find the oldest student
*/

-- my solution
SELECT *
FROM student
GROUP BY sno, 
	    sname, 
	    age
HAVING age =
(
    SELECT MAX(age)
    FROM student
);

-- MySQL and PostgreSQL solution
SELECT *
FROM student
WHERE age =
(
    SELECT MAX(age)
    FROM student
);

-- DB2, Oracle, and SQL Server solution
SELECT sno, 
	  sname, 
	  age
FROM
(
    SELECT *, 
		 MAX(age) OVER() AS oldest
    FROM student
) x
WHERE age = oldest;

-- Original Rozenshtein solution
SELECT *
FROM student
WHERE age NOT IN
(
    SELECT a.age
    FROM student a, 
	    student b
    WHERE a.age < b.age
);

-- Original solution modified
SELECT *
FROM student
WHERE age >= ALL
(
    SELECT age
    FROM student
);