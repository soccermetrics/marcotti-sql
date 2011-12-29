-- fmrd.sql: Table schema for Football Match Result Database
-- Version: 1.4.0
-- Author: Howard Hamilton
-- Date: 2011-12-29

SET DATESTYLE TO 'ISO';

-- -------------------------------------------------
-- Personnel Tables
-- -------------------------------------------------

-- Confederation table
CREATE SEQUENCE conseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_confederations (
	confed_id	integer PRIMARY KEY DEFAULT nextval('conseq'),
	confed_name	varchar(40) NOT NULL
	) WITH OIDS;

-- Country table
CREATE SEQUENCE ctryseq increment 1 minvalue 100 maxvalue 999 start 100;
CREATE TABLE tbl_countries (
	country_id	integer PRIMARY KEY DEFAULT nextval('ctryseq'),
	confed_id	integer REFERENCES tbl_confederations,
	cty_name	varchar(60) NOT NULL
	) WITH OIDS;

-- Field position table
CREATE SEQUENCE fieldseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_fieldnames (
	posfield_id		integer PRIMARY KEY DEFAULT nextval('fieldseq'),
	posfield_name	varchar(15) NOT NULL
	) WITH OIDS;

-- Flank name table
CREATE SEQUENCE flankseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_flanknames (
	posflank_id		integer PRIMARY KEY DEFAULT nextval('flankseq'),
	posflank_name	varchar(8) NULL
	) WITH OIDS;
	
-- Position table
CREATE SEQUENCE posseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_positions (
	position_id		integer PRIMARY KEY DEFAULT nextval('posseq'),
	posfield_id		integer REFERENCES tbl_fieldnames,
	posflank_id		integer REFERENCES tbl_flanknames
	) WITH OIDS;

-- Player table
CREATE SEQUENCE plyrseq increment 1 minvalue 100000 maxvalue 999999 start 100000;
CREATE TABLE tbl_players (
	player_id		integer PRIMARY KEY DEFAULT nextval('plyrseq'),
	country_id		integer REFERENCES tbl_countries,
	plyr_birthdate  date NOT NULL,
	plyr_firstname	varchar(20) NOT NULL,
	plyr_lastname	varchar(30) NOT NULL,
	plyr_nickname	varchar(30) NULL,
	plyr_defposid	integer REFERENCES tbl_positions
	) WITH OIDS;
	
-- Player height/weight tracking table
CREATE SEQUENCE plyrhistseq increment 1 minvalue 1000000 maxvalue 9999999 start 1000000;
CREATE TABLE tbl_playerhistory (
	playerhistory_id 	integer PRIMARY KEY DEFAULT nextval('plyrhistseq'),
	player_id			integer REFERENCES tbl_players,
	plyrhist_date		date,
	plyrhist_height 	numeric(3,2) DEFAULT 1.50 CHECK (plyrhist_height >= 0 AND plyrhist_height <= 2.50),
	plyrhist_weight     numeric(3,0) DEFAULT 50 CHECK (plyrhist_weight >= 0 AND plyrhist_weight <= 150)
	) WITH OIDS;

-- Manager table
CREATE SEQUENCE mgrseq increment 1 minvalue 1000 maxvalue 9999 start 1000;
CREATE TABLE tbl_managers (
	manager_id			integer PRIMARY KEY DEFAULT nextval('mgrseq'),
	country_id			integer REFERENCES tbl_countries,
	mgr_birthdate	    date NOT NULL,
	mgr_firstname		varchar(20) NOT NULL,
	mgr_lastname		varchar(30) NOT NULL,
	mgr_nickname		varchar(30) NULL
	) WITH OIDS;

-- Referee table
CREATE SEQUENCE refseq increment 1 minvalue 1000 maxvalue 9999 start 1000;
CREATE TABLE tbl_referees (
	referee_id			integer PRIMARY KEY DEFAULT nextval('refseq'),
	country_id			integer REFERENCES tbl_countries,
	ref_birthdate		date NOT NULL,
	ref_firstname		varchar(20) NOT NULL,
	ref_lastname		varchar(30) NOT NULL
	) WITH OIDS;

-- -------------------------------------------------
-- Match Overview Tables
-- -------------------------------------------------

-- Time zones table
CREATE SEQUENCE tzseq increment 1 minvalue 100 maxvalue 999 start 100;
CREATE TABLE tbl_timezones (
    timezone_id     integer PRIMARY KEY DEFAULT nextval('tzseq'),
    confed_id       integer REFERENCES tbl_confederations,
    tz_name         varchar(80) NOT NULL,
    tz_offset       numeric(4,2) DEFAULT 0 CHECK (tz_offset >= -12.0 AND tz_offset <= 14.0)
    ) WITH OIDS;

-- Venue playing surfaces table
CREATE SEQUENCE surfseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_venuesurfaces (
    venuesurface_id     integer PRIMARY KEY DEFAULT nextval('surfseq'),
    vensurf_desc        varchar(30) NOT NULL
    ) WITH OIDS; 

-- Competitions table
CREATE SEQUENCE compseq increment 1 minvalue 100 maxvalue 999 start 100;
CREATE TABLE tbl_competitions (
	competition_id	integer PRIMARY KEY DEFAULT nextval('compseq'),
	comp_name		varchar(100) NOT NULL
	) WITH OIDS;
	
-- Competition Phases table	
CREATE SEQUENCE phaseseq increment 1 minvalue 1 maxvalue 3 start 1;
CREATE TABLE tbl_phases (
    phase_id    integer PRIMARY KEY DEFAULT nextval('phaseseq'),
    phase_desc  varchar(12) NOT NULL
    ) WITH OIDS;
    
-- Groups table    
CREATE SEQUENCE groupseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_groups (
    group_id    integer PRIMARY KEY DEFAULT nextval('groupseq'),
    group_desc  varchar(2) NOT NULL
    ) WITH OIDS;
    
-- Group Rounds table
CREATE SEQUENCE grproundseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_grouprounds (
    grpround_id      integer PRIMARY KEY DEFAULT nextval('grproundseq'),
    grpround_desc    varchar(40) NOT NULL
    ) WITH OIDS;
    
-- Knockout Rounds table    
CREATE SEQUENCE koroundseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_knockoutrounds (
    koround_id      integer PRIMARY KEY DEFAULT nextval('koroundseq'),
    koround_desc    varchar(40) NOT NULL
    ) WITH OIDS;

-- (League) Rounds table	
CREATE SEQUENCE roundseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_rounds (
	round_id	integer PRIMARY KEY DEFAULT nextval('roundseq'),
	round_desc 	varchar(20) NOT NULL
	) WITH OIDS;
	
-- Matchdays table
CREATE SEQUENCE matchdayseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_matchdays (
    matchday_id    integer PRIMARY KEY DEFAULT nextval('matchdayseq'),
    matchday_desc  varchar(12) NOT NULL
    ) WITH OIDS;	

-- Venues table
CREATE SEQUENCE venueseq increment 1 minvalue 1000 maxvalue 9999 start 1000;
CREATE TABLE tbl_venues (
	venue_id		integer PRIMARY KEY DEFAULT nextval('venueseq'),
	country_id		integer REFERENCES tbl_countries,
	timezone_id		integer REFERENCES tbl_timezones,
	ven_city		varchar(40) NOT NULL,
	ven_name		varchar(40) NOT NULL,
	ven_altitude	numeric(4,0) DEFAULT 0 CHECK (ven_altitude >= -200
								 AND ven_altitude <= 4500),
	ven_latitude	numeric(8,6) DEFAULT 0.000000 CHECK (ven_latitude >= -90.000000
								 AND ven_latitude <=  90.000000),
	ven_longitude	numeric(9,6) DEFAULT 0.000000 CHECK (ven_longitude >= -180.000000
								 AND ven_longitude <=  180.000000)
	) WITH OIDS;

-- Venue surface/dimensions/capacity historical tracking table
CREATE SEQUENCE venhistseq increment 1 minvalue 10000 maxvalue 99999 start 10000;
CREATE TABLE tbl_venuehistory (
    venuehistory_id     integer PRIMARY KEY DEFAULT nextval('venhistseq'),
    venue_id            integer REFERENCES tbl_venues,
    venuehist_date      date,
    venuesurface_id     integer REFERENCES tbl_venuesurfaces,
    venue_length		integer DEFAULT 105 CHECK (venue_length >= 90 AND venue_length <= 120),
    venue_width			integer DEFAULT 68 CHECK (venue_width >= 45 AND venue_width <= 90),
    venuehist_capacity  integer DEFAULT 0 CHECK (venuehist_capacity >= 0),
    venuehist_seats     integer DEFAULT 0 CHECK (venuehist_seats >= 0)
    ) WITH OIDS;
		
-- Match table
CREATE SEQUENCE matchseq increment 1 minvalue 1000000 maxvalue 9999999 start 1000000;
CREATE TABLE tbl_matches (
	match_id				integer PRIMARY KEY DEFAULT nextval('matchseq'),
	match_date				date,
	match_firsthalftime	 	integer DEFAULT 45 CHECK (match_firsthalftime > 0),
	match_secondhalftime 	integer DEFAULT 45 CHECK (match_secondhalftime >= 0),
	match_firstovertime     integer DEFAULT 0 CHECK (match_firstovertime >= 0),
	match_secondovertime    integer DEFAULT 0 CHECK (match_secondovertime >= 0),
	match_attendance		integer DEFAULT 0 CHECK (match_attendance >= 0),
	competition_id			integer REFERENCES tbl_competitions,
	phase_id                integer REFERENCES tbl_phases,
	venue_id				integer REFERENCES tbl_venues,
	referee_id				integer REFERENCES tbl_referees
	) WITH OIDS;
	
-- Lineup table
CREATE SEQUENCE lineupseq increment 1 minvalue 1000000 maxvalue 9999999 start 1000000;
CREATE TABLE tbl_lineups (
	lineup_id			integer PRIMARY KEY DEFAULT nextval('lineupseq'),
	match_id			integer REFERENCES tbl_matches,
	player_id			integer REFERENCES tbl_players,
	position_id			integer REFERENCES tbl_positions,
	lp_starting			boolean DEFAULT FALSE,
	lp_captain			boolean DEFAULT FALSE
	) WITH OIDS;
		
-- ---------------------------------------
-- Linking tables to Match Overview tables
-- ---------------------------------------

-- League matches
CREATE TABLE tbl_leaguematches (
    match_id    integer REFERENCES tbl_matches,
	round_id	integer REFERENCES tbl_rounds,
	PRIMARY KEY (match_id, round_id)
	) WITH OIDS;   

-- Group matches
CREATE TABLE tbl_groupmatches (
    match_id    integer REFERENCES tbl_matches,
    grpround_id integer REFERENCES tbl_grouprounds,
    group_id    integer REFERENCES tbl_groups,
	round_id	integer REFERENCES tbl_rounds,
	PRIMARY KEY (match_id, grpround_id, group_id, round_id)
	) WITH OIDS;   

-- Knockout matches
CREATE TABLE tbl_knockoutmatches (
    match_id    integer REFERENCES tbl_matches,
	koround_id	integer REFERENCES tbl_knockoutrounds,
	matchday_id integer REFERENCES tbl_matchdays,
	PRIMARY KEY (match_id, koround_id, matchday_id)
	) WITH OIDS;   

-- Home/away teams
CREATE TABLE tbl_hometeams (
	match_id	integer REFERENCES tbl_matches,
	country_id	integer	REFERENCES tbl_countries,
	PRIMARY KEY (match_id, country_id)
	) WITH OIDS;
	
CREATE TABLE tbl_awayteams (
	match_id	integer REFERENCES tbl_matches,
	country_id	integer	REFERENCES tbl_countries,
	PRIMARY KEY (match_id, country_id)
	) WITH OIDS;	

-- Home/away managers	
CREATE TABLE tbl_homemanagers (
	match_id	integer REFERENCES tbl_matches,
	manager_id	integer	REFERENCES tbl_managers,
	PRIMARY KEY (match_id, manager_id)
	) WITH OIDS;
	
CREATE TABLE tbl_awaymanagers (
	match_id	integer REFERENCES tbl_matches,
	manager_id	integer	REFERENCES tbl_managers,
	PRIMARY KEY (match_id, manager_id)
	) WITH OIDS;	
	
-- -------------------------------------------------
-- Environmental Condition Tables
-- -------------------------------------------------

-- Environment main table
CREATE SEQUENCE enviroseq increment 1 minvalue 1000000 maxvalue 9999999 start 1000000;
CREATE TABLE tbl_environments (
	enviro_id			integer PRIMARY KEY DEFAULT nextval('enviroseq'),
	match_id			integer REFERENCES tbl_matches,
	env_kickofftime		time,
	env_temperature 	numeric(4,2) CHECK (env_temperature >= -15.0 
						        		AND env_temperature <= 45.0)
	) WITH OIDS;

-- Weather conditions table
CREATE SEQUENCE wxseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_weather (
	weather_id			integer PRIMARY KEY DEFAULT nextval('wxseq'),
	wx_conditiondesc	varchar(40) NOT NULL
	) WITH OIDS;

-- ------------------------------------------	
-- Linking tables to Weather Condition tables
-- ------------------------------------------

-- Kickoff weather condition table
CREATE TABLE tbl_weatherkickoff (
	enviro_id		integer REFERENCES tbl_environments,
	weather_id		integer REFERENCES tbl_weather,
	PRIMARY KEY (enviro_id, weather_id)
	) WITH OIDS;

-- Halftime weather condition table
CREATE TABLE tbl_weatherhalftime (
	enviro_id		integer REFERENCES tbl_environments,
	weather_id		integer REFERENCES tbl_weather,
	PRIMARY KEY (enviro_id, weather_id)
	) WITH OIDS;

-- Fulltime weather condition table
CREATE TABLE tbl_weatherfulltime (
	enviro_id		integer REFERENCES tbl_environments,
	weather_id		integer REFERENCES tbl_weather,
	PRIMARY KEY (enviro_id, weather_id)
	) WITH OIDS;

-- -------------------------------------------------
-- Match Event Tables
-- -------------------------------------------------

-- Goal strikes table
CREATE SEQUENCE gstkseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_goalstrikes (
	gtstype_id		integer PRIMARY KEY DEFAULT nextval('gstkseq'),
	gts_desc		varchar(15) NOT NULL
	) WITH OIDS;
	
-- Goal events table
CREATE SEQUENCE gevtseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_goalevents (
	gtetype_id		integer PRIMARY KEY DEFAULT nextval('gevtseq'),
	gte_desc		varchar(30) NOT NULL
	) WITH OIDS;

-- Goals table	
CREATE SEQUENCE goalseq increment 1 minvalue 100000 maxvalue 999999 start 100000;
CREATE TABLE tbl_goals (
	goal_id		integer PRIMARY KEY DEFAULT nextval('goalseq'),
	country_id	integer REFERENCES tbl_countries,
	lineup_id	integer REFERENCES tbl_lineups,
	gtstype_id	integer REFERENCES tbl_goalstrikes,
	gtetype_id	integer REFERENCES tbl_goalevents,
	gls_time	integer NOT NULL CHECK (gls_time > 0 AND gls_time <= 120),
	gls_stime	integer DEFAULT 0 CHECK (gls_stime >= 0 AND gls_stime <= 15)
	) WITH OIDS;
	
-- Cards table
CREATE SEQUENCE cardseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_cards (
	card_id			integer PRIMARY KEY DEFAULT nextval('cardseq'),
	card_type		varchar(12) NOT NULL
	) WITH OIDS;
	
-- Fouls table
CREATE SEQUENCE foulseq increment 1 minvalue 10 maxvalue 99 start 10;
CREATE TABLE tbl_fouls (
	foul_id		integer PRIMARY KEY DEFAULT nextval('foulseq'),
	foul_desc 	varchar(40) NOT NULL
	) WITH OIDS;

-- Offenses table
CREATE SEQUENCE offseq increment 1 minvalue 100000 maxvalue 999999 start 100000;
CREATE TABLE tbl_offenses (
	offense_id		integer PRIMARY KEY DEFAULT nextval('offseq'),
	lineup_id		integer REFERENCES tbl_lineups,
	foul_id			integer REFERENCES tbl_fouls,
	card_id			integer REFERENCES tbl_cards,
	ofns_time		integer NOT NULL CHECK (ofns_time > 0 AND ofns_time <= 120),
	ofns_stime		integer DEFAULT 0 CHECK (ofns_stime >= 0 AND ofns_stime <= 15)
	) WITH OIDS;

-- Penalty Outcomes table
CREATE SEQUENCE poseq increment 1 minvalue 1 maxvalue 9 start 1;
CREATE TABLE tbl_penoutcomes (
	penoutcome_id		integer PRIMARY KEY DEFAULT nextval('poseq'),
	po_desc				varchar(15) NOT NULL
	) WITH OIDS;

-- Penalties table
CREATE SEQUENCE penseq increment 1 minvalue 10000 maxvalue 99999 start 10000;
CREATE TABLE tbl_penalties (
	penalty_id		integer PRIMARY KEY DEFAULT nextval('penseq'),
	lineup_id		integer REFERENCES tbl_lineups,
	foul_id			integer REFERENCES tbl_fouls,
	penoutcome_id	integer REFERENCES tbl_penoutcomes,
	pen_time		integer NOT NULL CHECK (pen_time > 0 AND pen_time <= 120),
	pen_stime		integer DEFAULT 0 CHECK (pen_stime >= 0 AND pen_stime <= 15)
	) WITH OIDS;
	
-- Penalty Shootouts table
CREATE SEQUENCE shootoutseq increment 1 minvalue 100000 maxvalue 999999 start 100000;
CREATE TABLE tbl_penaltyshootouts (
    penshootout_id  integer PRIMARY KEY DEFAULT nextval('shootoutseq'),
    lineup_id       integer REFERENCES tbl_lineups,
    round_id        integer REFERENCES tbl_rounds,
    penoutcome_id   integer REFERENCES tbl_penoutcomes
    ) WITH OIDS;
    
-- Penalty Shootout opener table
CREATE TABLE tbl_penshootoutopeners (
    match_id    integer REFERENCES tbl_matches,
    country_id  integer REFERENCES tbl_countries,
    PRIMARY KEY (match_id, country_id)
    ) WITH OIDS;
    
-- Substitutions table
CREATE SEQUENCE subsseq increment 1 minvalue 100000 maxvalue 999999 start 100000;
CREATE TABLE tbl_substitutions (
	subs_id			integer PRIMARY KEY DEFAULT nextval('subsseq'),
	subs_time		integer NOT NULL CHECK (subs_time > 0 AND subs_time <= 120),
	subs_stime		integer DEFAULT 0 CHECK (subs_stime >= 0 AND subs_stime <= 15)
	) WITH OIDS;

-- In Substitutions table
CREATE TABLE tbl_insubstitutions (
	subs_id			integer REFERENCES tbl_substitutions,
	lineup_id		integer	REFERENCES tbl_lineups,
	PRIMARY KEY (subs_id, lineup_id)
	) WITH OIDS;

-- Out Substitutions table
CREATE TABLE tbl_outsubstitutions (
	subs_id			integer REFERENCES tbl_substitutions,
	lineup_id		integer	REFERENCES tbl_lineups,
	PRIMARY KEY (subs_id, lineup_id)
	) WITH OIDS;

-- Switch Positions table
CREATE SEQUENCE switchseq increment 1 minvalue 100000 maxvalue 999999 start 100000;
CREATE TABLE tbl_switchpositions (
	switch_id			integer PRIMARY KEY DEFAULT nextval('switchseq'),
	lineup_id			integer REFERENCES tbl_lineups,
	switchposition_id	integer REFERENCES tbl_positions,
	switch_time			integer NOT NULL CHECK (switch_time > 0 AND switch_time < 120),
	switch_stime		integer DEFAULT 0 CHECK (switch_stime >= 0 AND switch_stime <= 15)
	) WITH OIDS;
