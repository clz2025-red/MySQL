/***************************************
* join
****************************************/
-- 기본원리
-- 직원의 이름과 직원이 속한 부서명을 출력하세요 
-- Steven   90 90   Executive
-- 카디젼 프로덕트   모든 경우의 수의 갯수가 된다
-- 107 * 27 = 2889건 (원하는게 아니다  107개)
select 	first_name, department_name
from employees, departments
;

-- where절을 사용한다 
select 	first_name, department_name
from employees, departments
where employees.department_id = departments.department_id  -- where절 사용
;

-- ------------------------------
# inner join (equi join)
-- ------------------------------
-- 직원의 이름과 직원이 속한 부서명을 출력하세요 
select 	first_name,
		employees.department_id,
		departments.department_id
from employees inner join departments
on employees.department_id = departments.department_id 
;

-- inner join (equi join) 정식표현
select 	e.first_name,
		e.department_id,
        d.department_id,
		d.department_name
from employees e inner join departments d
on e.department_id = d.department_id
;

-- inner join (equi join) where절 사용 -->많이 사용
select 	e.first_name,
		e.department_id,
        d.department_id,
        d.department_name
from employees e, departments d
where e.department_id = d.department_id
;

-- --------------------------------------------
-- 여러개 테이블을 조인할때
/*
107      27        23
이름   부서명    부서도시
Steven Excutive  Seattle
Neena  Excutive  Seattle
...
David  IT        Southlake
(106개)
*/
-- inner join (equi join) where절 사용 -->많이 사용
select	e.first_name,
		d.department_name,
        l.city
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
;

-- inner join (equi join) 정식표현
/*
107      27        23
이름   부서명    부서도시
Steven Excutive  Seattle
Neena  Excutive  Seattle
...
David  IT        Southlake
(106개)
*/

select 	e.first_name,
		d.department_name,
        l.city,
		l.location_id,
        d.location_id
from employees e 
inner join departments d
	    on e.department_id = d.department_id
inner join locations l
        on d.location_id = l.location_id
;


-- 모든 직원이름, 부서이름, 업무명 을 출력하세요
select	e.first_name,
		d.department_name,
        j.job_title
from employees e, departments d, jobs j
where e.department_id = d.department_id
and e.job_id = j.job_id
;

select 	e.first_name,
		d.department_name,
        j.job_title
from employees e
inner join departments d
	on e.department_id = d.department_id
inner join jobs j
	on e.job_id = j.job_id
;
-- -------------------------------------------------




select count(*) from employees;   -- 107

select count(*) from departments;  -- 27

select count(*) from locations;    -- 23


select * from employees;  -- 27

