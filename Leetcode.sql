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


/*
Table: Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
In SQL, id is the primary key for this table.
Each row of this table contains the score of a game. Score is a floating point value with two decimal places.
 

Find the rank of the scores. The ranking should be calculated according to the following rules:

The scores should be ranked from the highest to the lowest.
If there is a tie between two scores, both should have the same ranking.
After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
Return the result table ordered by score in descending order.

*/
select score, dense_rank() over(order by score desc ) as 'rank' from scores


/*
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
id is an autoincrement column.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order
*/
select distinct a.num as ConsecutiveNums
from logs a, logs b, logs c
where (a.id = b.id+1 and a.num = b.num)
and (a.id = c.id+2 and a.num = c.num)


/*
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
 

Write an SQL query to find the employees who earn more than their managers.

Return the result table in any order.
*/
select e.name as 'Employee'
from employee e
join employee m
on m.id = e.managerId
where e.salary>m.salary

select m.name as 'Employee'
from employee e
join employee m
on e.id = m.managerId
where e.salary<m.salary