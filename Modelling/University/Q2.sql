Database Used --> Oracle using Livesql

CREATE TABLE Enrollment
(SID INTEGER NOT NULL ,
ClassName CHAR(20) NOT NULL ,
Grade CHAR(2) NOT NULL);

insert into Enrollment values (122, 'Javascript', 'A');
insert into Enrollment values (122, 'Python' , 'B');
insert into Enrollment values (122, 'Ruby', 'A');
insert into Enrollment values (112, 'Javascript', 'C');
insert into Enrollment values (112, 'Python', 'C');
insert into Enrollment values (154, 'Python', 'C');
insert into Enrollment values (354, 'Javascript', 'C');
insert into Enrollment values (354, 'Python', 'A');
insert into Enrollment values (100, 'Javascript', 'A');

select * from Enrollment ;

select CLASSNAME, count(CLASSNAME) as Total from Enrollment group by CLASSNAME order by Total desc, ClassName asc ; /* The query will return the subject with highest count first and in case of tie in count the tiebreaker will be the first letter of Classname and they will be sorted in an ascending order.*/
