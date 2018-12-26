/* table of students */

DROP TABLE IF EXISTS student;

CREATE TABLE student
(sno   INTEGER, 
 sname VARCHAR(10), 
 age   INTEGER
);

/* table of courses */

DROP TABLE IF EXISTS courses;

CREATE TABLE courses
(cno     VARCHAR(5), 
 title   VARCHAR(10), 
 credits INTEGER
);

/* table of professors */

DROP TABLE IF EXISTS professor;

CREATE TABLE professor
(lname  VARCHAR(10), 
 dept   VARCHAR(10), 
 salary INTEGER, 
 age    INTEGER
);

/* table of students and the courses they take */

DROP TABLE IF EXISTS take;

CREATE TABLE take
(sno INTEGER, 
 cno VARCHAR(5)
);

/* table of professors and the courses they teach */

DROP TABLE IF EXISTS teach;

CREATE TABLE teach
(lname VARCHAR(10), 
 cno   VARCHAR(5)
);

INSERT INTO student VALUES (1, 'AARON', 20);
INSERT INTO student VALUES (2, 'CHUCK', 21);
INSERT INTO student VALUES (3, 'DOUG', 20);
INSERT INTO student VALUES (4, 'MAGGIE', 19);
INSERT INTO student VALUES (5, 'STEVE', 22);
INSERT INTO student VALUES (6, 'JING', 18);
INSERT INTO student VALUES (7, 'BRIAN', 21);
INSERT INTO student VALUES (8, 'KAY', 20);
INSERT INTO student VALUES (9, 'GILLIAN', 20);
INSERT INTO student VALUES (10, 'CHAD', 21);

INSERT INTO courses VALUES ('CS112', 'PHYSICS', 4);
INSERT INTO courses VALUES ('CS113', 'CALCULUS', 4);
INSERT INTO courses VALUES ('CS114', 'HISTORY', 4);

INSERT INTO professor VALUES ('CHOI', 'SCIENCE', 400, 45);
INSERT INTO professor VALUES ('GUNN', 'HISTORY', 300, 60);
INSERT INTO professor VALUES ('MAYER', 'MATH', 400, 55);
INSERT INTO professor VALUES ('POMEL', 'SCIENCE', 500, 65);
INSERT INTO professor VALUES ('FEUER', 'MATH', 400, 40);

INSERT INTO take VALUES (1, 'CS112');
INSERT INTO take VALUES (1, 'CS113');
INSERT INTO take VALUES (1, 'CS114');
INSERT INTO take VALUES (2, 'CS112');
INSERT INTO take VALUES (3, 'CS112');
INSERT INTO take VALUES (3, 'CS114');
INSERT INTO take VALUES (4, 'CS112');
INSERT INTO take VALUES (4, 'CS113');
INSERT INTO take VALUES (5, 'CS113');
INSERT INTO take VALUES (6, 'CS113');
INSERT INTO take VALUES (6, 'CS114');

INSERT INTO teach VALUES ('CHOI', 'CS112');
INSERT INTO teach VALUES ('CHOI', 'CS113');
INSERT INTO teach VALUES ('CHOI', 'CS114');
INSERT INTO teach VALUES ('POMEL', 'CS113');
INSERT INTO teach VALUES ('MAYER', 'CS112');
INSERT INTO teach VALUES ('MAYER', 'CS114');