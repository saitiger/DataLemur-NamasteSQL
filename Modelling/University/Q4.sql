Database Used --> Oracle using Livesql

CREATE TABLE Salary
(InstructorID INTEGER NOT NULL,
Ins_name Varchar(20) NOT NULL,
Teaching_rate INTEGER NOT NULL ,
Supervision_rate INTEGER NOT NULL);

CREATE TABLE Instructor
(InstructorID INTEGER NOT NULL ,
Ins_Name VARCHAR(10) NOT NULL,
Teaching_time INTEGER NOT NULL ,
Supervision_time INTEGER NOT NULL,
Subject VARCHAR(15) NOT NULL,
Class_strength INTEGER NOT NULL);


insert into Salary values (101,'Saty',15,20);
insert into Salary values (121, 'Sai',15,20);


insert into Instructor values (121, 'Sai' , 35, 40, 'Javascript', 90);
insert into Instructor values (121, 'Sai', 40, 20, 'Java', 52);
insert into Instructor values (101, 'Saty', 10, 34, 'Python', 200);
insert into Instructor values (101, 'Saty', 20, 5, 'Javascript', 2);


select Instructor.Ins_name,Instructor.InstructorID, sum(Class_strength) * 0.1 * Salary.Teaching_rate as Bonus from salary join instructor on salary.InstructorID = Instructor.InstructorID group by (Instructor.InstructorID, Salary.Teaching_rate,Instructor.Ins_name) order by Bonus desc limit 1;

/* Join is used to fetch value of teaching rate from one table and the value of the aggregate function on class strength from the other table and limit 1 will stop the query at the first row returned which is highest since we have choosen descending order.*/
