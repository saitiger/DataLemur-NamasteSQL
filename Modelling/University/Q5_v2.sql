Database Used --> Oracle using Livesql

Create table instructor (InstructorID Integer, F_NAME Varchar(15) , Subject Varchar(20));

insert into instructor values( 101, 'Saty R.', 'Java');
insert into instructor values( 101, 'Saty R.', 'Python');
insert into instructor values( 101, 'Saty R.', 'Javascript');
insert into instructor values( 121, 'Sai Raina', 'Java');
insert into instructor values( 201, 'Prakhar Joshi', 'Python');
insert into instructor values( 201, 'Prakhar Joshi', 'SQL'); /* Python, Java , Javascript are the subjects of interest this value is potential hinderance to the query and needs to be filtered out */
insert into instructor values( 202, 'Amol Mathur', 'Python');
insert into instructor values( 202, 'Amol Mathur', 'Java');
insert into instructor values( 202, 'Amol Mathur','Javascript');


create table SubjectInt(Subject_name varchar(20)); /* Subjects of Interest */

insert into SubjectInt values ('Java');
insert into SubjectInt values ('Python');
insert into SubjectInt values ('Javascript');

select F_name from instructor as x
where not exists 
(
select SubjectInt.Subject_name from SubjectInt
except
select x.F_name from instructor as y where x.Subject = y.Subject);

Working --> Implemented divide from relational algebra (Codd's operation) to find those values that are found in the dividend table are also existent in the divisor. I have divided instructor table by subjectint table.

select F_name from instructor returns names of all instructors 
not exists will check the subquery for the non existence of the query written in the paranthesis. 

the query written inside the paranthesis returns those subjects which are not present in the second half of the query but present only in the first half as I have used the except keyword to restrict the rows. Since instructor contains all instances of subjects of interest this means we get nothing.

Returing to the outer query we now have select F_name from instructor as x where not exists which will remove the non desirable row with subject SQL.