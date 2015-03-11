DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSuggestedFriends`(in currentuser int)
begin
        select count(u2.id) as nb_mutualfriends, u2.id from (
			select distinct
				least(f2.follower_id, f2.followable_id) as followable_id
  			, greatest(f2.follower_id, f2.followable_id) as follower_id
			from (select followable_id from follows where follower_id=currentuser and blocked=0) as f1 
			inner join follows f2 
				 where (f2.followable_id=f1.followable_id and f2.follower_id!=currentuser and f2.follower_id not in (select followable_id from follows where follower_id=currentuser and blocked=0)) 
			 	or	(f2.follower_id=f1.followable_id and f2.followable_id!=currentuser and f2.followable_id not in (select followable_id from follows where follower_id=currentuser and blocked=0)) and f2.blocked=0) 
			as u1 
			inner join users u2 where (u2.id=u1.followable_id or u2.id=u1.follower_id) and u2.id not in (select followable_id from follows where follower_id=currentuser and blocked=0) 
		group by u2.id 
		order by count(u2.id) desc;    
	end;;
DELIMITER ;