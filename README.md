# 1 Background
This library relational database system comprises a virtual library with a lending and a borrowing system. The concept of a library involves borrowing books from an inventory. In this project users will be able to borrow/lend not only books, but also audiobooks, dvds, and ebooks (henceforth known as merchandise). These are the typical items one would expect to find a multi-faceted library.

This system allows users to lend their own merchandise to other members. Users can lend their merchandise for free or for a specified price. This library system will allow a user to have a user account and will enable the user to borrow/lend 4 types of merchandise:
- Books
- eBooks
- AudioBooks
- DVDs

# 2 Design & Implementation

Below figures represent the Entity Relationship (ER) Diagram and the database tables.
<div align="center">
<img src="https://user-images.githubusercontent.com/82466266/234407855-c6e84e18-af86-47f0-958c-1933670ce471.JPG" width=60% height=30%>
<img src="https://user-images.githubusercontent.com/82466266/234406826-17857c86-27d3-4cce-bca8-a98e8f90aa6a.png" width=35% height=70%></br>
</div>

The database is designed using MySQL Workbench 8.0. There are three main entities: 
- _Accounts_ (member)
- _Merchandise_
- _Transactions_

The _Account_ entity contains data required to register a member with this library system. Some attributes are <<_username, phone number, email_>> etc. This entity would be used to create a member profile page for the user on the website, and could also be used in case events or sales were to be organized for users under specific categories. 

The _Merchandise_ entity contains four sub-categories - _Books, AudioBooks, DVDs, and eBooks_. This table contains values that are shared among the sub-categories like the merchandise id, title, owner, etc. The merchandise id (_MID_) is unique for all the 4 sub-categories. For each of the sub-categories we have a separate table containing information about them. These separate tables link back to the merchandise table through their merchandise id. 

The _Transactions_ entity acts as a ledger that keeps track of a transaction which includes borrowing merchandise from our repository. This table primarily stores information like the merchandise id, borrower username, lender username, date of transaction, due dates, etc. The transaction table will help provide borrower and lender to snapshot of their respective transactions and will also help to calculate if any late fees are applicable. 

Several other relationships between the aforementioned entities are used to allow users to store information about their merchandise, borrow items, log and retrieve transaction information, update transactions, and much more.

### 2.1 Relational Schema (_Entities_)
- __Account__
{username: STRING, first_name: STRING, last_name: STRING, email: STRING, password: STRING, phone: INTEGER, member_since 
DATETIME, status STRING}
- __Transaction__
{tid INTEGER, transaction_date: DATETIME, due_date DATETIME, mid INTEGER}
- __Book__ 
{mid: INTEGER, genre: STRING, language: STRING, title: STRING, date_published: DATETIME, author: STRING, edition: FLOAT, 
copies_available: INTEGER, page_count: INTEGER, price: FLOAT, status: STRING, latest_date_updated: DATETIME, condition: STRING}
- __eBook__
{mid: INTEGER, genre: STRING, language: STRING, title: STRING, date_published: DATETIME, author: STRING, edition: FLOAT, 
page_count: INTEGER, price: FLOAT, status: STRING, latest_date_updated: DATETIME}
- __AudioBook__
{mid: INTEGER, genre: STRING, language: STRING, title: STRING, date_published: DATETIME, author: STRING, edition: FLOAT, voice: 
STRING, duration: INTEGER, price: FLOAT, status: STRING, latest_date_updated: DATETIME}
- __DVD__ 
{mid: INTEGER, genre: STRING, language: STRING, title: STRING, date_published: DATETIME, resolution: STRING, duration: INTEGER, 
copies_available: INTEGER, production_studio: STRING, price: FLOAT, status: STRING, latest_date_updated: DATETIME}

### 2.2 Relational Schema (_Relations_)
- __AccountOwnsMerchandise__ {mid: INTEGER, username: STRING, first_date_added: DATETIME}
- __AccountMakesTransaction__ {tid: INTEGER, borrower_username: STRING, lender_username: 
STRING}
- __TransactionContainsMerchandise__ {tid: INTEGER, mid: INTEGER}

### 2.3 Indexes
6 User defined indexes were created
- _merTitle_ on _Merchandise_
- _bookAuthor_ on _Book_
- _audiobookAuthor_ on _Audiobook_
- _ebookAuthor_ on _eBook_
- _dvdProduction_ on _DVD_
- _transactMerchandise_ on _Transaction_

All Non-clustered BTree Indexes

### 2.4 Views
2 Views were created
- _BorrowerViewFromTransaction_: A given borrower will see what open transactions are present for their borrowed Merchandise.
- _LenderViewFromTransaction_: A given lender will see what open transactions are present for lended Merchandise.

# 3 SQL Script (MySQL Workbench 8.0)
- Link: https://github.com/ShilpikaB/LibraryManagementDatabase/tree/main/SQLQueries
