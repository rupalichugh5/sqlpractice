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
