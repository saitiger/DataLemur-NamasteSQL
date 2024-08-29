Database Used --> Oracle using Livesql

Create table instructor (InstructorID Integer, F_NAME Varchar(15) , Subject Varchar(20));

Create TABLE Salary
(InstructorID INTEGER NOT NULL,
Ins_name Varchar(20) NOT NULL,
Teaching_rate INTEGER NOT NULL ,
Supervision_rate INTEGER NOT NULL);

insert into Salary values (101,'Saty R.',15,20);
insert into Salary values (121, 'Sai Raina',15,20);
insert into Salary values (201,'Prakhar Joshi',15,20);
insert into Salary values (202, 'Amol Mathur',15,20);


insert into instructor values( 101, 'Saty R.', 'Java');
insert into instructor values( 101, 'Saty R.', 'Python');
insert into instructor values( 101, 'Saty R.', 'Javascript');
insert into instructor values( 121, 'Sai Raina', 'Java');
insert into instructor values( 201, 'Prakhar Joshi', 'Python');
insert into instructor values( 201, 'Prakhar Joshi', 'SQL');
insert into instructor values( 202, 'Amol Mathur', 'Python');
insert into instructor values( 202, 'Amol Mathur', 'Java');
insert into instructor values( 202, 'Amol Mathur','Javascript');

select F_name from instructor group by F_name,InstructorID having count(distinct(subject)) = 3 ; 

/* Distinct is to avoid duplicate entries from corrupting the output. */

/* This query works when the courses that are being offered are the same as the courses we are interested in checking for recruitment. The query fails if for instructor 201 we have some third entry since one of the subject taught by him is not the intended subject*/

/* To counter the above problem we use a separate table subject which maintains the record of the subjects we are interested in and then check two conditions : 1) Number of courses offered by professor + 3 and 2) The courses being taught align with our requirements by comparing with the second table*/

create table SubjectInt(Subject_name varchar(20)); /* Subjects of Interest */

insert into SubjectInt values ('Java');
insert into SubjectInt values ('Python');
insert into SubjectInt values ('Javascript');

select F_name from instructor join SubjectInt on instructor.Subject = SubjectInt.Subject_name group by instructor.InstructorId,instructor.F_name having count(distinct(SubjectInt.Subject_name)) = 3;


Working of Query --> The query will return F_name of instructors those who teach all three subjects. I have merged the rows having common F_name,InstructorId that is all instances of a single instructor will be merged into one row and then on the common row have used the aggregate function to count the number of subjects associated with the given instructor. The distinct keyword ensures that duplicate entries don't affect the result as it will take into consideration only those values which are different.