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












Den 얼마받는지  11000

11000 이상 받는 사람을 조회


	114	Den	Raphaely	DRAPHEAL	515.127.4561	2002-12-07	PU_MAN	11000.00		100	30
	148	Gerald	Cambrault	GCAMBRAU	011.44.1344.619268	2007-10-15	SA_MAN	11000.00	0.30	100	80
	174	Ellen	Abel	EABEL	011.44.1644.429267	2004-05-11	SA_REP	11000.00	0.30	149	80
	168	Lisa	Ozer	LOZER	011.44.1343.929268	2005-03-11	SA_REP	11500.00	0.25	148	80
	147	Alberto	Errazuriz	AERRAZUR	011.44.1344.429278	2005-03-10	SA_MAN	12000.00	0.30	100	80
	108	Nancy	Greenberg	NGREENBE	515.124.4569	2002-08-17	FI_MGR	12008.00		101	100
	205	Shelley	Higgins	SHIGGINS	515.123.8080	2002-06-07	AC_MGR	12008.00		101	110
	201	Michael	Hartstein	MHARTSTE	515.123.5555	2004-02-17	MK_MAN	13000.00		100	20
	146	Karen	Partners	KPARTNER	011.44.1344.467268	2005-01-05	SA_MAN	13500.00	0.30	100	80
	145	John	Russell	JRUSSEL	011.44.1344.429268	2004-10-01	SA_MAN	14000.00	0.40	100	80
	101	Neena	Kochhar	NKOCHHAR	515.123.4568	2005-09-21	AD_VP	17000.00		100	90
	102	Lex	De Haan	LDEHAAN	515.123.4569	2001-01-13	AD_VP	17000.00		100	90
	100	Steven	King	SKING	515.123.4567	2003-06-17	AD_PRES	24000.00			90