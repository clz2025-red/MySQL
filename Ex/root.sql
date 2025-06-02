-- ----------------------------------------------------
-- root계정
-- ----------------------------------------------------

-- #계정만들기
-- 모든곳에서 접속가능
create user 'web'@'%' identified by '1234';

-- localhost에서만 접속가능
create user 'web'@'localhost' identified by '1234';

-- 192.168.0.122에서만 접속가능
create user 'web'@'192.168.0.122' identified by '1234';

-- #계정 비번변경
alter user 'web'@'%' identified by 'web';

/*
mysql -uweb -p   
---> 'web'@'192.168.0.122' 로그인 하는거다
---> 로그인우선순위  'web'@'192.168.0.122'   >   'web'@'localhost'  >  'web'@'%' 
*/

-- #계정 삭제
drop user 'web'@'192.168.0.122';
drop user 'web'@'localhost';
drop user 'web'@'%';

-- #계정 조회
use mysql;

select user, host 
from user
;

-- -------------------------------------------------------
-- #데이터베이스(스키마) 만들기
create database web_db   
	default character set utf8mb4
    collate utf8mb4_general_ci
    default encryption='n'
;

-- #데이터베이스(스키마) 삭제
drop database web_db;

-- #데이터베이스 조회
show databases;

-- #데이터베이스 선택
use web_db;


-- ----------------------------------------------
-- #권한부여
-- 'web'@'%' 계정이 web_db(데이타베이스)의 모든 테이블에 모든 권한 부여
grant all privileges on web_db.* to 'web'@'%';
flush privileges;

-- 'web'@'%' 계정이 hr_db(데이타베이스)의 employees 테이블에 select,insert 권한 부여
grant select,insert on hr_db.employees to 'web'@'%' ;
flush privileges;

-- 계정을 생성하거나 권한을 수정한 후, 변경된 권한을 즉시 적용하고자 할 때
flush privileges;

