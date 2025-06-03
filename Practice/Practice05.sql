-- 혼합 SQL 문제입니다.

/*
문제1.
담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의 
이름, 매니저아이디, 커미션 비율, 월급 을 출력하세요.
(45건)
*/
select 	e.first_name,
		e.manager_id,
        e.commission_pct,
        e.salary
from employees e
where e.manager_id is not null
and e.commission_pct is null
and e.salary > 3000
;

/*
문제2. 
각 부서별로 최고의 월급을 받는 사원의 직원번호(employee_id), 이름(first_name), 
월급 (salary), 입사일(hire_date), 전화번호(phone_number), 부서번호(department_id) 를 조회하세요 
-조건절비교 방법으로 작성하세요
-월급의 내림차순으로 정렬하세요
-입사일은 2001-01-13 토요일 형식으로 출력합니다.
-전화번호는 515-123-4567 형식으로 출력합니다.
(11건)
*/
# 1)각부서별 최고월급
select 	e.department_id,
		max(salary)
from employees e
group by e.department_id
;

# 2) 부서별 최고월급자 샘플데이터 2개만 적용
select *
from employees e
where (e.department_id, salary) in ((90, 24000), (60, 9000))
;

# 3)합치기
select 	e.employee_id,
		e.first_name,
        e.salary,
        concat(
			date_format(e.hire_date, '%Y-%m-%d'),
			" ",
            CASE date_format(e.hire_date, '%w')
				WHEN '0' THEN '일요일'
				WHEN '1' THEN '월요일'
				WHEN '2' THEN '화요일'
				WHEN '3' THEN '수요일'
				WHEN '4' THEN '목요일'
				WHEN '5' THEN '금요일'
				WHEN '6' THEN '토요일'
			END
		) hire_date,
        replace(e.phone_number, ".", "-") phone_number,
        e.department_id
from employees e
where (e.department_id, salary) in (select 	e.department_id,
											max(salary)
									from employees e
									group by e.department_id)
order by salary desc
;

/*
문제3
매니저별 담당직원들의 평균월급 최소월급 최대월급을 알아보려고 한다.
-통계대상(직원)은 2005년 이후(2005년 1월 1일 ~ 현재)의 입사자 입니다.
-매니저별 평균월급이 5000이상만 출력합니다.
-매니저별 평균월급의 내림차순으로 출력합니다.
-매니저별 평균월급은 소수점 첫째자리에서 반올림 합니다.
-출력내용은 매니저아이디, 매니저이름(first_name), 매니저별평균월급, 매니저별최소월급, 매니저별최대월급 입니다.
(9건)
*/
select  t.manager_id,
        e.first_name,
        t.avgSalary,
        t.minSalary,
        t.maxSalary
from employees e, ( select  manager_id, 
                            round(avg(salary),0) avgSalary, 
                            min(salary) minSalary, 
                            max(salary) maxSalary
                    from employees
                    where hire_date >= '05/01/01'
                    group by manager_id
                    having avg(salary) >= 5000 ) t
where e.employee_id = t.manager_id
order by avgSalary desc;





/*
문제4.
각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 
부서명(department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
부서가 없는 직원(Kimberely)은 표시 합니다.
매니저가 없는 직원(Steven) 은 출력하지 않습니다.
(106명)
*/

select  emp.employee_id as "사번",
        emp.first_name as "이름",
        dep.department_name as "부서명",
        mag.first_name as "매니저이름"
from employees emp
left outer join departments dep on emp.department_id = dep.department_id
inner join employees mag on emp.manager_id = mag.employee_id
;



/*
문제5.
2005년 이후 입사한 직원중에 입사일이 11번째에서 20번째의 직원의 
사번, 이름, 부서명, 월급, 입사일을 입사일 순서로 출력하세요
*/
select  employee_id,
		first_name,
		salary,
		hire_date
from employees
where hire_date >= '2005-01-01'
order by hire_date asc
limit 10, 10
;

/*
문제6.
가장 늦게 입사한 직원의 이름(first_name last_name)과 
월급(salary)과 근무하는 부서 이름(department_name)은?
*/ 
select  concat (e.first_name, ' ', e.last_name) 이름,
        e.salary 연봉,
        d.department_name 부서이름,
        e.hire_date -- 참고용
from employees e, departments d
where e.department_id = d.department_id 
  and e.hire_date = ( select max(hire_date)
                      from employees ) ;
 


/*
문제7.
평균월급(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 
이름(firt_name), 성(last_name)과  업무(job_title), 월급(salary)을 조회하시오.
*/ 

#(1)부서별 평균월급
select  department_id,
		avg(salary) salary 
from employees
group by department_id
;

#(2)평균 월급이 가장 높은 부서의 평균 -> 19333.333333
select max(a.salary)
from (select department_id,
			 avg(salary) salary 
	  from employees
	  group by department_id
	 ) a
;

#(3)직원별테이블에 각각의 직원이 속한 부서의 평균월급 추가
select *
from employees emp, (select  department_id,
							 avg(salary) avgSalary 
       				 from employees
					 group by department_id) avt
where emp.department_id = avt.department_id
;

#(4)위의 테이블에서 avgSalary 가 19333.333333(평균월급이 가장높은) 인 것만 가져오기
select 	emp.employee_id 사번,
		emp.first_name 이름,
        emp.last_name 성,
        j.job_title 업무,
        emp.salary 월급,
	    avt.avgSalary 부서별평균월급,
        avt.department_id 부서아이디
from employees emp, 
     (select  department_id,
	  avg(salary) avgSalary 
      from employees
	  group by department_id) avt,
     jobs j
where emp.department_id = avt.department_id
and emp.job_id = j.job_id
and avt.avgSalary = (select max(a.avgSalary)
					 from (select department_id,
								 avg(salary) avgSalary 
					  	   from employees
						   group by department_id
						  ) a
					)
;


/*
문제8.
평균 월급(salary)이 가장 높은 부서명과 월급은? (limt사용하지 말고 그룹함수 사용할 것)
*/

#(1): 부서별 평균월급
select  department_id,
		avg(salary) salary 
from employees
group by department_id
;

#(2): 평균 월급이 가장 높은 부서의 평균 -> 19333.333333
select max(a.salary) maxSalary
from (select department_id,
			 avg(salary) salary 
	  from employees
	  group by department_id
	 ) a
;

#(3): (1)테이블에서 (2)의 조건(19333.333333)인것만 가져오기
select 	avt.salary,
        avt.department_id
from (select  department_id,
			  avg(salary) salary 
   	  from employees
	  group by department_id) avt
where avt.salary = (select max(a.salary) maxSalary
					from (select department_id,
							     avg(salary) salary 
						  from employees
						  group by department_id) a -- 19333.333333
				  )
;

#(4): 부서명 출력을 위해 departments 테이블과 조인
select 	de.department_name,
        avt.salary,
        avt.department_id -- 확인용으로 남겨둠
from (select  department_id,
			  avg(salary) salary 
   	  from employees
	  group by department_id
      ) avt
inner join departments de on avt.department_id = de.department_id
where avt.salary = (select max(a.salary) maxSalary
					from (select department_id,
							     avg(salary) salary 
						  from employees
						  group by department_id) a -- 19333.333333
				  )
;

/*
문제9.
평균 월급(salary)이 가장 높은 지역과 평균월급은?( limt사용하지 말고 그룹함수 사용할 것)
*/
#(1): 지역까지 출력한 테이블을 만든다
select *
from employees e, departments d, locations l, countries c, regions r
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and c.region_id = r.region_id
;
#(2): (1)의 데이터를 테이블로 놓고 지역아이디를 중심으로 평균월급을 구한다
select 	avg(rt.salary) avgSalary,
		rt.region_id
from (  select 	e.employee_id,
				e.salary,
                d.department_id,
                l.location_id,
                c.country_id,
                r.region_id,
                r.region_name
		from employees e, departments d, locations l, countries c, regions r
		where e.department_id = d.department_id
		and d.location_id = l.location_id
		and l.country_id = c.country_id
		and c.region_id = r.region_id
     ) rt
group by rt.region_id
;     


#(3): (2)번테이블에서 max값을 구한다
select max(avt.avgSalary)
from (select avg(rt.salary) avgSalary,
			 rt.region_id
		from (  select 	e.employee_id,
						e.salary,
						d.department_id,
						l.location_id,
						c.country_id,
						r.region_id
				from employees e, departments d, locations l, countries c, regions r
				where e.department_id = d.department_id
				and d.location_id = l.location_id
				and l.country_id = c.country_id
				and c.region_id = r.region_id
			 ) rt
		group by rt.region_id) avt
;


#(4): (2)와 (3)을 조인해서 평균이 제일크면서 region_id을 알아낸다  
 -- region_id 꺼자 있는 (2)번테이블에서 큰값을 찾는다 *limit를 안써서 복잡
 -- 최대평균,  지역번호     

select 	lt.avgSalary,
		lt.region_id
from (
		select 	avg(rt.salary) avgSalary,
				rt.region_id
		from (  select 	e.employee_id,
						e.salary,
						d.department_id,
						l.location_id,
						c.country_id,
						r.region_id,
						r.region_name
				from employees e, departments d, locations l, countries c, regions r
				where e.department_id = d.department_id
				and d.location_id = l.location_id
				and l.country_id = c.country_id
				and c.region_id = r.region_id
			 ) rt
		group by rt.region_id
     ) lt,
     (
		select max(avt.avgSalary) maxSalary
		from (select avg(rt.salary) avgSalary,
					 rt.region_id
				from (  select 	e.employee_id,
								e.salary,
								d.department_id,
								l.location_id,
								c.country_id,
								r.region_id
						from employees e, departments d, locations l, countries c, regions r
						where e.department_id = d.department_id
						and d.location_id = l.location_id
						and l.country_id = c.country_id
						and c.region_id = r.region_id
					 ) rt
				group by rt.region_id) avt
     ) rt
where lt.avgSalary = rt.maxSalary
;

#(5): (4)번테이블에 지역명을 위해 region테이블을 조인한다
select 	lt.avgSalary,
		lt.region_id, -- 참고용
        r.region_name
from (
		select 	avg(rt.salary) avgSalary,
				rt.region_id
		from (  select 	e.employee_id,
						e.salary,
						d.department_id,
						l.location_id,
						c.country_id,
						r.region_id,
						r.region_name
				from employees e, departments d, locations l, countries c, regions r
				where e.department_id = d.department_id
				and d.location_id = l.location_id
				and l.country_id = c.country_id
				and c.region_id = r.region_id
			 ) rt
		group by rt.region_id
     ) lt,
     (
		select max(avt.avgSalary) maxSalary
		from (select avg(rt.salary) avgSalary,
					 rt.region_id
				from (  select 	e.employee_id,
								e.salary,
								d.department_id,
								l.location_id,
								c.country_id,
								r.region_id
						from employees e, departments d, locations l, countries c, regions r
						where e.department_id = d.department_id
						and d.location_id = l.location_id
						and l.country_id = c.country_id
						and c.region_id = r.region_id
					 ) rt
				group by rt.region_id) avt
     ) rt,
     regions r
where lt.avgSalary = rt.maxSalary
and lt.region_id = r.region_id
;




/*
문제10.
평균 월급(salary)이 가장 높은 업무와 평균월급은? (limt사용하지 말고 그룹함수 사용할 것)
*/

#(1): 업무별 평균월급을 구한다
select 	job_id,
		avg(salary) avgSalary
from employees
group by job_id
;

#(2): (1)번에서 가장 높은 평균월급을 구한다 --> 업무별 가장높은 평균월급(어느업무인지는 알수없다)
select max(avgSalary)
from (select job_id,
			 avg(salary) avgSalary
	  from employees
	  group by job_id
	 ) avt
;

#(3): (1)번과 (2)번 테이블을 조인하여 job_id까지 알아낸다
select  lt.job_id,
		lt.avgSalary
from (select job_id,
			 avg(salary) avgSalary
	  from employees
      group by job_id
     ) lt,
     (select max(avgSalary) maxSalary
	  from (select job_id,
		   		   avg(salary) avgSalary
		    from employees
		    group by job_id
		   ) avt
     ) rt
where lt.avgSalary = rt.maxSalary      
;     
	
#(4): job_name을 알기위해 (3)번테이블과 jobs테이블을 조인한다
select  jo.job_title,
		lt.job_id, -- 참고용
		lt.avgSalary
from (select job_id,
			 avg(salary) avgSalary
	  from employees
      group by job_id
     ) lt,
     (select max(avgSalary) maxSalary
	  from (select job_id,
		   		   avg(salary) avgSalary
		    from employees
		    group by job_id
		   ) avt
     ) rt,
     jobs jo
where lt.avgSalary = rt.maxSalary
and lt.job_id = jo.job_id
