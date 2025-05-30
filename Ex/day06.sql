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
select 	department_id,
		employee_id,
        first_name,
        salary
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

-- ---------------------------------------------------------------

-- 각 부서별로 최고월급을 받는 사원의 부서번호, 직원번호, 이름, 월급을 출력하세요
-- #테이블로 해결

-- 1) 각 부서별 최고월급 데이터가 있는 테이블이 있다면 구할 수 있다
--    --> 이부분은 아디디어가 필요함(어려울 수있으므로 지금 생각이 안난다면 넘어가자)
--    --> 단 테이블 조인으로 해결할 수 있다 는 믿고가자
select  department_id,
		max(salary) maxSalary   -- 별명을 왜 주었는지 생각해 볼것
from employees
group by department_id
;
/*결과 일부
(10, 4400)
(20, 13000)
(30, 11000)
*/

-- 2) 전체구조
select employee_id,
	   department_id,
	   first_name,
	   salary
from employees e,  가상의테이블 s
where e.department_id = s.department_id
and e.salary = s.salary
;

-- 3) 합치기      -- 1)번의 결롸를 테이블로 사용
select 	e.department_id,
		e.employee_id,
        e.first_name,
		e.salary,
        s.maxSalary
from employees e, (select  department_id,
						   max(salary) maxSalary
				   from employees
				   group by department_id) s 
where e.department_id = s.department_id
and e.salary = s.maxSalary
;


-- ------------------------------------------------
# limit
-- ------------------------------------------------
-- 직원관리 페이지,   
-- 사번이 작은 직원이 위쪽에 출력(요구사항에 있었음)
-- -->자동으로 정렬(믿으면안됨)되더라도 꼭 order by 절로 정렬해줘야함
-- *1페이지의 데이터만 가져오기(1페이지에 5개)
/*
(0, 5)  --> 1번부터 5개 
(5, 10)  --> 6번부터 5개  
(10, 10)  --> 11번부터 5개  
*/ 
 
select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 0, 5      -- 첫번째부터 5개
;

select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 5, 5      -- 6번째부터 5개
;

select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 10, 5      -- 10번째부터 5개
;
-- ------------------
-- * 0 생략
select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 7      -- 처음부터 7개
;
-- ------------------
-- *다른표현
select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 5 offset 0      -- 첫번째부터 5개
;

select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 5 offset 5      -- 6번째부터 5개
;

select 	employee_id,
		first_name,
        salary
from employees
order by employee_id asc
limit 5 offset 10      -- 11번째부터 5개
;


-- 07년에 입사한 직원중 급여가 많은 직원중 3에서 7등의 이름 급여 입사일은? 
-- 1)전체확인
select *
from employees
;

-- 2)20007년 입사자만 조회
select *
from employees
where hire_date >= '2007-01-01'
and hire_date < '2008-01-01'
;

-- 3)월급이 큰 사람부터 내림차순 정렬
select *
from employees
where hire_date >= '2007-01-01'
and hire_date < '2008-01-01'
order by salary desc
;

-- 4) 3번째 부터 5명 출력
select *
from employees
where hire_date >= '2007-01-01'
and hire_date < '2008-01-01'
order by salary desc
limit 2, 5
;


-- 5) 출력컬럼 결정
select 	first_name,
		hire_date,
        salary
from employees
where hire_date >= '2007-01-01'
and hire_date < '2008-01-01'
order by salary desc
limit 2, 5
;

-- ------------------
-- * 2007년을 구하는 여러가지 방법
select	first_name,
		hire_date
from employees
where hire_date >= '2007-01-01'
and hire_date < '2008-01-01'
order by hire_date asc
;

select	first_name,
		hire_date
from employees
where hire_date between '2007-01-01' and '2007-12-31'
order by hire_date asc
;

select	first_name,
		hire_date,
        date_format(hire_date, '%y') 
from employees
where date_format(hire_date, '%y') = '07'
order by hire_date asc
;

select	first_name,
		hire_date,
        date_format(hire_date, '%Y') 
from employees
where date_format(hire_date, '%Y') = '2007'
order by hire_date asc
;

-- ------------------
-- 부서번호가 100인 직원중 월급을 가장 많이 받은 직원의 이름, 월급, 부서번호를 출력하세요

-- 1)부서번호가 100인 직원
select *
from employees
where department_id = 100
;

-- 2)부서번호100에서 가장 큰 월급
select 	max(salary)
	--  first_name   안됨(107개)
from employees
where department_id = 100
;

-- 3) 월급 12008 직원을 찾는다,  부서번호 100이어야한다 
select *
from employees
where salary = 12008   -- 12008을 서브쿼리도 변경
and department_id = 100
;

-- 4) 서브쿼리 적용
select	first_name,
		salary,
        department_id
from employees
where salary = (select 	max(salary)
				from employees
				where department_id = 100)   
and department_id = 100
;
-- -------------------------------------------------





