 CREATE TYPE season_stats AS (
                         season Integer,
                         pts REAL,
                         ast REAL,
                         reb REAL,
                         weight INTEGER
                       );
 CREATE TYPE scoring_class AS
     ENUM ('bad', 'average', 'good', 'star');


 CREATE TABLE players (
     player_name TEXT,
     height TEXT,
     college TEXT,
     country TEXT,
     draft_year TEXT,
     draft_round TEXT,
     draft_number TEXT,
     seasons season_stats[],
     scoring_class scoring_class,
     years_since_last_active INTEGER,
     is_active BOOLEAN,
     current_season INTEGER,
     PRIMARY KEY (player_name, current_season)
 );



WITH yesterday AS (
	SELECT * FROM players
	WHERE current_season = 1996

), today AS (
	 SELECT * FROM player_seasons
	WHERE season = 1997
)
INSERT INTO players
SELECT
		COALESCE(t.player_name, y.player_name) as player_name,
		COALESCE(t.height, y.height) as height,
		COALESCE(t.college, y.college) as college,
		COALESCE(t.country, y.country) as country,
		COALESCE(t.draft_year, y.draft_year) as draft_year,
		COALESCE(t.draft_round, y.draft_round) as draft_round,
		COALESCE(t.draft_number, y.draft_number)   as draft_number,
		case 
			when y.season_stats is null
				then ARRAY[row(
					t.season,
					t.gp,
					t.pts,
					t.reb,
					t.ast
				)::season_stats]
			when t.season is not null then y.season_stats || ARRAY[row(
				t.season,
				t.gp,
				t.pts,
				t.reb,
				t.ast
			)::season_stats]
			ELSE y.season_stats 
		END			 AS season_stats,
		COALESCE(t.season, y.current_season +1)		 as current_season
	FROM today t
	FULL OUTER JOIN yesterday y
	ON t.player_name = y.player_name



