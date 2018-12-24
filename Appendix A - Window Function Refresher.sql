--SELECT
--	ename
--	, deptno
--	, COUNT(*) OVER(PARTITION BY deptno) AS dept_cnt
--	, job
--	, COUNT(*) OVER(PARTITION BY job) AS job_cnt
--FROM emp
--ORDER BY 2
--;
--SELECT
--	ename
--	, deptno
--	, (SELECT COUNT(*) FROM emp) AS cnt
--FROM emp
--GROUP BY ename, deptno
--ORDER BY 2
--;
--SELECT COALESCE(comm, -1) AS comm
--	, COUNT(comm) OVER(PARTITION BY comm) AS cnt
--FROM emp
--;

--SELECT deptno, 
--       ename, 
--       hiredate, 
--       sal, 
--       SUM(sal) OVER(PARTITION BY deptno) AS total1, 
--       SUM(sal) OVER() AS total2, 
--       SUM(sal) OVER(ORDER BY hiredate) AS running_total
--FROM emp
--WHERE deptno = 10;

--select deptno
--	, ename
--	, sal
--	, sum(sal) over(order by hiredate range between unbounded preceding and current row) as run_total1
--	, sum(sal) over(order by hiredate rows between 1 preceding and current row) as run_total2
--	, sum(sal) over(order by hiredate range between current row and unbounded following) as run_total3
--	, sum(sal) over(order by hiredate rows between current row and 1 following) as run_total4
--from emp
--where deptno = 10
--order by hiredate
--;

--select ename
--	, sal
--	, min(sal) over(order by sal) as min1
--	, max(sal) over(order by sal) as max1
--	, min(sal) over(order by sal range between unbounded preceding and unbounded following) as min2
--	, max(sal) over(order by sal range between unbounded preceding and unbounded following) as max2
--	, min(sal) over(order by sal range between current row and current row) as min3
--	, max(sal) over(order by sal range between current row and current row) as max3
--	, max(sal) over(order by sal rows between 3 preceding and 3 following) as max4
--from emp
--;

--select deptno
--	, emp_cnt as dept_total
--	, total
--	, max(case when job = 'CLERK' then job_cnt else 0 end) as clerks
--	, max(case when job = 'MANAGER' then job_cnt else 0 end) as mgrs
--	, max(case when job = 'PRESIDENT' then job_cnt else 0 end) as prez
--	, max(case when job = 'ANALYST' then job_cnt else 0 end) as anals
--	, max(case when job = 'SALESMAN' then job_cnt else 0 end) as smen
--from (
--select deptno
--	, job
--	, count(*) over(partition by deptno) as emp_cnt
--	, count(*) over(partition by deptno, job) as job_cnt
--	, count(*) over() as total
--from emp) x
--group by deptno, emp_cnt, total
--;

select deptno
	, ename as name
	, sal
	, max(sal) over(partition by deptno) as hiDpt
	, min(sal) over(partition by deptno) as loDpt
	, max(sal) over(partition by job) as hiJob
	, min(sal) over(partition by job) as loJob
	, max(sal) over() as hi
	, min(sal) over() as lo
	, sum(sal) over(partition by deptno order by sal, empno) as dptRT
	, sum(sal) over(partition by deptno) as dptSum
	, sum(sal) over() as ttl
from emp
order by deptno, dptRT
;