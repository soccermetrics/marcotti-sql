-- fmrd-views-sqlite.sql: View schema for Football Match Result Database, SQLite version
-- Version: 1.4.0
-- Author: Howard Hamilton
-- Date: 2011-12-29

-- -------------------------------------------------
-- CountriesList View
-- -------------------------------------------------

CREATE VIEW countries_list AS
	SELECT country_id,
				 cty_name AS country,
				 confed_name AS confed
	FROM tbl_countries, tbl_confederations
	WHERE tbl_countries.confed_id = tbl_confederations.confed_id;

-- -------------------------------------------------
-- TimeZoneList View
-- -------------------------------------------------
				 
CREATE VIEW timezone_list AS
	SELECT timezone_id,
		    tz_name,
			confed_name AS confed,
			CASE 
			    WHEN tz_offset < 0 THEN
			        replace(round(tz_offset+0.5),'.0','') || ':' || substr(replace(abs((tz_offset-round(tz_offset+0.5))*60),'.0','0'),1,2)
		        WHEN tz_offset = 0.0 THEN
		            '0:00'
			    ELSE
				    replace(round(tz_offset-0.5),'.0','') || ':' || substr(replace(abs((tz_offset-round(tz_offset-0.5))*60),'.0','0'),1,2)
			END AS offset
	FROM tbl_timezones, tbl_confederations
	WHERE tbl_timezones.confed_id = tbl_confederations.confed_id;
				 				 
-- -------------------------------------------------
-- PositionsList View
-- -------------------------------------------------

CREATE VIEW positions_list AS
	SELECT position_id,
			CASE WHEN tbl_positions.posflank_id IN 
				(SELECT posflank_id FROM tbl_flanknames WHERE posflank_name IS NULL) 
			THEN posfield_name
			ELSE posflank_name || ' ' || posfield_name
			END AS position_name
	FROM tbl_positions, tbl_fieldnames, tbl_flanknames
	WHERE tbl_positions.posflank_id = tbl_flanknames.posflank_id
		AND tbl_positions.posfield_id = tbl_fieldnames.posfield_id;		

-- -------------------------------------------------
-- PlayersList View
-- -------------------------------------------------

CREATE VIEW players_list AS
	SELECT player_id,
			CASE WHEN plyr_nickname IS NOT NULL 
			THEN plyr_nickname
			ELSE plyr_firstname || ' ' || plyr_lastname
			END AS full_name,
			CASE WHEN plyr_nickname IS NOT NULL 
			THEN plyr_nickname
			ELSE plyr_lastname
			END AS sort_name,				 
			position_name,
			plyr_birthdate AS birthdate,
			country
	FROM tbl_players, countries_list, positions_list
	WHERE tbl_players.country_id = countries_list.country_id
	  AND tbl_players.plyr_defposid = positions_list.position_id;		

-- -------------------------------------------------
-- PlayerHistoryList View
-- -------------------------------------------------

CREATE VIEW playerhistory_list AS
	SELECT full_name AS player,
			plyrhist_date AS effective,
			plyrhist_height AS height,
			plyrhist_weight AS weight
	FROM tbl_playerhistory, players_list
	WHERE players_list.player_id = tbl_playerhistory.player_id;
				 
-- -------------------------------------------------
-- ManagersList View
-- -------------------------------------------------

CREATE VIEW managers_list AS
	SELECT manager_id,
			CASE WHEN mgr_nickname IS NOT NULL THEN mgr_nickname
			ELSE mgr_firstname || ' ' || mgr_lastname
			END AS full_name,
			CASE WHEN mgr_nickname IS NOT NULL THEN mgr_nickname
			ELSE mgr_lastname
			END AS sort_name,				 				 
			mgr_birthdate AS birthdate,
			country
	FROM tbl_managers, countries_list
	WHERE tbl_managers.country_id = countries_list.country_id;		

-- -------------------------------------------------
-- RefereesList View
-- -------------------------------------------------

CREATE VIEW referees_list AS
	SELECT referee_id,
			ref_firstname || ' ' || ref_lastname AS full_name,
			ref_lastname AS sort_name,
			ref_birthdate AS birthdate,
			country
	FROM tbl_referees, countries_list
	WHERE tbl_referees.country_id = countries_list.country_id;		

-- -------------------------------------------------
-- HomeTeamList View
-- -------------------------------------------------

CREATE VIEW hometeam_list AS
	SELECT tbl_matches.match_id,
				 cty_name AS team
	FROM tbl_matches, tbl_hometeams, tbl_countries
	WHERE tbl_matches.match_id = tbl_hometeams.match_id
		AND tbl_hometeams.country_id = tbl_countries.country_id;

-- -------------------------------------------------
-- AwayTeamList View
-- -------------------------------------------------

CREATE VIEW awayteam_list AS
	SELECT tbl_matches.match_id,
				 cty_name AS team
	FROM tbl_matches, tbl_awayteams, tbl_countries
	WHERE tbl_matches.match_id = tbl_awayteams.match_id
		AND tbl_awayteams.country_id = tbl_countries.country_id;

-- -------------------------------------------------
-- VenueList View
-- -------------------------------------------------

CREATE VIEW venue_list AS
	SELECT venue_id,
				 ven_name AS venue,
				 ven_city AS city,
				 country,
				 tz_name AS timezone,
				 ven_altitude AS altitude,
				 ven_latitude AS latitude,
				 ven_longitude AS longitude
	FROM tbl_venues, countries_list, tbl_timezones
	WHERE countries_list.country_id = tbl_venues.country_id
	  AND tbl_venues.timezone_id = tbl_timezones.timezone_id;				

-- -------------------------------------------------
-- VenueHistoryList View
-- -------------------------------------------------

CREATE VIEW venuehistory_list AS
	SELECT venue,
				 venuehist_date AS effective,
				 vensurf_desc AS surface,
				 venue_length AS length,
				 venue_width AS width,
				 venuehist_capacity AS capacity,
				 venuehist_seats AS seats
	FROM venue_list, tbl_venuehistory, tbl_venuesurfaces
	WHERE venue_list.venue_id = tbl_venuehistory.venue_id
	  AND tbl_venuehistory.venuesurface_id = tbl_venuesurfaces.venuesurface_id;			 

-- -------------------------------------------------
-- MatchList View
-- -------------------------------------------------

CREATE VIEW match_list AS
	SELECT tbl_matches.match_id,
				 tbl_competitions.competition_id,
				 comp_name AS competition,
				 match_date,
				 phase_desc AS phase,
				 hometeam_list.team || ' vs ' || awayteam_list.team AS matchup,
				 venue,
				 full_name AS referee
	FROM tbl_matches, tbl_competitions, tbl_phases, hometeam_list, awayteam_list, venue_list, referees_list
	WHERE hometeam_list.match_id = tbl_matches.match_id
		AND awayteam_list.match_id = tbl_matches.match_id
		AND tbl_competitions.competition_id = tbl_matches.competition_id
		AND tbl_phases.phase_id = tbl_matches.phase_id
		AND venue_list.venue_id = tbl_matches.venue_id
		AND referees_list.referee_id = tbl_matches.referee_id;
		
-- -------------------------------------------------
-- LeagueMatchList View
-- -------------------------------------------------

CREATE VIEW league_match_list AS
	SELECT match_list.match_id,
				 competition,
				 match_date,
				 round_desc AS round,
				 matchup,
				 venue,
				 referee
	FROM match_list, tbl_rounds, tbl_leaguematches
	WHERE match_list.match_id = tbl_leaguematches.match_id
	  AND tbl_leaguematches.round_id = tbl_rounds.round_id
	  AND match_list.phase = 'League';
	  
-- -------------------------------------------------
-- GroupMatchList View
-- -------------------------------------------------

CREATE VIEW group_match_list AS
	SELECT match_list.match_id,
				 competition,
				 match_date,
				 grpround_desc AS round,
				 group_desc AS group_name,
				 round_desc AS matchday,
				 matchup,
				 venue,
				 referee
	FROM match_list, tbl_rounds, tbl_groups, tbl_grouprounds, tbl_groupmatches
	WHERE tbl_groupmatches.match_id = match_list.match_id
	  AND tbl_groupmatches.grpround_id = tbl_grouprounds.grpround_id
	  AND tbl_groupmatches.group_id = tbl_groups.group_id
	  AND tbl_groupmatches.round_id = tbl_rounds.round_id
	  AND match_list.phase = 'Group';
	  
-- -------------------------------------------------
-- KnockoutMatchList View
-- -------------------------------------------------

CREATE VIEW knockout_match_list AS
	SELECT match_list.match_id,
				 competition,
				 match_date,
				 koround_desc AS round,
				 matchday_desc AS game,
				 matchup,
				 venue,
				 referee
	FROM match_list, tbl_knockoutrounds, tbl_matchdays, tbl_knockoutmatches
	WHERE match_list.match_id = tbl_knockoutmatches.match_id
	  AND tbl_knockoutmatches.koround_id = tbl_knockoutrounds.koround_id
	  AND tbl_knockoutmatches.matchday_id = tbl_matchdays.matchday_id
	  AND match_list.phase = 'Knockout';
	  
-- -------------------------------------------------
-- Weather Conditions Views
-- -------------------------------------------------
		
CREATE VIEW kowx_list AS
	SELECT enviro_id,
				 wx_conditiondesc AS cond
	FROM tbl_weatherkickoff, tbl_weather
	WHERE tbl_weather.weather_id = tbl_weatherkickoff.weather_id;
	
CREATE VIEW htwx_list AS
	SELECT enviro_id,
				 wx_conditiondesc AS cond
	FROM tbl_weatherhalftime, tbl_weather
	WHERE tbl_weather.weather_id = tbl_weatherhalftime.weather_id;
	 						
CREATE VIEW ftwx_list AS
	SELECT enviro_id,
				 wx_conditiondesc AS cond
	FROM tbl_weatherfulltime, tbl_weather
	WHERE tbl_weather.weather_id = tbl_weatherfulltime.weather_id;
		
-- -------------------------------------------------
-- EnviroList View
-- -------------------------------------------------

CREATE VIEW enviro_list AS
	SELECT tbl_environments.enviro_id,
				 matchup,
				 env_kickofftime AS kickoff_time,
				 env_temperature AS temperature,
				 kowx_list.cond	 AS kickoff_wx,
				 htwx_list.cond  AS halftime_wx,
				 ftwx_list.cond  AS fulltime_wx
	FROM tbl_environments, match_list, kowx_list, htwx_list, ftwx_list
	WHERE tbl_environments.match_id = match_list.match_id
	  AND tbl_environments.enviro_id = kowx_list.enviro_id
	  AND tbl_environments.enviro_id = htwx_list.enviro_id
	  AND tbl_environments.enviro_id = ftwx_list.enviro_id;				 						 
				 
-- -------------------------------------------------
-- LineupList View
-- -------------------------------------------------

CREATE VIEW lineup_list AS
	SELECT lineup_id,
				 matchup,
				 country AS team,
				 full_name AS player,
				 sort_name,
				 positions_list.position_name,
				 lp_starting AS starter,
				 lp_captain AS captain
	FROM players_list, positions_list, match_list, tbl_lineups
	WHERE tbl_lineups.match_id = match_list.match_id 
	  AND tbl_lineups.player_id = players_list.player_id
	  AND tbl_lineups.position_id = positions_list.position_id;
	  
-- -------------------------------------------------
-- GoalsList View
-- -------------------------------------------------

CREATE VIEW goals_list AS
	SELECT goal_id,
				 match_list.matchup,
				 team,
				 player AS scorer,
				 gts_desc AS strike,
				 gte_desc AS play,
				 CASE WHEN gls_stime = 0 THEN gls_time || ''''
				 			ELSE gls_time || '+' || gls_stime || ''''
				 END AS time
	FROM match_list, lineup_list, tbl_goalstrikes, tbl_goalevents, tbl_goals
	WHERE match_list.match_id IN (SELECT match_id FROM tbl_lineups 
	                              WHERE tbl_lineups.lineup_id = tbl_goals.lineup_id)
		AND tbl_goals.lineup_id = lineup_list.lineup_id	
		AND team IN (SELECT cty_name FROM tbl_countries
	  							WHERE tbl_countries.country_id = tbl_goals.country_id)
		AND tbl_goals.gtstype_id = tbl_goalstrikes.gtstype_id
		AND tbl_goals.gtetype_id = tbl_goalevents.gtetype_id;

-- -------------------------------------------------
-- OwnGoalsList View
-- -------------------------------------------------

CREATE VIEW owngoals_list AS
	SELECT goal_id,
				 match_list.matchup,
				 team,
				 player AS scorer,
				 gts_desc AS strike,
				 gte_desc AS play,
				 CASE WHEN gls_stime = 0 THEN gls_time || ''''
				 			ELSE gls_time || '+' || gls_stime || ''''
				 END AS time
	FROM match_list, lineup_list, tbl_goalstrikes, tbl_goalevents, tbl_goals
	WHERE match_list.match_id IN (SELECT match_id FROM tbl_lineups)
	  AND tbl_goals.lineup_id = lineup_list.lineup_id
		AND team NOT IN (SELECT cty_name FROM tbl_countries
	  								  WHERE tbl_countries.country_id = tbl_goals.country_id)
        AND tbl_goals.gtstype_id = tbl_goalstrikes.gtstype_id
		AND tbl_goals.gtetype_id = tbl_goalevents.gtetype_id;

-- -------------------------------------------------
-- PenaltiesList View
-- -------------------------------------------------

CREATE VIEW penalties_list AS
	SELECT penalty_id,
				 matchup,
				 team,
				 player AS taker,
				 foul_desc AS foul,
				 po_desc AS outcome,
				 CASE WHEN pen_stime = 0 THEN pen_time || ''''
				 			ELSE pen_time || '+' || pen_stime || ''''
				 END AS time
	FROM tbl_penalties, lineup_list, tbl_fouls, tbl_penoutcomes
	WHERE tbl_penalties.foul_id = tbl_fouls.foul_id
	  AND tbl_penalties.penoutcome_id = tbl_penoutcomes.penoutcome_id
	  AND tbl_penalties.lineup_id = lineup_list.lineup_id;				 

-- -------------------------------------------------
-- CautionsList View
-- -------------------------------------------------

CREATE VIEW cautions_list AS
	SELECT offense_id,
				 matchup,
				 team,
				 player,
				 foul_desc AS foul,
				 CASE WHEN ofns_stime = 0 THEN ofns_time || ''''
				 			ELSE ofns_time || '+' || ofns_stime || ''''
				 END AS time
	FROM tbl_offenses, lineup_list, tbl_fouls
	WHERE tbl_offenses.lineup_id = lineup_list.lineup_id
		AND tbl_offenses.foul_id = tbl_fouls.foul_id
		AND tbl_offenses.card_id IN (SELECT card_id FROM tbl_cards
				WHERE card_type = 'Yellow');

-- -------------------------------------------------
-- ExpulsionsList View
-- -------------------------------------------------

CREATE VIEW expulsions_list AS
	SELECT offense_id,
				 matchup,
				 team,
				 player,
				 foul_desc AS foul,
				 CASE WHEN ofns_stime = 0 THEN ofns_time || ''''
				 			ELSE ofns_time || '+' || ofns_stime || ''''
				 END AS time
	FROM tbl_offenses, lineup_list, tbl_fouls
	WHERE tbl_offenses.lineup_id = lineup_list.lineup_id
		AND tbl_offenses.foul_id = tbl_fouls.foul_id
		AND tbl_offenses.card_id IN (SELECT card_id FROM tbl_cards
				WHERE card_type IN ('Yellow/Red','Red'));

-- -------------------------------------------------
-- SubstitutionsList View
-- -------------------------------------------------

CREATE VIEW insub_list AS
	SELECT subs_id, player
	FROM tbl_insubstitutions, lineup_list
	WHERE tbl_insubstitutions.lineup_id = lineup_list.lineup_id;
	
CREATE VIEW outsub_list AS
	SELECT subs_id, player
	FROM tbl_outsubstitutions, lineup_list
	WHERE tbl_outsubstitutions.lineup_id = lineup_list.lineup_id;

CREATE VIEW subs_list AS
    SELECT tbl_substitutions.subs_id, 
           a1.matchup, 
           a1.team, 
           a1.player AS in_player, 
           a2.player AS out_player, 
           CASE WHEN subs_stime = 0 THEN subs_time || '''' 
           ELSE subs_time || '+' || subs_stime || '''' 
           END AS time FROM lineup_list a1, lineup_list a2, tbl_substitutions                                                                     
    INNER JOIN tbl_insubstitutions ON tbl_substitutions.subs_id = tbl_insubstitutions.subs_id
    INNER JOIN tbl_outsubstitutions ON tbl_substitutions.subs_id = tbl_outsubstitutions.subs_id
    WHERE a1.lineup_id = tbl_insubstitutions.lineup_id
      AND a2.lineup_id = tbl_outsubstitutions.lineup_id
      AND a1.team = a2.team
      AND a1.matchup = a2.matchup;
	
-- -------------------------------------------------
-- SwitchPositionsList View
-- -------------------------------------------------
	
CREATE VIEW switchpos_list AS
	SELECT switch_id,
				 matchup,
				 team,
				 player,
				 lineup_list.position_name AS old_position,
				 positions_list.position_name AS new_position,
				 CASE WHEN switch_stime = 0 THEN switch_time || ''''
				 ELSE switch_time || '+' || switch_stime || ''''
				 END AS time
	FROM tbl_switchpositions, lineup_list, positions_list
	WHERE tbl_switchpositions.lineup_id = lineup_list.lineup_id
		AND tbl_switchpositions.switchposition_id = positions_list.position_id;
		
-- -------------------------------------------------
-- ShootoutOpenersList View
-- -------------------------------------------------
		
CREATE VIEW shootoutopeners_list AS
    SELECT knockout_match_list.match_id,
            competition,
            match_date,
            round,
            game,
            matchup,
            cty_name AS team_first
    FROM knockout_match_list, tbl_countries, tbl_penshootoutopeners
    WHERE tbl_penshootoutopeners.match_id = knockout_match_list.match_id
        AND tbl_penshootoutopeners.country_id = tbl_countries.country_id;
        
-- -------------------------------------------------
-- ShootoutList View
-- -------------------------------------------------

CREATE VIEW shootout_list AS
    SELECT knockout_match_list.match_id,
            team,
            player,
            round_desc AS shootout_round,
            po_desc AS outcome
    FROM knockout_match_list, lineup_list, tbl_penaltyshootouts, tbl_rounds, tbl_penoutcomes
    WHERE tbl_penaltyshootouts.lineup_id = lineup_list.lineup_id
        AND tbl_penaltyshootouts.round_id = tbl_rounds.round_id
        AND tbl_penaltyshootouts.penoutcome_id = tbl_penoutcomes.penoutcome_id
        AND knockout_match_list.match_id IN (SELECT match_id FROM tbl_lineups 
                                            WHERE tbl_lineups.lineup_id = tbl_penaltyshootouts.lineup_id);
