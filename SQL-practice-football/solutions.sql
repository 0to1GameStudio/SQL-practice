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