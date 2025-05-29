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



-- 부서번호가 110인 직원의 월급와 같은 월급을 받는 
-- 모든 직원의 사번, 이름, 월급를 출력하세요

-- 1) 부서번호가 100인 직원의 월급  12008.00, 8300.00
select 	salary
from employees
where department_id = 110
;

-- 2-1) where절로 구하기,  or 조건절이 여러개
select	employee_id,
		first_name,
        salary
from employees
where salary = 12008.00
or salary = 8300
;

-- 2-2) in () 구하기
select	employee_id,
		first_name,
        salary
from employees
where salary in (12008.00, 8300)
;

-- 3) 합치기 2-2) 사용
select	employee_id,
		first_name,
        salary
from employees
where salary in (select	salary
				 from employees
				 where department_id = 110)  -- 12008.00, 8300
;

-- 각 부서별로 최고급여를 받는 사원의 이름과 월급을 출력하세요
/*
Jennifer 10 4400.00
Michael  20 13000.00
Den      30 11000.00
Susan    40 6500.00
Adam	 50	8200.00     
*/

-- 1) 각 부서별 최고 월급 --> 이름출력 안됨
select 	department_id,
		max(salary)
from employees
group by department_id
;

/*
10	4400.00
20	13000.00
30	11000.00
...
*/

-- 2) 각부서별 최고급액을 받은 사람 이름 출력
-- 2-1) where절로 표현
select 	first_name,
		department_id,
        salary
from employees
where (department_id = 10 and salary = 4400)     
or (department_id = 20 and salary = 13000)
or (department_id = 30 and salary = 11000)
;

-- 2-2) in ()   --> 비교값이 2개이상 
select 	first_name,
		department_id,
        salary
from employees
where (department_id, salary) in ((10, 4400), (20,13000), (30,11000))
;


-- 3) 합치기   2-2 사용
select 	first_name,
		department_id,
        salary
from employees                      -- 1)식                    
where (department_id, salary) in ( select department_id,
										  max(salary)
								   from employees
								   group by department_id )
;


-- 부서번호가 110인 직원의 월급 중 
-- 가장 작은 월급 보다 월급이 많은 모든 직원의 
-- 이름, 급여를 출력하세요.(or연산--> 8300보다 큰)

-- 1)부서번호가 110인 직원의 월급 (8300,  12008)
select 	first_name,
		salary 
from employees
where department_id = 110 
;

-- 2) 8300보다 많은 직원( 8300보다 많은 또는 12008 보다 많은 )
-- 2-1) where절

select *
from employees
where salary >= 8300
or salary >= 12008
;

-- 2-2) any()    where절이 or일때
select *
from employees
where salary >=any (8300, 12008)
;

-- 3) 합치기
-- or ---> any
select 	first_name,
		salary
from employees
where salary >=any (select salary 
					from employees
					where department_id = 110 )
;



-- 부서번호가 110인 직원의 월급 중 
-- 가장 많은 월급 보다 월급이 많은 모든 직원의 
-- 이름, 급여를 출력하세요.(and연산--> 12008보다 큰)

-- 1) 부서번호 110인 직원의 월급 구하기
select 	first_name,
		salary
from employees
where department_id = 110;

-- 2) 부서번호 110의 직원의 월급 중 가장 높은 월급보다 월급이 높은 직원 구하기
-- 2-1) where절로 표현
select 	first_name,
		salary
from employees
where salary > 8300
and salary >12008
;

-- 2-2) all ()로 표현   -- 의미만
select 	first_name,
		salary
from employees
where salary >all (8300, 12008)
;


-- 합치기 2-2)를 사용
select 	first_name,
		salary
from employees
where salary >all (select salary
				   from employees
				   where department_id = 110)
;


-- ------------------------------------------------
# SubQuery   where절 vs 테이블
-- ------------------------------------------------
-- #where절로 해결
-- 각 부서별로 최고월급을 받는 사원의 부서번호, 직원번호, 이름, 월급을 출력하세요
-- 1) 각 부서별 최고 월급   (리스트)
select 	department_id,
		max(salary) 
from employees
group by department_id
order by department_id asc   --  확인용
;

-- 2-1) where절  
select *
from employees
where department_id =10 and salary = 4400
or department_id =20 and salary = 13000
or department_id =30 and salary = 11000
;

-- 2-2)   in (),  >any (),  >all () 
select *
from employees
where (department_id, salary) in ( (10,4400) , (20,13000) , (30,11000))
;

-- 3) 2-2)로 합친다
-- 부서번호, 직원번호, 이름, 월급
select 	department_id,
		employee_id,
        first_name,
        salary
from employees
where (department_id, salary) in (select department_id,
										 max(salary) 
								  from employees
								  group by department_id)
;

/*
select *
from 테이블명
where 컬럼명 in (서브커리 결과)
*/
-- ---------------------------------------------------------------

-- #from절의 테이블로 해결
/*
-- 테이블2를 조인한다
select *
from 테이블명, 테이블2(서브퀄결과)
where 컬럼명 = 컬럼명
*/

-- 각 부서별로 최고월급을 받는 사원의 부서번호, 직원번호, 이름, 월급을 출력하세요
-- 1) 각 부서별 최고월급
select  department_id,
		max(salary)
from employees
group by department_id
;

select *
from locations;
/*결과 일부
(10, 4400)
(20, 13000)
(30, 11000)
*/

-- 2) 전체구조
select *
from employees e,  가상의테이블 s
where e.department_id = s.department_id
and e.salary = s.salary
;


select *
from employees e 
where e.department_id = 20
and e.salary = 6000
;

-- 각 부서별로 최고급여를 받는 사원을 출력하세요 
select  department_id,
		max(salary)
from employees
group by department_id
;

select 	employee_id,
		department_id,
		first_name,
		salary
from employees e
where (e.department_id = 10 and salary = 4400)
or (e.department_id = 20 and salary = 13000)
or (e.department_id = 30 and salary = 11000)
;


select 	employee_id,
		department_id,
		first_name,
		salary
from employees e
where (department_id, salary) in (select  department_id,
										  max(salary)
								  from employees
								  group by department_id)
;


-- -------------------------------------------------------

select  department_id,
		max(salary)
from employees
group by department_id
;


select *
from employees e, salary s 
where e.department_id = s.department_id
and e.salary = s.salary








