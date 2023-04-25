CREATE PROCEDURE InsertIntoTransaction()
BEGIN
declare c1 cursor for 
select bor.userID bor_userID, 
	   lend.userID, 
       mer.mid merID
from Account bor, Account lend, Merchandise mer
where bor.userID<>lend.userID
and lend.userID=mer.ownerID;

declare c2 cursor for select mer.mid from Merchandise mer;
declare c3 cursor for select lend.userID from Account lend;
declare tid_val integer;
set tid_val = 100001;


open c1;
fetch c1 into; 

insert into Transaction values (tid_val, sysdate(), , bor_userID, lend_userID, merID);
tid_val = tid_val+1;


close c1;
close c2;
close c3;
END;
