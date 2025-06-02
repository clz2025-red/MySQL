-- ----------------------------------------------------
-- web 계정
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
