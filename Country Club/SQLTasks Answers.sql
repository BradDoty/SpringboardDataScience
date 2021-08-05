/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name FROM `Facilities` WHERE membercost > 0

Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court


/* Q2: How many facilities do not charge a fee to members? */

SELECT count(*) FROM `Facilities` WHERE  membercost = 0

4


/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance 
FROM `Facilities` WHERE  membercost > 0 and membercost < monthlymaintenance * 0.2
0 Tennis Court 1 5.0 200
1 Tennis Court 2 5.0 200
4 Massage Room 1 9.9 3000
5 Massage Room 2 9.9 3000
6 Squash Court 3.5 80


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

select * from facilities where facid in (1,5)
5
Massage Room 2
9.9
80.0
3000
4000

1
Tennis Court 2
5.0
25.0
200
8000



/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

select name, monthlymaintenance, 
CASE WHEN monthlymaintenance <= 100 THEN 'cheap'
     ELSE 'expensive' END As label
from Facilities 

Tennis Court 1
200
expensive

Tennis Court 2
200
expensive

Badminton Court
50
cheap

Table Tennis
10
cheap

Massage Room 1
3000
expensive

Massage Room 2
3000
expensive

Squash Court
80
cheap

Snooker Table
15
cheap

Pool Table
15
cheap



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

select firstname, surname from Members
where joindate = (select max(joindate) from Members)

Darren Smith



/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT F.name, concat(M.firstname, ' ', M.surname) AS name
FROM Bookings B 
INNER JOIN Facilities F on B.facid = F.facid
INNER JOIN Members M on B.memid = M.memid
where F.name like 'Tennis Court%'
  and M.memid != 0
ORDER BY name

Tennis Court 1
Anne Baker
Tennis Court 2
Anne Baker
Tennis Court 1
Burton Tracy
Tennis Court 2
Burton Tracy
Tennis Court 1
Charles Owen
Tennis Court 2
Charles Owen
Tennis Court 2
Darren Smith
Tennis Court 1
David Farrell
Tennis Court 2
David Farrell
Tennis Court 1
David Jones
Tennis Court 2
David Jones
Tennis Court 1
David Pinker
Tennis Court 1
Douglas Jones
Tennis Court 1
Erica Crumpet
Tennis Court 2
Florence Bader
Tennis Court 1
Florence Bader
Tennis Court 1
Gerald Butters
Tennis Court 2
Gerald Butters
Tennis Court 2
Henrietta Rumney
Tennis Court 2
Jack Smith
Tennis Court 1
Jack Smith
Tennis Court 1
Janice Joplette
Tennis Court 2
Janice Joplette
Tennis Court 1
Jemima Farrell
Tennis Court 2
Jemima Farrell
Tennis Court 1
Joan Coplin
Tennis Court 1
John Hunt
Tennis Court 2
John Hunt
Tennis Court 1
Matthew Genting
Tennis Court 2
Millicent Purview
Tennis Court 2
Nancy Dare
Tennis Court 1
Nancy Dare
Tennis Court 1
Ponder Stibbons
Tennis Court 2
Ponder Stibbons
Tennis Court 2
Ramnaresh Sarwin
Tennis Court 1
Ramnaresh Sarwin
Tennis Court 1
Tim Boothe
Tennis Court 2
Tim Boothe
Tennis Court 2
Tim Rownam
Tennis Court 1
Tim Rownam
Tennis Court 2
Timothy Baker
Tennis Court 1
Timothy Baker
Tennis Court 2
Tracy Smith
Tennis Court 1
Tracy Smith



/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT F.name, concat(M.firstname, ' ', M.surname) AS name,
   CASE WHEN M.memid = 0 THEN guestcost * B.slots
            ELSE membercost * B.slots END as tcost
FROM Bookings B
JOIN Facilities F USING (facid)
JOIN Members M USING (memid)
WHERE date(B.starttime) = '2012-09-14'
  AND CASE WHEN M.memid = 0 THEN guestcost * B.slots
            ELSE membercost * B.slots END > 30
ORDER BY tcost DESC

Massage Room 2
GUEST GUEST
320.0
Massage Room 1
GUEST GUEST
160.0
Massage Room 1
GUEST GUEST
160.0
Massage Room 1
GUEST GUEST
160.0
Tennis Court 2
GUEST GUEST
150.0
Tennis Court 1
GUEST GUEST
75.0
Tennis Court 2
GUEST GUEST
75.0
Tennis Court 1
GUEST GUEST
75.0
Squash Court
GUEST GUEST
70.0
Massage Room 1
Jemima Farrell
39.6
Squash Court
GUEST GUEST
35.0
Squash Court
GUEST GUEST
35.0


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT * FROM
( SELECT F.name AS room, concat(M.firstname, ' ', M.surname) AS name,
   CASE WHEN M.memid = 0 THEN guestcost * B.slots
            ELSE membercost * B.slots END as tcost
  FROM Bookings B
  JOIN Facilities F USING (facid)
  JOIN Members M USING (memid)
  WHERE date(B.starttime) = '2012-09-14') AS sub

WHERE tcost > 30  
ORDER BY tcost DESC




/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT F.name, 
           SUM( CASE WHEN memid = 0 THEN guestcost*slots
                ELSE membercost*slots END) AS cost
        FROM Facilities F
        JOIN Bookings B USING (facid)
        GROUP BY F.name
        HAVING cost < 1000
        ORDER BY cost

('Table Tennis', 180)
('Snooker Table', 240)
('Pool Table', 270)


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

 SELECT M1.surname || ', ' || M1.firstname AS memb,
               M2.surname || ', ' || M2.firstname AS rec_by
        FROM Members M1
        LEFT JOIN Members M2 ON M1.recommendedby = M2.memid
        WHERE M1.memid > 0
        ORDER BY memb, rec_by

('Bader, Florence', 'Stibbons, Ponder')
('Baker, Anne', 'Stibbons, Ponder')
('Baker, Timothy', 'Farrell, Jemima')
('Boothe, Tim', 'Rownam, Tim')
('Butters, Gerald', 'Smith, Darren')
('Coplin, Joan', 'Baker, Timothy')
('Crumpet, Erica', 'Smith, Tracy')
('Dare, Nancy', 'Joplette, Janice')
('Farrell, David', None)
('Farrell, Jemima', None)
('Genting, Matthew', 'Butters, Gerald')
('Hunt, John', 'Purview, Millicent')
('Jones, David', 'Joplette, Janice')
('Jones, Douglas', 'Jones, David')
('Joplette, Janice', 'Smith, Darren')
('Mackenzie, Anna', 'Smith, Darren')
('Owen, Charles', 'Smith, Darren')
('Pinker, David', 'Farrell, Jemima')
('Purview, Millicent', 'Smith, Tracy')
('Rownam, Tim', None)
('Rumney, Henrietta', 'Genting, Matthew')
('Sarwin, Ramnaresh', 'Bader, Florence')
('Smith, Darren', None)
('Smith, Darren', None)
('Smith, Jack', 'Smith, Darren')
('Smith, Tracy', None)
('Stibbons, Ponder', 'Tracy, Burton')
('Tracy, Burton', None)
('Tupperware, Hyacinth', None)
('Worthington-Smyth, Henry', 'Smith, Tracy')

/* Q12: Find the facilities with their usage by member, but not guests */

SELECT sub.name, M.surname || ", " || M.firstname AS name, hours
    FROM
        (SELECT F.name, M.memid, SUM(slots) / 2.0 AS hours
            FROM Bookings B
            JOIN Facilities F USING (facid)
            JOIN Members M USING (memid)
            WHERE M.memid != 0
            GROUP BY F.name, M.memid
            ORDER BY hours DESC) AS sub
    JOIN Members M USING (memid)

('Badminton Court', 'Smith, Darren', 216.0)
('Pool Table', 'Rownam, Tim', 141.0)
('Massage Room 1', 'Rownam, Tim', 88.0)
('Tennis Court 1', 'Butters, Gerald', 85.5)
('Tennis Court 2', 'Boothe, Tim', 84.0)
('Table Tennis', 'Rownam, Tim', 75.0)
('Snooker Table', 'Joplette, Janice', 71.0)
('Tennis Court 2', 'Owen, Charles', 70.5)
('Tennis Court 2', 'Baker, Anne', 57.0)
('Squash Court', 'Baker, Anne', 55.0)
('Badminton Court', 'Smith, Tracy', 51.0)
('Tennis Court 2', 'Jones, David', 49.5)
('Badminton Court', 'Mackenzie, Anna', 48.0)
('Tennis Court 2', 'Stibbons, Ponder', 48.0)
('Pool Table', 'Baker, Timothy', 47.5)
('Tennis Court 1', 'Smith, Tracy', 46.5)
('Tennis Court 1', 'Tracy, Burton', 46.5)
('Snooker Table', 'Smith, Tracy', 45.0)
('Snooker Table', 'Boothe, Tim', 45.0)
('Table Tennis', 'Bader, Florence', 43.0)
('Tennis Court 1', 'Jones, David', 42.0)
('Pool Table', 'Mackenzie, Anna', 41.5)
('Tennis Court 1', 'Dare, Nancy', 40.5)
('Squash Court', 'Tracy, Burton', 39.0)
('Massage Room 1', 'Boothe, Tim', 38.0)
('Tennis Court 1', 'Smith, Jack', 37.5)
('Snooker Table', 'Butters, Gerald', 36.0)
('Massage Room 1', 'Farrell, Jemima', 34.0)
('Massage Room 1', 'Butters, Gerald', 33.0)
('Snooker Table', 'Bader, Florence', 33.0)
('Pool Table', 'Smith, Tracy', 32.0)
('Badminton Court', 'Butters, Gerald', 31.5)
('Massage Room 1', 'Tracy, Burton', 31.0)
('Massage Room 1', 'Smith, Darren', 29.0)
('Tennis Court 1', 'Joplette, Janice', 28.5)
('Tennis Court 2', 'Smith, Darren', 28.5)
('Table Tennis', 'Smith, Darren', 28.0)
('Table Tennis', 'Smith, Tracy', 28.0)
('Massage Room 1', 'Smith, Jack', 27.0)
('Table Tennis', 'Genting, Matthew', 27.0)
('Massage Room 1', 'Genting, Matthew', 26.0)
('Tennis Court 1', 'Owen, Charles', 25.5)
('Tennis Court 1', 'Pinker, David', 25.5)
('Massage Room 1', 'Baker, Timothy', 25.0)
('Table Tennis', 'Owen, Charles', 25.0)
('Badminton Court', 'Stibbons, Ponder', 24.0)
('Table Tennis', 'Tracy, Burton', 24.0)
('Table Tennis', 'Baker, Timothy', 24.0)
('Snooker Table', 'Dare, Nancy', 23.0)
('Table Tennis', 'Coplin, Joan', 23.0)
('Tennis Court 1', 'Baker, Timothy', 22.5)
('Snooker Table', 'Owen, Charles', 22.0)
('Snooker Table', 'Farrell, Jemima', 22.0)
('Massage Room 1', 'Stibbons, Ponder', 20.0)
('Massage Room 1', 'Jones, David', 20.0)
('Snooker Table', 'Tracy, Burton', 20.0)
('Snooker Table', 'Stibbons, Ponder', 20.0)
('Massage Room 1', 'Dare, Nancy', 19.0)
('Pool Table', 'Worthington-Smyth, Henry', 18.5)
('Badminton Court', 'Boothe, Tim', 18.0)
('Badminton Court', 'Smith, Jack', 18.0)
('Snooker Table', 'Sarwin, Ramnaresh', 18.0)
('Tennis Court 2', 'Sarwin, Ramnaresh', 18.0)
('Table Tennis', 'Pinker, David', 17.0)
('Tennis Court 2', 'Dare, Nancy', 16.5)
('Snooker Table', 'Pinker, David', 16.0)
('Table Tennis', 'Mackenzie, Anna', 16.0)
('Badminton Court', 'Dare, Nancy', 15.0)
('Badminton Court', 'Baker, Anne', 15.0)
('Pool Table', 'Tracy, Burton', 15.0)
('Squash Court', 'Smith, Darren', 15.0)
('Squash Court', 'Joplette, Janice', 15.0)
('Pool Table', 'Smith, Darren', 14.0)
('Snooker Table', 'Rumney, Henrietta', 14.0)
('Badminton Court', 'Bader, Florence', 13.5)
('Pool Table', 'Joplette, Janice', 13.5)
('Tennis Court 1', 'Jones, Douglas', 13.5)
('Pool Table', 'Boothe, Tim', 13.0)
('Pool Table', 'Farrell, David', 12.5)
('Badminton Court', 'Jones, David', 12.0)
('Massage Room 1', 'Joplette, Janice', 12.0)
('Snooker Table', 'Smith, Darren', 12.0)
('Squash Court', 'Boothe, Tim', 12.0)
('Table Tennis', 'Farrell, Jemima', 12.0)
('Tennis Court 2', 'Joplette, Janice', 12.0)
('Tennis Court 2', 'Bader, Florence', 12.0)
('Pool Table', 'Bader, Florence', 11.5)
('Massage Room 1', 'Owen, Charles', 11.0)
('Squash Court', 'Smith, Jack', 11.0)
('Table Tennis', 'Jones, David', 11.0)
('Badminton Court', 'Farrell, Jemima', 10.5)
('Badminton Court', 'Baker, Timothy', 10.5)
('Badminton Court', 'Pinker, David', 10.5)
('Badminton Court', 'Sarwin, Ramnaresh', 10.5)
('Tennis Court 1', 'Coplin, Joan', 10.5)
('Tennis Court 2', 'Baker, Timothy', 10.5)
('Snooker Table', 'Coplin, Joan', 10.0)
('Pool Table', 'Dare, Nancy', 9.5)
('Badminton Court', 'Owen, Charles', 9.0)
('Pool Table', 'Genting, Matthew', 9.0)
('Squash Court', 'Butters, Gerald', 9.0)
('Table Tennis', 'Joplette, Janice', 9.0)
('Tennis Court 1', 'Rownam, Tim', 9.0)
('Tennis Court 1', 'Baker, Anne', 9.0)
('Tennis Court 1', 'Farrell, David', 9.0)
('Tennis Court 2', 'Rownam, Tim', 9.0)
('Massage Room 1', 'Sarwin, Ramnaresh', 8.0)
('Squash Court', 'Jones, David', 8.0)
('Squash Court', 'Farrell, Jemima', 8.0)
('Badminton Court', 'Worthington-Smyth, Henry', 7.5)
('Tennis Court 1', 'Sarwin, Ramnaresh', 7.5)
('Snooker Table', 'Mackenzie, Anna', 7.0)
('Squash Court', 'Owen, Charles', 7.0)
('Table Tennis', 'Purview, Millicent', 7.0)
('Pool Table', 'Sarwin, Ramnaresh', 6.5)
('Badminton Court', 'Rownam, Tim', 6.0)
('Massage Room 1', 'Smith, Tracy', 6.0)
('Pool Table', 'Stibbons, Ponder', 6.0)
('Pool Table', 'Baker, Anne', 6.0)
('Snooker Table', 'Tupperware, Hyacinth', 6.0)
('Squash Court', 'Smith, Tracy', 6.0)
('Tennis Court 1', 'Boothe, Tim', 6.0)
('Tennis Court 1', 'Hunt, John', 6.0)
('Tennis Court 2', 'Hunt, John', 6.0)
('Pool Table', 'Coplin, Joan', 5.5)
('Massage Room 2', 'Dare, Nancy', 5.0)
('Snooker Table', 'Smith, Jack', 5.0)
('Squash Court', 'Baker, Timothy', 5.0)
('Table Tennis', 'Dare, Nancy', 5.0)
('Table Tennis', 'Smith, Jack', 5.0)
('Pool Table', 'Pinker, David', 4.5)
('Pool Table', 'Tupperware, Hyacinth', 4.5)
('Tennis Court 2', 'Butters, Gerald', 4.5)
('Tennis Court 2', 'Tracy, Burton', 4.5)
('Massage Room 2', 'Jones, David', 4.0)
('Pool Table', 'Jones, David', 4.0)
('Table Tennis', 'Boothe, Tim', 4.0)
('Pool Table', 'Smith, Jack', 3.5)
('Badminton Court', 'Tracy, Burton', 3.0)
('Badminton Court', 'Jones, Douglas', 3.0)
('Badminton Court', 'Purview, Millicent', 3.0)
('Badminton Court', 'Hunt, John', 3.0)
('Badminton Court', 'Crumpet, Erica', 3.0)
('Massage Room 1', 'Baker, Anne', 3.0)
('Massage Room 1', 'Pinker, David', 3.0)
('Massage Room 1', 'Hunt, John', 3.0)
('Massage Room 2', 'Sarwin, Ramnaresh', 3.0)
('Pool Table', 'Butters, Gerald', 3.0)
('Squash Court', 'Pinker, David', 3.0)
('Table Tennis', 'Stibbons, Ponder', 3.0)
('Table Tennis', 'Sarwin, Ramnaresh', 3.0)
('Table Tennis', 'Worthington-Smyth, Henry', 3.0)
('Tennis Court 2', 'Smith, Tracy', 3.0)
('Pool Table', 'Purview, Millicent', 2.5)
('Massage Room 1', 'Crumpet, Erica', 2.0)
('Massage Room 2', 'Rownam, Tim', 2.0)
('Massage Room 2', 'Joplette, Janice', 2.0)
('Massage Room 2', 'Owen, Charles', 2.0)
('Massage Room 2', 'Baker, Anne', 2.0)
('Massage Room 2', 'Bader, Florence', 2.0)
('Massage Room 2', 'Coplin, Joan', 2.0)
('Snooker Table', 'Jones, David', 2.0)
('Squash Court', 'Stibbons, Ponder', 2.0)
('Squash Court', 'Bader, Florence', 2.0)
('Squash Court', 'Mackenzie, Anna', 2.0)
('Squash Court', 'Sarwin, Ramnaresh', 2.0)
('Squash Court', 'Rumney, Henrietta', 2.0)
('Table Tennis', 'Crumpet, Erica', 2.0)
('Badminton Court', 'Tupperware, Hyacinth', 1.5)
('Pool Table', 'Rumney, Henrietta', 1.5)
('Tennis Court 1', 'Stibbons, Ponder', 1.5)
('Tennis Court 1', 'Farrell, Jemima', 1.5)
('Tennis Court 1', 'Bader, Florence', 1.5)
('Tennis Court 1', 'Genting, Matthew', 1.5)
('Tennis Court 1', 'Crumpet, Erica', 1.5)
('Tennis Court 2', 'Farrell, Jemima', 1.5)
('Tennis Court 2', 'Smith, Jack', 1.5)
('Tennis Court 2', 'Rumney, Henrietta', 1.5)
('Tennis Court 2', 'Farrell, David', 1.5)
('Tennis Court 2', 'Purview, Millicent', 1.5)
('Massage Room 1', 'Mackenzie, Anna', 1.0)
('Massage Room 1', 'Coplin, Joan', 1.0)
('Massage Room 1', 'Worthington-Smyth, Henry', 1.0)
('Massage Room 1', 'Tupperware, Hyacinth', 1.0)
('Massage Room 2', 'Butters, Gerald', 1.0)
('Massage Room 2', 'Smith, Jack', 1.0)
('Massage Room 2', 'Genting, Matthew', 1.0)
('Pool Table', 'Jones, Douglas', 1.0)
('Snooker Table', 'Genting, Matthew', 1.0)
('Snooker Table', 'Farrell, David', 1.0)
('Snooker Table', 'Purview, Millicent', 1.0)
('Squash Court', 'Coplin, Joan', 1.0)
('Squash Court', 'Jones, Douglas', 1.0)
('Squash Court', 'Farrell, David', 1.0)
('Squash Court', 'Purview, Millicent', 1.0)
('Squash Court', 'Tupperware, Hyacinth', 1.0)
('Squash Court', 'Hunt, John', 1.0)
('Table Tennis', 'Butters, Gerald', 1.0)
('Table Tennis', 'Baker, Anne', 1.0)
('Table Tennis', 'Hunt, John', 1.0)
('Pool Table', 'Owen, Charles', 0.5)
('Pool Table', 'Farrell, Jemima', 0.5)


/* Q13: Find the facilities usage by month, but not guests */

SELECT F.name, strftime('%m', date(starttime)) AS mon, SUM(slots) / 2.0 AS hours
            FROM Bookings B
            JOIN Facilities F USING (facid)
            JOIN Members M USING (memid)
            WHERE M.memid != 0
            GROUP BY F.name, mon
            ORDER BY hours DESC

('Badminton Court', '09', 253.5)
('Pool Table', '09', 221.5)
('Tennis Court 1', '09', 208.5)
('Badminton Court', '08', 207.0)
('Tennis Court 2', '09', 207.0)
('Snooker Table', '09', 202.0)
('Massage Room 1', '09', 201.0)
('Table Tennis', '09', 200.0)
('Tennis Court 2', '08', 172.5)
('Tennis Court 1', '08', 169.5)
('Massage Room 1', '08', 158.0)
('Snooker Table', '08', 158.0)
('Pool Table', '08', 151.5)
('Table Tennis', '08', 148.0)
('Tennis Court 1', '07', 100.5)
('Squash Court', '08', 92.0)
('Squash Court', '09', 92.0)
('Massage Room 1', '07', 83.0)
('Badminton Court', '07', 82.5)
('Snooker Table', '07', 70.0)
('Tennis Court 2', '07', 61.5)
('Pool Table', '07', 55.0)
('Table Tennis', '07', 49.0)
('Squash Court', '07', 25.0)
('Massage Room 2', '09', 14.0)
('Massage Room 2', '08', 9.0)
('Massage Room 2', '07', 4.0)