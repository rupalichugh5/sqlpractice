/*LeetCode*/
/*1667. Fix Names in a Table
Table: Users

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the primary key for this table.
This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
 

Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.

Return the result table ordered by user_id.

The query result format is in the following example.

 

Example 1:

Input: 
Users table:
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | aLice |
| 2       | bOB   |
+---------+-------+
Output: 
+---------+-------+
| user_id | name  |
+---------+-------+
| 1       | Alice |
| 2       | Bob   |
+---------+-------+
*/

select user_id,  concat(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name,2,Length(name)))) as name
from users
order by user_id;

/*
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
patient_id is the primary key for this table.
'conditions' contains 0 or more code separated by spaces. 
This table contains information of the patients in the hospital.
 

Write an SQL query to report the patient_id, patient_name and conditions of the patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix.

Return the result table in any order.
*/
SELECT * from patients
where conditions like 'DIAB1%' OR conditions like '% DIAB1%'

SELECT * from patients
where regexp_like(conditions,' +DIAB1|^DIAB1')


/*
Table: Activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some games.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on someday using some device.
 

Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in,
 rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive 
 days starting from their first login date, then divide that number by the total number of players.
*/
with cte as (select player_id, min(event_date) as start
from activity
group by player_id)

select round(count(distinct c.player_id )/(select count(distinct player_id) from activity),2) as fraction
from cte c
join activity a
on c.player_id = a.player_id
and datediff(c.start, a.event_date) = -1



/*
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
There is a factory website that has several machines each running the same number of processes. Write an SQL query to find the 
average time each machine takes to complete a process.
The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total 
time to complete every process on the machine divided by the number of processes that were run.
The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal 
places.
Return the result table in any order.
*/


select machine_id, round(sum(case when activity_type = 'start' then (-1)*timestamp else timestamp end)/count(distinct process_id),3) as processing_time
from activity
group by machine_id

select machine_id, round(sum(if(activity_type = 'start', -timestamp, timestamp))/count(distinct process_id),3) as processing_time
from activity
group by machine_id
