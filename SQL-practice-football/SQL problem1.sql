CREATE TABLE teams 
(
       team_id           INT primary key,
       team_name      	VARCHAR(50) not null
);

CREATE TABLE matches 
(
       match_id 		INT primary key,
       host_team 		INT,
       guest_team 		INT,
       host_goals 		INT,
       guest_goals 		INT
);

INSERT INTO teams VALUES(10, 'Give');
INSERT INTO teams VALUES(20, 'Never');
INSERT INTO teams VALUES(30, 'You');
INSERT INTO teams VALUES(40, 'Up');
INSERT INTO teams VALUES(50, 'Gonna');

INSERT INTO matches VALUES(1, 30, 20, 1, 0);
INSERT INTO matches VALUES(2, 10, 20, 1, 2);
INSERT INTO matches VALUES(3, 20, 50, 2, 2);
INSERT INTO matches VALUES(4, 10, 30, 1, 0);
INSERT INTO matches VALUES(5, 30, 50, 0, 1);


SELECT * FROM teams;
SELECT * FROM matches;

with cte as(
select 
 host_team,guest_team,host_goals,guest_goals,
 case when host_goals > guest_goals then 3
     when host_goals = guest_goals then 1 else 0 end as host_win,
 case when host_goals < guest_goals then 3 
     when guest_goals = host_goals then 1 else 0 end as guest_win
 from matches),
 cte2 as(
 select 
  host_team,sum(host_win) as host_score,guest_team,sum(guest_win) as guest_score
   from cte
   group by host_team,guest_team),
   cte3 as(
   select 
   host_team,sum(host_score) as score_h
    from cte2
	 group by host_team
	union
	select guest_team,sum(guest_score) as score_g
     from cte2
	 group by guest_team)
	select team_id,team_name,sum(case when score_h <> 0 then score_h else 0 end) as num_points
	 from teams as t1
	 left join cte3 as c1
	  on t1.team_id = c1.host_team
	 group by team_id,team_name
	 order by num_points desc,team_name desc;
	 
	   
	   

with team_m as(
select team_id,team_name
	from teams
),
matches_cond as(
select team_id,team_name,host_team,guest_team,host_goals,guest_goals,
	case when host_goals > guest_goals then 3
     when host_goals = guest_goals then 1 else 0 end as host_win,
 	case when host_goals < guest_goals then 3 
     when guest_goals = host_goals then 1 else 0 end as guest_win
	 from team_m as t 
left join matches as m
	 on t.team_id = m.host_team or t.team_id = m.guest_team
)
select team_id,team_name,
  sum(guest_win) as num_points
  from matches_cond
	group by team_id,team_name
	order by num_points desc;
   

