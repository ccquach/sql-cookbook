/** negation questions **/

/** 
QUESTION #1
find students who do not take CS112 
**/

-- returns wrong result set because student may take several courses that are not CS112
SELECT *
FROM student
WHERE sno IN
(
    SELECT sno
    FROM take
    WHERE cno != 'CS112'
);

-- my solution
SELECT s.*
FROM student s
WHERE s.sno NOT IN
(
    SELECT sno
    FROM take
    WHERE cno = 'CS112'
);

-- MySQL and PostgreSQL solution
SELECT s.*
FROM student s
	LEFT JOIN take t ON s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING MAX(CASE
			WHEN t.cno = 'CS112'
			THEN 1
			ELSE 0
		 END) = 0;

-- DB2 and SQL Server solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.*, 
		 MAX(CASE
			    WHEN t.cno = 'CS112'
			    THEN 1
			    ELSE 0
			END) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS takes_CS112
    FROM student s
	    LEFT JOIN take t ON s.sno = t.sno
) x
WHERE takes_CS112 = 0;



/**
QUESTION #2
find students who take CS112 or CS114 but not both
**/

-- returns wrong result set
SELECT *
FROM student
WHERE sno IN
(
    SELECT sno
    FROM take
    WHERE cno != 'CS112'
		AND cno != 'CS114'
);

-- my solution
SELECT COALESCE(x.sno, y.sno) AS sno, 
	  COALESCE(x.sname, y.sname) AS sname, 
	  COALESCE(x.age, y.age) AS age
FROM
(
    SELECT s.*
    FROM student s
	    INNER JOIN take t ON s.sno = t.sno
    WHERE t.cno = 'CS112'
) x
FULL OUTER JOIN
(
    SELECT s.*
    FROM student s
	    INNER JOIN take t ON s.sno = t.sno
    WHERE t.cno = 'CS114'
) y ON x.sno = y.sno
WHERE x.sno IS NULL
	 OR y.sno IS NULL;

-- MySQL and PostgreSQL solution
SELECT s.sno, 
	  s.sname, 
	  s.age
FROM student s, 
	take t
WHERE s.sno = t.sno
GROUP BY s.sno, 
	    s.sname, 
	    s.age
HAVING SUM(CASE
			WHEN t.cno IN('CS112', 'CS114')
			THEN 1
			ELSE 0
		 END) = 1;

-- DBC, Oracle, and SQL Server solution
SELECT DISTINCT 
	  sno, 
	  sname, 
	  age
FROM
(
    SELECT s.sno, 
		 s.sname, 
		 s.age, 
		 SUM(CASE
			    WHEN t.cno IN('CS112', 'CS114')
			    THEN 1
			    ELSE 0
			END) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS takes_either_or
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE takes_either_or = 1;

-- Rozenshtein modified original solution
SELECT s.sno, 
	  s.sname, 
	  s.age
FROM student s, 
	take t
WHERE s.sno = t.sno
	 AND t.cno IN ('CS112', 'CS114')
AND s.sno NOT IN
(
    SELECT a.sno
    FROM take a, 
	    take b
    WHERE a.sno = b.sno
		AND a.cno = 'CS112'
		AND b.cno = 'CS114'
);





/*
QUESTION #3
find students who take CS112 and no other courses
*/

-- returns incorrect result set since returns any student taking class CS112
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
	 AND t.cno = 'CS112';

-- my solution
SELECT sno, 
	  sname, 
	  age
FROM
(
    SELECT DISTINCT 
		 s.*, 
		 COUNT(*) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS take_cnt,
		/* 
		not necessary to flag CS112 because if only looking at students taking one class, 
		can just look at the course number of the one class they're taking
		*/
		 MAX(CASE											  
			    WHEN t.cno = 'CS112'
			    THEN 1
			    ELSE 0
			END) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS takes_cs112
    FROM student s, take t 
    WHERE s.sno = t.sno
) x
WHERE take_cnt = 1
	 AND takes_cs112 = 1;

-- MySQL and PostgreSQL solution
SELECT s.*
FROM student s, 
	take t1, 
(
    SELECT sno
    FROM take
    GROUP BY sno
    HAVING COUNT(*) = 1
) t2
WHERE s.sno = t1.sno
	 AND t1.sno = t2.sno
	 AND t1.cno = 'CS112';

-- DB2, Oracle, and SQL Server solution
SELECT sno, 
	  sname, 
	  age 
FROM
(
    SELECT s.*, 
		 t.cno, 
		 COUNT(t.cno) OVER(PARTITION BY s.sno, 
							   s.sname, 
							   s.age) AS cnt
    FROM student s, 
	    take t
    WHERE s.sno = t.sno
) x
WHERE cnt = 1
	 AND cno = 'CS112';

-- Original Rozenshtein solution
SELECT s.*
FROM student s, 
	take t
WHERE s.sno = t.sno
	 AND s.sno NOT IN
(
    SELECT sno
    FROM take
    WHERE cno != 'CS112'
);