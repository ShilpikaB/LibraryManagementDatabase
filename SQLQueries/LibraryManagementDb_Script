/*---
drop table Account;
drop table Merchandise;
drop table Transaction;
drop table Book;
drop table Audiobook;
drop table DVD;
drop table eBook;
*/

CREATE TABLE IF NOT EXISTS Account(
userID INT AUTO_INCREMENT,
username VARCHAR(20) UNIQUE NOT NULL,
first_name VARCHAR(20) NOT NULL,
last_name VARCHAR(20) NOT NULL,
email VARCHAR(32) NOT NULL,
phone VARCHAR(15),
userpwd varchar(100) default 'test_userpwd',
status VARCHAR(10) NOT NULL,
PRIMARY KEY (userID),
UNIQUE INDEX email_UNIQUE (email ASC)
);


CREATE TABLE  IF NOT EXISTS Merchandise(
mid  INT NOT NULL,
category varchar(100) not null,
genre VARCHAR(100) NOT NULL,
language VARCHAR(20) NOT NULL,
title VARCHAR(500) NOT NULL,
ownerID integer not null,
date_published DATETIME NOT NULL,
price FLOAT NOT NULL,
latest_date_updated DATETIME,
PRIMARY KEY(mid),
FOREIGN KEY (ownerID) REFERENCES Account (userID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS Transaction (
  tid int(11) NOT NULL AUTO_INCREMENT,
  transaction_date datetime NOT NULL,
  due_date datetime NOT NULL,
  borrower_userID int(11) NOT NULL,
  lender_userID int(11) NOT NULL,
  mid int(11) NOT NULL,
  return_date datetime,
  PRIMARY KEY (tid),
  FOREIGN KEY (borrower_userID) REFERENCES Account (userID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (lender_userID) REFERENCES Account (userID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (mid) REFERENCES Merchandise (mid) ON DELETE CASCADE ON UPDATE CASCADE
) ;


CREATE TABLE  IF NOT EXISTS Book(
mid  INT NOT NULL,
edition VARCHAR(20),
author  VARCHAR(500),
status VARCHAR(10),
copies_available INT NOT NULL DEFAULT 1,
PRIMARY KEY(mid),
FOREIGN KEY (mid) REFERENCES Merchandise(mid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE  IF NOT EXISTS Audiobook(
mid  INT NOT NULL,
edition VARCHAR(20),
author  VARCHAR(500),
voice VARCHAR(500),
duration VARCHAR(100),
PRIMARY KEY(mid),
FOREIGN KEY (mid) REFERENCES Merchandise(mid)
);


CREATE TABLE  IF NOT EXISTS DVD(
mid  INT NOT NULL,
edition VARCHAR(20),
duration VARCHAR(100),
resolution VARCHAR(20),
production_studio VARCHAR(500),
copies_available INT NOT NULL DEFAULT 1,
PRIMARY KEY(mid),
FOREIGN KEY (mid) REFERENCES Merchandise(mid)
);


CREATE TABLE  IF NOT EXISTS eBook(
mid  INT NOT NULL,
edition VARCHAR(20),
author  VARCHAR(500),
PRIMARY KEY(mid),
FOREIGN KEY (mid) REFERENCES Merchandise(mid)
);

/*------------ INDEXES ---------------*/

create index merTitle on Merchandise(title);
show indexes from Merchandise;

create index bookAuthor on Book(author);
show indexes from Book;

create index audiobookAuthor on Audiobook(author);
show indexes from Audiobook;

create index ebookAuthor on eBook(author);
show indexes from eBook;

create index dvdProduction on DVD(production_studio);
show indexes from DVD;
/*---------------------------------*/
/* --------- Look Ups--------------- */

-- Borrower's lookup
select acc.first_name, acc.last_name, 'Borrowed' Transaction_type, mer.category, mer.title, tx.due_date
from Account acc, Transaction tx, Merchandise mer
where tx.mid = mer.mid
and mer.mid = tx.mid
and acc.userID = tx.borrower_userID;

-- Lender's lookup
select acc.first_name, acc.last_name, 'Lended' Transaction_type, mer.category, mer.title, tx.due_date
from Account acc, Transaction tx, Merchandise mer
where tx.mid = mer.mid
and mer.mid = tx.mid
and acc.userID = tx.lender_userID;

/* ------------------------------- */

-- List of various Merchandise types. These values need to show up in the UI as dropdown ---
select distinct lower(category)
from Merchandise
group by category;

/* ------------------- When making a Transaction -----------------------*/
-- First check for what category of Merchandise is the transaction for.
-- If the transaction is for Books or DvDs then before inserting values into the Transaction table check the # of copies available
-- in the Book and DVD tables.

select * from 
(select bk.mid, bk.author, mer.title, bk.status, bk.copies_available, mer.ownerID, mer.language 'Language', mer.price
from Book bk, Merchandise mer
where bk.mid = mer.mid and
mer.category = 'book' and
lower(mer.title) like '%harry%'
union
select bk.mid, bk.author, mer.title, bk.status, bk.copies_available, mer.ownerID, mer.language 'Language', mer.price
from Book bk, Merchandise mer
where bk.mid = mer.mid and
mer.category = 'book' and
lower(bk.author) like '%rowling%')A
order by price asc;


select * from 
(select dv.mid, dv.production_studio, mer.title, dv.copies_available, mer.ownerID, mer.language 'Language', mer.price
from DVD dv, Merchandise mer
where mer.category = 'dvd' and
dv.mid = mer.mid and
lower(mer.title) like '%harry%'
union
select dv.mid, dv.production_studio, mer.title, dv.copies_available, mer.ownerID, mer.language 'Language', mer.price
from DVD dv, Merchandise mer
where mer.category = 'dvd' and
dv.mid = mer.mid and
lower(dv.production_studio) like '%harry%') A
order by A.price;


/* ------- If due date is over then levy fine -------- */
select acc.first_name, acc.last_name, tx.tid, 
case
when tx.return_date is null then datediff(DATE_ADD(sysdate(), INTERVAL 1 DAY) , due_date) * .25 
else datediff(DATE_ADD(tx.return_date, INTERVAL 1 DAY) , due_date) * .25 
end as Total_late_fee
from Transaction tx, Account acc
where -- borrower_userID = 23705 and 
tx.due_date < sysdate()
and acc.userID = tx.borrower_userID;

/* -------------------- Search Query ----------------------------*/
select * from (
-- Books
select mer.mid, mer.category, bk.author 'Author or Production Studio', 
	   mer.title, convert(bk.copies_available, char) copies_available, 
       mer.language 'Language', mer.price
from Book bk, Merchandise mer
where bk.mid = mer.mid and
mer.category = 'book' and
lower(mer.title) like '%harry%'
union
select mer.mid, mer.category, bk.author 'Author or Production Studio', 
	   mer.title, convert(bk.copies_available, char) copies_available, 
       mer.language 'Language', mer.price
from Book bk, Merchandise mer
where bk.mid = mer.mid and
mer.category = 'book' and
lower(bk.author) like '%rowling%'
union

-- DVDs
select mer.mid, mer.category, dv.production_studio 'Author or Production Studio', 
       mer.title, convert(dv.copies_available, char) copies_available,  
       mer.language 'Language', mer.price
from DVD dv, Merchandise mer
where mer.category = 'dvd' and
dv.mid = mer.mid and
lower(mer.title) like '%harry%'
union
select mer.mid, mer.category, dv.production_studio 'Author or Production Studio',
       mer.title, convert(dv.copies_available, char) copies_available,  
       mer.language 'Language', mer.price
from DVD dv, Merchandise mer
where mer.category = 'dvd' and
dv.mid = mer.mid and
lower(dv.production_studio) like '%harry%'
union

-- AudioBooks (NOTE: Copies avaiable for AudioBooks and eBooks should be translated to NA)
select mer.mid, mer.category, ab.author 'Author or Production Studio', 
	   mer.title, 'NA' copies_available,  
       mer.language 'Language', mer.price
from Audiobook ab, Merchandise mer
where ab.mid = mer.mid and
mer.category = 'audiobook' and
lower(mer.title) like '%harry%'
union
select mer.mid, mer.category, ab.author 'Author or Production Studio', 
	   mer.title, 'NA' copies_available, 
       mer.language 'Language', mer.price
from Audiobook ab, Merchandise mer
where ab.mid = mer.mid and
mer.category = 'audiobook' and
lower(ab.author) like '%rowling%'
union

-- eBooks
select mer.mid, mer.category, eb.author 'Author or Production Studio', 
	   mer.title, 'NA' copies_available,  
       mer.language 'Language', mer.price
from eBook eb, Merchandise mer
where eb.mid = mer.mid and
mer.category = 'ebook' and
lower(mer.title) like '%harry%'
union
select mer.mid, mer.category, eb.author 'Author or Production Studio', 
	   mer.title, 'NA' copies_available,  
       mer.language 'Language', mer.price
from eBook eb, Merchandise mer
where eb.mid = mer.mid and
mer.category = 'ebook' and
lower(eb.author) like '%rowling%')A
order by A.price;

/*------------------------------------------*/
--  Before inserting into a new record into the Transaction table, if transaction is for a book, then decrement the
-- # of copies available in the Book table.
select * from Book 
where mid = 10551;

update Book
set copies_available = copies_available - 1
where mid = 10551 and copies_available > 0;

select * from Book 
where mid = 10551;


--  Before inserting into a new record into the Transaction table, if transaction is for a dvd, then decrement the
-- # of copies available in the DVD table.

select * from DVD 
where mid = 10551;

update DVD
set copies_available = copies_available - 1
where mid = 10551 and copies_available > 0;

select * from DVD 
where mid = 10551;

/*---------------------------------- */
-- When a merchandise is returned then after updating the Transaction table, if the merchandise was a book or a dvd, 
-- then update the copies available count accordingly.
select mer.category ,tx. * 
from Transaction tx, Merchandise mer
where mer.mid  = tx.mid
and  -- tid = 100004 and
mer.category in ('book', 'dvd')
and tx.return_date is NULL;

update Transaction
set return_date = sysdate()
where tid = 100004;

select * from Book 
where mid = 10552;

update Book
set copies_available = copies_available + 1
where mid = 10552;

select * from Book 
where mid = 10552;


--  Before inserting into a new record into the Transaction table, if transaction is for a dvd, then decrement the
-- # of copies available in the DVD table.

select * from DVD 
where mid = 26276;

update DVD
set copies_available = copies_available + 1
where mid = 26276;

select * from DVD 
where mid = 26276;

/* ------------------------------------*/
-- View of the Transaction table for lender
create  view LenderViewFromTransaction as
select acc.userID, concat(acc.first_name,' ', acc.last_name) lender_name, mer.category, mer.mid, 
		datediff(tx.due_date,tx.transaction_date) 'item_due in # days',
        mer.title, tx.due_date 
from Transaction tx, Merchandise mer, Account acc
where mer.mid  = tx.mid
and acc.userID = tx.lender_userID
and tx.return_date is NULL 
-- and acc.userID in (20820)
order by datediff(tx.due_date,tx.transaction_date) asc, mer.category; 

-- View of the Transaction table for borrower
create  view BorrowerViewFromTransaction as
select acc.userID, concat(acc.first_name,' ', acc.last_name) lender_name, mer.category, mer.mid, 
		datediff(tx.due_date,tx.transaction_date) 'item_due in # days',
        mer.title, tx.due_date, tx.transaction_date
from Transaction tx, Merchandise mer, Account acc
where mer.mid  = tx.mid
and acc.userID = tx.borrower_userID
and tx.return_date is NULL 
-- and acc.userID in (20820)
order by datediff(tx.due_date,tx.transaction_date) asc, mer.category;
