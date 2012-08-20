-- fmrd.sql: Table schema for Football Match Result Database, MySQL version
-- Version: 1.4.0
-- Author: Howard Hamilton
-- Date: 2012-05-14

SET DATESTYLE TO 'ISO';

-- -------------------------------------------------
-- Personnel Tables
-- -------------------------------------------------

-- Confederation table
CREATE TABLE tbl_confederations (
	confed_id	integer NOT NULL AUTO_INCREMENT,
	confed_name	varchar(40) NOT NULL,
	PRIMARY KEY (confed_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_confederations AUTO_INCREMENT=10;

-- Country table
CREATE TABLE tbl_countries (
	country_id	integer NOT NULL AUTO_INCREMENT,
	confed_id	integer NOT NULL,
	cty_name	varchar(60) NOT NULL,
	PRIMARY KEY (country_id),
	FOREIGN KEY (confed_id) REFERENCES tbl_confederations (confed_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_countries AUTO_INCREMENT=100;

-- Field position table
CREATE TABLE tbl_fieldnames (
	posfield_id		integer NOT NULL AUTO_INCREMENT,
	posfield_name	varchar(15) NOT NULL,
	PRIMARY KEY (posfield_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_fieldnames AUTO_INCREMENT=1;	

-- Flank name table
CREATE TABLE tbl_flanknames (
	posflank_id		integer NOT NULL AUTO_INCREMENT,
	posflank_name	varchar(8) NULL,
	PRIMARY KEY (posflank_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_flanknames AUTO_INCREMENT=1;	
	
-- Position table
CREATE TABLE tbl_positions (
	position_id		integer NOT NULL AUTO_INCREMENT,
	posfield_id		integer NOT NULL,
	posflank_id		integer NOT NULL,
	PRIMARY KEY (position_id),
	FOREIGN KEY (posfield_id) REFERENCES tbl_fieldnames (posfield_id),
	FOREIGN KEY (posflank_id) REFERENCES tbl_flanknames (posflank_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_positions AUTO_INCREMENT=10;	

-- Player table
CREATE TABLE tbl_players (
	player_id		integer NOT NULL AUTO_INCREMENT,
	country_id		integer NOT NULL,
	plyr_birthdate  date NOT NULL,
	plyr_firstname	varchar(20) NOT NULL,
	plyr_lastname	varchar(30) NOT NULL,
	plyr_nickname	varchar(30) NULL,
	plyr_defposid	integer NOT NULL,
	PRIMARY KEY (player_id),
	FOREIGN KEY (country_id) REFERENCES tbl_countries (country_id),
	FOREIGN KEY (plyr_defposid) REFERENCES tbl_positions (position_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_players AUTO_INCREMENT=100000;
	
-- Player height/weight tracking table
CREATE TABLE tbl_playerhistory (
	playerhistory_id 	integer NOT NULL AUTO_INCREMENT,
	player_id			integer NOT NULL,
	plyrhist_date		date NOT NULL,
	plyrhist_height 	numeric(3,2) DEFAULT 1.50 CHECK (plyrhist_height >= 0 AND plyrhist_height <= 2.50),
	plyrhist_weight     numeric(3,0) DEFAULT 50 CHECK (plyrhist_weight >= 0 AND plyrhist_weight <= 150),
	PRIMARY KEY (playerhistory_id),
	FOREIGN KEY (player_id) REFERENCES tbl_players (player_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_playerhistory AUTO_INCREMENT=1000000;

-- Manager table
CREATE TABLE tbl_managers (
	manager_id			integer NOT NULL AUTO_INCREMENT,
	country_id			integer NOT NULL,
	mgr_birthdate	    date NOT NULL,
	mgr_firstname		varchar(20) NOT NULL,
	mgr_lastname		varchar(30) NOT NULL,
	mgr_nickname		varchar(30) NULL,
	PRIMARY KEY (manager_id),
	FOREIGN KEY (country_id) REFERENCES tbl_countries (country_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_managers AUTO_INCREMENT=1000;

-- Referee table
CREATE TABLE tbl_referees (
	referee_id			integer NOT NULL AUTO_INCREMENT,
	country_id			integer NOT NULL,
	ref_birthdate		date NOT NULL,
	ref_firstname		varchar(20) NOT NULL,
	ref_lastname		varchar(30) NOT NULL,
	PRIMARY KEY (referee_id),
	FOREIGN KEY (country_id) REFERENCES tbl_countries (country_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_referees AUTO_INCREMENT=1000;

-- -------------------------------------------------
-- Match Overview Tables
-- -------------------------------------------------

-- Time zones table
CREATE TABLE tbl_timezones (
    timezone_id     integer NOT NULL AUTO_INCREMENT,
    confed_id       integer NOT NULL,
    tz_name         varchar(80) NOT NULL,
    tz_offset       numeric(4,2) DEFAULT 0 CHECK (tz_offset >= -12.0 AND tz_offset <= 14.0),
    PRIMARY KEY (timezone_id),
    FOREIGN KEY (confed_id) REFERENCES tbl_confederations (confed_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_timezones AUTO_INCREMENT=100;

-- Venue playing surfaces table
CREATE TABLE tbl_venuesurfaces (
    venuesurface_id     integer NOT NULL AUTO_INCREMENT,
    vensurf_desc        varchar(30) NOT NULL,
    PRIMARY KEY (venuesurface_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB; 
ALTER TABLE tbl_venuesurfaces AUTO_INCREMENT=1;

-- Competitions table
CREATE TABLE tbl_competitions (
	competition_id	integer NOT NULL AUTO_INCREMENT,
	comp_name		varchar(100) NOT NULL,
	PRIMARY KEY (competition_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_competitions AUTO_INCREMENT=100;
	
-- Competition Phases table	
CREATE TABLE tbl_phases (
    phase_id    integer NOT NULL AUTO_INCREMENT,
    phase_desc  varchar(12) NOT NULL,
    PRIMARY KEY (phase_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_phases AUTO_INCREMENT=1;
    
-- Groups table    
CREATE TABLE tbl_groups (
    group_id    integer NOT NULL AUTO_INCREMENT,
    group_desc  varchar(2) NOT NULL,
    PRIMARY KEY (group_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_groups AUTO_INCREMENT=1;
    
-- Group Rounds table
CREATE TABLE tbl_grouprounds (
    grpround_id      integer NOT NULL AUTO_INCREMENT,
    grpround_desc    varchar(40) NOT NULL,
    PRIMARY KEY (grpround_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_grouprounds AUTO_INCREMENT=10;
    
-- Knockout Rounds table    
CREATE TABLE tbl_knockoutrounds (
    koround_id      integer NOT NULL AUTO_INCREMENT,
    koround_desc    varchar(40) NOT NULL,
    PRIMARY KEY (koround_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_knockoutrounds AUTO_INCREMENT=10;

-- (League) Rounds table	
CREATE TABLE tbl_rounds (
	round_id	integer NOT NULL AUTO_INCREMENT,
	round_desc 	varchar(20) NOT NULL,
	PRIMARY KEY (round_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_rounds AUTO_INCREMENT=10;
	
-- Matchdays table
CREATE TABLE tbl_matchdays (
    matchday_id    integer NOT NULL AUTO_INCREMENT,
    matchday_desc  varchar(12) NOT NULL,
    PRIMARY KEY (matchday_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;	
ALTER TABLE tbl_matchdays AUTO_INCREMENT=1;

-- Teams table	
CREATE TABLE tbl_teams (
	team_id 	integer NOT NULL AUTO_INCREMENT,
    country_id  integer NOT NULL,
	tm_name	    varchar(50) NOT NULL,
	PRIMARY KEY (team_id),
	FOREIGN KEY (country_id) REFERENCES tbl_countries (country_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_teams AUTO_INCREMENT=10000;	
	
-- Venues table
CREATE TABLE tbl_venues (
	venue_id		integer NOT NULL AUTO_INCREMENT,
	team_id			integer NOT NULL,
	country_id		integer NOT NULL,
	timezone_id		integer NOT NULL,
	ven_city		varchar(40) NOT NULL,
	ven_name		varchar(40) NOT NULL,
	ven_altitude	numeric(4,0) DEFAULT 0 CHECK (ven_altitude >= -200
								 AND ven_altitude <= 4500),
	ven_latitude	numeric(8,6) DEFAULT 0.000000 CHECK (ven_latitude >= -90.000000
								 AND ven_latitude <=  90.000000),
	ven_longitude	numeric(9,6) DEFAULT 0.000000 CHECK (ven_longitude >= -180.000000
								 AND ven_longitude <=  180.000000),
    PRIMARY KEY (venue_id),
    FOREIGN KEY (team_id) REFERENCES tbl_teams (team_id),
    FOREIGN KEY (country_id) REFERENCES tbl_countries (country_id),
    FOREIGN KEY (timezone_id) REFERENCES tbl_timezones (timezone_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_venues AUTO_INCREMENT=1000;

-- Venue surface/dimensions/capacity historical tracking table
CREATE TABLE tbl_venuehistory (
    venuehistory_id     integer NOT NULL AUTO_INCREMENT,
    venue_id            integer NOT NULL,
    venuehist_date      date NOT NULL,
    venuesurface_id     integer NOT NULL,
    venue_length		integer DEFAULT 105 CHECK (venue_length >= 90 AND venue_length <= 120),
    venue_width			integer DEFAULT 68 CHECK (venue_width >= 45 AND venue_width <= 90),
    venuehist_capacity  integer DEFAULT 0 CHECK (venuehist_capacity >= 0),
    venuehist_seats     integer DEFAULT 0 CHECK (venuehist_seats >= 0),
    PRIMARY KEY (venuehistory_id),
    FOREIGN KEY (venue_id) REFERENCES tbl_venues (venue_id),
    FOREIGN KEY (venuesurface_id) REFERENCES tbl_venuesurfaces (venuesurface_id)
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_venuesurfaces AUTO_INCREMENT=10000;
		
-- Match table
CREATE TABLE tbl_matches (
	match_id				integer NOT NULL AUTO_INCREMENT,
	match_date				date NOT NULL,
	match_firsthalftime	 	integer DEFAULT 45 CHECK (match_firsthalftime > 0),
	match_secondhalftime 	integer DEFAULT 45 CHECK (match_secondhalftime >= 0),
	match_firstovertime     integer DEFAULT 0 CHECK (match_firstovertime >= 0),
	match_secondovertime    integer DEFAULT 0 CHECK (match_secondovertime >= 0),
	match_attendance		integer DEFAULT 0 CHECK (match_attendance >= 0),
	competition_id			integer NOT NULL,
	phase_id                integer NOT NULL,
	venue_id				integer NOT NULL,
	referee_id				integer NOT NULL,
	PRIMARY KEY (match_id),
	FOREIGN KEY (competition_id) REFERENCES tbl_competitions (competition_id),
	FOREIGN KEY (phase_id) REFERENCES tbl_phases (phase_id),
	FOREIGN KEY (venue_id) REFERENCES tbl_venues (venue_id),
	FOREIGN KEY (referee_id) REFERENCES tbl_referees (referee_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_matches AUTO_INCREMENT=1000000;
	
-- Lineup table
CREATE TABLE tbl_lineups (
	lineup_id			integer NOT NULL AUTO_INCREMENT,
	match_id			integer NOT NULL,
	team_id			    integer NOT NULL,
	player_id			integer NOT NULL,
	position_id			integer NOT NULL,
	lp_starting			boolean DEFAULT FALSE,
	lp_captain			boolean DEFAULT FALSE,
	PRIMARY KEY (lineup_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (team_id) REFERENCES tbl_teams (team_id),
	FOREIGN KEY (player_id) REFERENCES tbl_players (player_id),
	FOREIGN KEY (position_id) REFERENCES tbl_positions (position_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_lineups AUTO_INCREMENT=1000000;
		
-- ---------------------------------------
-- Linking tables to Match Overview tables
-- ---------------------------------------

-- League matches
CREATE TABLE tbl_leaguematches (
    match_id    integer NOT NULL,
	round_id	integer NOT NULL,
	PRIMARY KEY (match_id, round_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (round_id) REFERENCES tbl_rounds (round_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;   

-- Group matches
CREATE TABLE tbl_groupmatches (
    match_id    integer NOT NULL,
    grpround_id integer NOT NULL,
    group_id    integer NOT NULL,
	round_id	integer NOT NULL,
	PRIMARY KEY (match_id, grpround_id, group_id, round_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (grpround_id) REFERENCES tbl_grouprounds (grpround_id),
	FOREIGN KEY (group_id) REFERENCES tbl_groups (group_id),
	FOREIGN KEY (round_id) REFERENCES tbl_rounds (round_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;   

-- Knockout matches
CREATE TABLE tbl_knockoutmatches (
    match_id    integer NOT NULL,
	koround_id	integer NOT NULL,
	matchday_id integer NOT NULL,
	PRIMARY KEY (match_id, koround_id, matchday_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (koround_id) REFERENCES tbl_knockoutrounds (koround_id),
	FOREIGN KEY (matchday_id) REFERENCES tbl_matchdays (matchday_id)		
	) CHARACTER SET utf8 ENGINE=InnoDB;   

-- Home/away teams
CREATE TABLE tbl_hometeams (
	match_id	integer NOT NULL,
	team_id	    integer	NOT NULL,
	PRIMARY KEY (match_id, team_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (team_id) REFERENCES tbl_teams (team_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;
	
CREATE TABLE tbl_awayteams (
	match_id	integer NOT NULL,
	team_id	    integer	NOT NULL,
	PRIMARY KEY (match_id, team_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (team_id) REFERENCES tbl_teams (team_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;	

-- Home/away managers	
CREATE TABLE tbl_homemanagers (
	match_id	integer NOT NULL,
	manager_id	integer	NOT NULL,
	PRIMARY KEY (match_id, manager_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (manager_id) REFERENCES tbl_managers (manager_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;
	
CREATE TABLE tbl_awaymanagers (
	match_id	integer NOT NULL,
	manager_id	integer	NOT NULL,
	PRIMARY KEY (match_id, manager_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (manager_id) REFERENCES tbl_managers (manager_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;	
	
-- -------------------------------------------------
-- Environmental Condition Tables
-- -------------------------------------------------

-- Environment main table
CREATE TABLE tbl_environments (
	enviro_id			integer NOT NULL AUTO_INCREMENT,
	match_id			integer NOT NULL,
	env_kickofftime		time NOT NULL,
	env_temperature 	numeric(4,2) CHECK (env_temperature >= -15.0 
						        		AND env_temperature <= 45.0),
    PRIMARY KEY (enviro_id),
    FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id)						        		
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_environments AUTO_INCREMENT=1000000;

-- Weather conditions table
CREATE TABLE tbl_weather (
	weather_id			integer NOT NULL AUTO_INCREMENT,
	wx_conditiondesc	varchar(40) NOT NULL,
	PRIMARY KEY (weather_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_weather AUTO_INCREMENT=10;

-- ------------------------------------------	
-- Linking tables to Weather Condition tables
-- ------------------------------------------

-- Kickoff weather condition table
CREATE TABLE tbl_weatherkickoff (
	enviro_id		integer NOT NULL,
	weather_id		integer NOT NULL,
	PRIMARY KEY (enviro_id, weather_id),
	FOREIGN KEY (enviro_id) REFERENCES tbl_environments (enviro_id),
	FOREIGN KEY (weather_id) REFERENCES tbl_weather (weather_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;

-- Halftime weather condition table
CREATE TABLE tbl_weatherhalftime (
	enviro_id		integer NOT NULL,
	weather_id		integer NOT NULL,
	PRIMARY KEY (enviro_id, weather_id),
	FOREIGN KEY (enviro_id) REFERENCES tbl_environments (enviro_id),
	FOREIGN KEY (weather_id) REFERENCES tbl_weather (weather_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;

-- Fulltime weather condition table
CREATE TABLE tbl_weatherfulltime (
	enviro_id		integer NOT NULL,
	weather_id		integer NOT NULL,
	PRIMARY KEY (enviro_id, weather_id),
	FOREIGN KEY (enviro_id) REFERENCES tbl_environments (enviro_id),
	FOREIGN KEY (weather_id) REFERENCES tbl_weather (weather_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;

-- -------------------------------------------------
-- Match Event Tables
-- -------------------------------------------------

-- Goal strikes table
CREATE TABLE tbl_goalstrikes (
	gtstype_id		integer NOT NULL AUTO_INCREMENT,
	gts_desc		varchar(15) NOT NULL,
	PRIMARY KEY (gtstype_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_goalstrikes AUTO_INCREMENT=1;
	
-- Goal events table
CREATE TABLE tbl_goalevents (
	gtetype_id		integer NOT NULL AUTO_INCREMENT,
	gte_desc		varchar(30) NOT NULL,
	PRIMARY KEY (gtetype_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_goalevents AUTO_INCREMENT=10;

-- Goals table	
CREATE TABLE tbl_goals (
	goal_id		integer NOT NULL AUTO_INCREMENT,
	team_id	    integer NOT NULL,
	lineup_id	integer NOT NULL,
	gtstype_id	integer NOT NULL,
	gtetype_id	integer NOT NULL,
	gls_time	integer NOT NULL CHECK (gls_time > 0 AND gls_time <= 120),
	gls_stime	integer DEFAULT 0 CHECK (gls_stime >= 0 AND gls_stime <= 15),
	PRIMARY KEY (goal_id),
	FOREIGN KEY (team_id) REFERENCES tbl_teams (team_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id),
	FOREIGN KEY (gtstype_id) REFERENCES tbl_goalstrikes (gtstype_id),
	FOREIGN KEY (gtetype_id) REFERENCES tbl_goalevents (gtetype_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_goals AUTO_INCREMENT=100000;
	
-- Cards table
CREATE TABLE tbl_cards (
	card_id			integer NOT NULL AUTO_INCREMENT,
	card_type		varchar(12) NOT NULL,
	PRIMARY KEY (card_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_cards AUTO_INCREMENT=1;
	
-- Fouls table
CREATE TABLE tbl_fouls (
	foul_id		integer NOT NULL AUTO_INCREMENT,
	foul_desc 	varchar(40) NOT NULL,
	PRIMARY KEY (foul_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_fouls AUTO_INCREMENT=10;


-- Offenses table
CREATE TABLE tbl_offenses (
	offense_id		integer NOT NULL AUTO_INCREMENT,
	lineup_id		integer NOT NULL,
	foul_id			integer NOT NULL,
	card_id			integer NOT NULL,
	ofns_time		integer NOT NULL CHECK (ofns_time > 0 AND ofns_time <= 120),
	ofns_stime		integer DEFAULT 0 CHECK (ofns_stime >= 0 AND ofns_stime <= 15),
	PRIMARY KEY (offense_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id),
	FOREIGN KEY (foul_id) REFERENCES tbl_fouls (foul_id),
	FOREIGN KEY (card_id) REFERENCES tbl_cards (card_id)    
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_offenses AUTO_INCREMENT=100000;

-- Penalty Outcomes table
CREATE TABLE tbl_penoutcomes (
	penoutcome_id		integer NOT NULL AUTO_INCREMENT,
	po_desc				varchar(15) NOT NULL
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_penoutcomes AUTO_INCREMENT=1;

-- Penalties table
CREATE TABLE tbl_penalties (
	penalty_id		integer NOT NULL AUTO_INCREMENT,
	lineup_id		integer NOT NULL,
	foul_id			integer NOT NULL,
	penoutcome_id	integer NOT NULL,
	pen_time		integer NOT NULL CHECK (pen_time > 0 AND pen_time <= 120),
	pen_stime		integer DEFAULT 0 CHECK (pen_stime >= 0 AND pen_stime <= 15),
	PRIMARY KEY (penalty_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id),
	FOREIGN KEY (foul_id) REFERENCES tbl_fouls (foul_id),
	FOREIGN KEY (penoutcome_id) REFERENCES tbl_penoutcomes (penoutcome_id)    	
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_penalties AUTO_INCREMENT=10000;
	
-- Penalty Shootouts table
CREATE TABLE tbl_penaltyshootouts (
    penshootout_id  integer NOT NULL AUTO_INCREMENT,
    lineup_id       integer NOT NULL,
    round_id        integer NOT NULL,
    penoutcome_id   integer NOT NULL,
    PRIMARY KEY (penshootout_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id),
	FOREIGN KEY (round_id) REFERENCES tbl_rounds (round_id),	
	FOREIGN KEY (penoutcome_id) REFERENCES tbl_penoutcomes (penoutcome_id)    	    
    ) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_penaltyshootouts AUTO_INCREMENT=100000;
    
-- Penalty Shootout opener table
CREATE TABLE tbl_penshootoutopeners (
    match_id    integer NOT NULL,
    team_id     integer NOT NULL,
    PRIMARY KEY (match_id, team_id),
	FOREIGN KEY (match_id) REFERENCES tbl_matches (match_id),
	FOREIGN KEY (team_id) REFERENCES tbl_teams (team_id)	
    ) CHARACTER SET utf8 ENGINE=InnoDB;
    
-- Substitutions table
CREATE TABLE tbl_substitutions (
	subs_id			integer NOT NULL AUTO_INCREMENT,
	subs_time		integer NOT NULL CHECK (subs_time > 0 AND subs_time <= 120),
	subs_stime		integer DEFAULT 0 CHECK (subs_stime >= 0 AND subs_stime <= 15),
	PRIMARY KEY (subs_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_substitutions AUTO_INCREMENT=100000;

-- In Substitutions table
CREATE TABLE tbl_insubstitutions (
	subs_id			integer NOT NULL,
	lineup_id		integer	NOT NULL,
	PRIMARY KEY (subs_id, lineup_id),
	FOREIGN KEY (subs_id) REFERENCES tbl_substitutions (subs_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id)
	) CHARACTER SET utf8 ENGINE=InnoDB;

-- Out Substitutions table
CREATE TABLE tbl_outsubstitutions (
	subs_id			integer NOT NULL,
	lineup_id		integer	NOT NULL,
	PRIMARY KEY (subs_id, lineup_id),
	FOREIGN KEY (subs_id) REFERENCES tbl_substitutions (subs_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id)	
	) CHARACTER SET utf8 ENGINE=InnoDB;

-- Switch Positions table
CREATE TABLE tbl_switchpositions (
	switch_id			integer NOT NULL AUTO_INCREMENT,
	lineup_id			integer NOT NULL,
	switchposition_id	integer NOT NULL,
	switch_time			integer NOT NULL CHECK (switch_time > 0 AND switch_time < 120),
	switch_stime		integer DEFAULT 0 CHECK (switch_stime >= 0 AND switch_stime <= 15),
	PRIMARY KEY (switch_id),
	FOREIGN KEY (lineup_id) REFERENCES tbl_lineups (lineup_id),	
	FOREIGN KEY (switchposition_id) REFERENCES tbl_positions (position_id)		
	) CHARACTER SET utf8 ENGINE=InnoDB;
ALTER TABLE tbl_switchpositions AUTO_INCREMENT=100000;	
