-- ----------------------------------------------------
-- web 계정 - 01 (기본테이블, insert문 중심)
-- ----------------------------------------------------

-- #테이블 만들기
create table book(
	book_id int, 
    title varchar(50), 
    author varchar(20), 
    pub_date datetime
);

-- #테이블에 컬럼 추가
alter table book add pub varchar(50);


-- #테이블에 컬럼 수정
alter table book modify title varchar(100);   -- varchar(50) --> varchar(100)
alter table book rename column title to subject;

-- #테이블에 컬럼 삭제
alter table book drop author;

-- #테이블 이름 수정
rename table book to article;

-- #테이블 삭제
drop table article;

select * from article;


-- #작가 테이블 만들기
create table author(
	author_id 	int 		 primary key,  
    author_name varchar(100) not null,
    author_desc varchar(500)
);

-- #작가 데이터 insert
-- insert 문
/*
insert into author(author_id, author_name, author_desc)
values(1, '박경리', '토지작가');
*/
insert into author 
values(1, '박경리', '토지작가');

insert into author     -- 오류
values(2, '이문열');   -- 컬럼수와 데이터 수가 맞지 않음 

insert into author         -- 데이터 갯수를 맞쳐야 함
values(2, '이문열', '');   -- 작가설명에 '' 가짜글자 데이터를 입력한것임

insert into author          -- 데이터 갯수를 맞쳐야 함
values(6, '박명수', null);  -- 작가설명에 null 실제데이터가 없는값

insert into author
values(3, '황일영', '강사');

-- 컬럼 명을 표시하면 데이터가 컬럼명과 일치해야 한다
insert into author(author_id, author_name)   -- 정상
values(4, '정우성');

insert into author(author_id, author_desc)   -- 오류 author_name --> not null   
values(5, '런닝맨');                         -- author_name 데이터가 꼭 있어야 한다  

insert into author(author_name, author_desc) -- 오류 author_id --> pk (unique + not null)   
values('유재석', '런닝맨');                  -- author_id 데이터가 꼭 있어야 한다(유니크해야한다)  

insert into author(author_desc, author_name, author_id)   -- 나열한 커럼명의 순서대로 
values('제주도', '이효리', 5);                            -- 데이터를 나열해야 한다

select *
from author
;

-- 
-- #책 테이블 만들기
create table book(      
	book_id		int				primary key,
    title 		varchar(100) 	not null,
    pub 		varchar(100),
    pub_date 	datetime
);

-- 다양한 insert문으로 데이터 넣어보기


select *
from book
;

