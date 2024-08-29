Database Used --> Oracle using Livesql

create table Prj_status (PID Char(4) Not Null , Step Integer Not Null , Status Char(1));

insert into Prj_status values ('P100', 0 , 'C');
insert into Prj_status values ('P100', 1 , 'W');
insert into Prj_status values ('P100', 2 , 'W');
insert into Prj_status values ('P101',0,'W'); 
insert into Prj_status values ('P200',0,'C');  /* Inserted to check if query runs correctly for Project with only step*/
insert into Prj_status values ('P201', 0 , 'C');
insert into Prj_status values ('P201', 1 , 'C');
insert into Prj_status values ('P333', 0 , 'W');
insert into Prj_status values ('P333', 1 , 'W');
insert into Prj_status values ('P333', 2 , 'W');
insert into Prj_status values ('P333', 3 , 'W');


select PID from Prj_status where Status = 'C' group by PID having count(Status) = 1; 

/* count(status) = 1 ensures that for those entries with status = 'C' will have only one row with status ='C' because if count becomes two then two rows of a corresponding project will have the value C in the column status. */