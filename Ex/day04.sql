use hr_db;

select	first_name,
		upper(first_name),
        rpad(first_name, 10, '*')
from employees;

/***************************************
* 복수행 함수(그룹함수, 집계함수)
****************************************/
-- 종류: 갯수 합계 평균 최고값 최저값
-- 사용가능(결과 1개 --> 표현가능)
select 	sum(salary)
from employees;  

-- 사용불가능(결과 107와 1개 --> 표현불가능)
select 	first_name,
		sum(salary)
from employees;

-- *그룹함수 > count()
-- 직원의 수를 구하시오
select count(*)      -- 전체 갯수(row갯수)
from employees;

select count(commission_pct)   -- 커미션을 받은 직원의 수(null을 제외한 갯수) 
from employees;

select count(manager_id)	-- 매니저(팀장)가 있는 직원의 수(null을 제외한 갯수)	
from employees;

select	count(*), count(commission_pct)
from employees;

-- 월급이 16000 초과 되는 직원의 수는?
select 	count(*),
		count(salary),
        count(manager_id)
from employees
where salary > 16000;


-- *그룹함수 > sum()
-- 전체직원의 수와 급여의 합
select 	count(*),
		sum(salary)
from employees
;

-- 논리적으로 잘못된 합계
select 	sum(employee_id),
		sum(first_name)
from employees
;


-- *그룹함수 > avg()   :  null 포함여부
-- 월급의 평균을 구하시오
select 	avg(salary),			-- salary 가 null이면 평균에 포함안됨
		avg(ifnull(salary, 0))  -- salary 가 null이면 0으로 평균에 포함됨
from employees
;

-- *그룹함수 > max(), min()  : 정렬로직을 가지고 있어서 계산량이 많다
select  max(salary),     -- 1개
		min(salary),     -- 1개 
        sum(salary)     -- 1개
	--  first_name          여러개 x
from employees
;

select  max(hire_date),
		max(first_name)
from employees
;

-- 공부하는 시기에서 검증은 노가다 해라
select *
from employees
order by hire_date desc;
-- ------------------------------------------------

-- 부서별로 월급 합계를 구해라

-- 현재로는 where절을 이용해서 구한다 -->한그룹씩만 가능
select sum(salary) 
from employees
where department_id = 90;

-- 한번에 그룹별로 합계를 구한다
-- *Group by에 참여한 컬럼이나 그룹함수만 올 수 있다
select 	department_id,   
		count(*),
		sum(salary),
        avg(salary),
        max(salary),
        min(salary)
from employees
group by department_id
;

-- 부서별로 부서 번호와 , 인원수, 월급합계를 출력하세요
select 	department_id,
		count(*),
		sum(salary)
from employees
group by department_id
;

-- 부서별로 부서 번호와 , 최고월급, 최고월급을 받는 직원의 이름을 출력하세요
-- *Group by에 참여한 컬럼이나 그룹함수만 올 수 있다
select 	department_id,
		max(salary),
        first_name
from employees
group by department_id
;


-- 그룹을 나누는 첫번째기준 department_id, 그안에서 서브(두번째)그룹을 job_id로
select 	department_id,
		job_id,
		sum(salary),
        count(*)
from employees
group by department_id, job_id
;

select 	department_id,
		job_id,
        first_name,       -- 그룹에 참여하지 않은 컬럼명은 사용할 수 없다
		sum(salary),
        count(*)
from employees
group by department_id, job_id
;

-- -----------------------------------------------------------
-- 월급(salary)의 합계가 20000 이상인 부서의 부서 번호와 , 인원수, 월급합계를 출력하세요
select 	department_id,
		count(*),
        sum(salary)
from employees
group by department_id, job
having sum(salary) >= 20000
;

-- 월급(salary)의 합계가 20000 이상이고 부서번호가 100번 이상인 
-- 부서의 부서 번호와 , 인원수, 월급합계를 출력하세요
-- having절(그룹전용 where절) 이 조건이 복잡할때
select 	department_id,
		count(*),
        sum(salary)
from employees
group by department_id, job
having sum(salary) >= 20000
and department_id >= 100
;

/***************************************
* if(조건문, 참일때, 거짓일때)
****************************************/
-- 모든 직원의 이름, 월급, 수당, 상태(state)을 출력하세요
-- 상태컬럼은 수당이 없으면(null이면) 0, 수당이 있으면(0.5) 1 을 state 컬럼에 표시하세요
select	first_name,
		salary,
        commission_pct,
        if(commission_pct is null, '사무직','영업사원') as 'if()',
        ifnull(commission_pct, '없음') as 'ifnull()'
from employees
;

-- 직원아이디, 월급, 업무아이디, 실제월급(realSalary)을 출력하세요.
-- 실제월급은 job_id 가 'AC_ACCOUNT' 면 월급+월급*0.1,
--                      'SA_REP' 월급+월급*0.2,
--                      'ST_CLERK' 면 월급+월급*0.3
--                      그외에는 월급으로              
-- 계산하세요

select 	job_id,
        salary,
        *복잡한 if else문으로 표시  -->실제월급*
from employees
;

select *
from employees
;









