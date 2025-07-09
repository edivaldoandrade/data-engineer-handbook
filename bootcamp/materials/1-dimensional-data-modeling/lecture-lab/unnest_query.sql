SELECT player_name,
  		UNNEST(season_stats),
		(UNNEST(season_stats)::season_stats).pts -- CROSS JOIN UNNEST
         -- / LATERAL VIEW EXPLODE
  FROM players
  WHERE  player_name = 'Shaquille O''Neal';