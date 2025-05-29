-- ------------------------------------------------
# SubQuery
-- ------------------------------------------------
-- 'Den' 보다 월급을 많은 사람의 이름과 월급은?

-- 1)딘의 월급  11000
select 	salary
from employees
where first_name = 'Den'
;

-- 2)11000 보다 받은사람리스트
select 	first_name,
		salary
from employees
where salary >= 11000
;

-- 1)과 2)합친다
select 	first_name,
		salary
from employees
where salary >= (select salary
				 from employees
				 where first_name = 'Den')
;

-- 월급을 가장 적게 받는 사람의 이름, 월급, 사원번호는?
-- 가장적은 월급 min(), 그룹함수라서 이름..하고 같이 사용할수 없다
-- 1)가장 적은 월급 --> 2100
select min(salary)
from employees
;

-- 2)월급이 2100인 사람의 이름, 월급, 사번 
select 	first_name,
		salary,
        employee_id
from employees
where salary = 2100
;

-- 3)합치기
select 	first_name,
		salary,
        employee_id
from employees
where salary = (select min(salary)
				from employees)
;

-- !!!절대로 한방에 작성하지 않는다  오해!!!!! 하지말자

-- 평균 월급보다 적게 받는 사람의 이름, 월급을 출력하세요?
-- 1)평균월급  --> 6461.831776
select avg(salary)
from employees
;


-- 2)6461.831776보다 월급이 적은 사람을 구한다
select *
from employees
where salary <= 6461.831776
;

-- 1)과 2) 합친다
select	first_name,
		salary
from employees
where salary <= (select avg(salary)
				 from employees )
order by salary desc
;









