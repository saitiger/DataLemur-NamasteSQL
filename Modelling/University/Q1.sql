Database Used --> Oracle using Livesql

CREATE TABLE ProjectRoomBookings
(roomNum INTEGER NOT NULL,
startTime INTEGER NOT NULL ,
endTime INTEGER NOT NULL,
groupName CHAR(10) NOT NULL ,
PRIMARY KEY (roomNum,groupName),
Check ( startTime < endTime)
);

insert into ProjectRoomBookings values (1, 6, 17, 5);
insert into ProjectRoomBookings values (2, 4, 2 , 2); /* Having endTime before the start time violates the check constrait and hence this entry won't be entered in the table*/

select * from ProjectRoomBookings;

delete from ProjectRoomBookings where startTime > endTime; /* This statement will remove wrong entries that are there in the database before changes to the schema were made*/

/* The change in database design for occupied rooms is to create another table availability which indicates the status of room an any point of time and then join it with ProjectRoomBookings table. The solution will require manual entry but ensures no occupied room is assigned.*/