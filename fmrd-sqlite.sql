-- fmrd-sqlite.sql: Football Match Result Database schema for SQLite
-- Developed by: Howard Hamilton (2011-12-17)

PRAGMA foreign_keys = ON;

-- -------------------------------------------------
-- Personnel Tables
-- -------------------------------------------------

-- Confederation table
CREATE TABLE tbl_confederations (
	confed_id	integer PRIMARY KEY,
	confed_name	varchar(40) NOT NULL
	);

-- Country table
CREATE TABLE tbl_countries (
	country_id	integer PRIMARY KEY,
	confed_id	integer REFERENCES tbl_confederations(confed_id),
	cty_name	varchar(60) NOT NULL
	);

-- Field position table
CREATE TABLE tbl_fieldnames (
	posfield_id		integer PRIMARY KEY,
	posfield_name	varchar(15) NOT NULL
	);

-- Flank name table
CREATE TABLE tbl_flanknames (
	posflank_id		integer PRIMARY KEY,
	posflank_name	varchar(8) NULL
	);
	
-- Position table
CREATE TABLE tbl_positions (
	position_id		integer PRIMARY KEY,
	posfield_id		integer REFERENCES tbl_fieldnames(posfield_id),
	posflank_id		integer REFERENCES tbl_flanknames(posflank_id)
	);

-- Player table
CREATE TABLE tbl_players (
	player_id		integer PRIMARY KEY,
	country_id		integer REFERENCES tbl_countries(country_id),
	plyr_birthdate  text NOT NULL,
	plyr_firstname	varchar(20) NOT NULL,
	plyr_lastname	varchar(30) NOT NULL,
	plyr_nickname	varchar(30) NULL,
	plyr_defposid	integer REFERENCES tbl_positions(position_id)
	);
	
-- Player height/weight tracking table
CREATE TABLE tbl_playerhistory (
	playerhistory_id 	integer PRIMARY KEY,
	player_id			integer REFERENCES tbl_players(player_id),
	plyrhist_date		text,
	plyrhist_height 	numeric(3,2) DEFAULT 1.50 CHECK (plyrhist_height >= 0 AND plyrhist_height <= 2.50),
	plyrhist_weight     numeric(3,0) DEFAULT 50 CHECK (plyrhist_weight >= 0 AND plyrhist_weight <= 150)
	);

-- Manager table
CREATE TABLE tbl_managers (
	manager_id			integer PRIMARY KEY,
	country_id			integer REFERENCES tbl_countries(country_id),
	mgr_birthdate	    text NOT NULL,
	mgr_firstname		varchar(20) NOT NULL,
	mgr_lastname		varchar(30) NOT NULL,
	mgr_nickname		varchar(30) NULL
	);

-- Referee table
CREATE TABLE tbl_referees (
	referee_id			integer PRIMARY KEY,
	country_id			integer REFERENCES tbl_countries(country_id),
	ref_birthdate		text NOT NULL,
	ref_firstname		varchar(20) NOT NULL,
	ref_lastname		varchar(30) NOT NULL
	);

-- -------------------------------------------------
-- Match Overview Tables
-- -------------------------------------------------

-- Time zones table
CREATE TABLE tbl_timezones (
    timezone_id     integer PRIMARY KEY,
    confed_id       integer REFERENCES tbl_confederations(confed_id),
    tz_name         varchar(80) NOT NULL,
    tz_offset       numeric(4,2) DEFAULT 0 CHECK (tz_offset >= -12.0 AND tz_offset <= 14.0)
    );

-- Venue playing surfaces table
CREATE TABLE tbl_venuesurfaces (
    venuesurface_id     integer PRIMARY KEY,
    vensurf_desc        varchar(30) NOT NULL
    ); 

-- Competitions table
CREATE TABLE tbl_competitions (
	competition_id	integer PRIMARY KEY,
	comp_name		varchar(100) NOT NULL
	);
	
-- Competition Phases table	
CREATE TABLE tbl_phases (
    phase_id    integer PRIMARY KEY,
    phase_desc  varchar(12) NOT NULL
    );
    
-- Groups table    
CREATE TABLE tbl_groups (
    group_id    integer PRIMARY KEY,
    group_desc  varchar(2) NOT NULL
    );
    
-- Group Rounds table
CREATE TABLE tbl_grouprounds (
    grpround_id      integer PRIMARY KEY,
    grpround_desc    varchar(40) NOT NULL
    );
    
-- Knockout Rounds table    
CREATE TABLE tbl_knockoutrounds (
    koround_id      integer PRIMARY KEY,
    koround_desc    varchar(40) NOT NULL
    );

-- (League) Rounds table	
CREATE TABLE tbl_rounds (
	round_id	integer PRIMARY KEY,
	round_desc 	varchar(20) NOT NULL
	);
	
-- Matchdays table
CREATE TABLE tbl_matchdays (
    matchday_id    integer PRIMARY KEY,
    matchday_desc  varchar(12) NOT NULL
    );	

-- Teams table	
CREATE TABLE tbl_teams (
	team_id 	integer PRIMARY KEY,
    country_id  integer REFERENCES tbl_countries(country_id),
	tm_name	    varchar(50) NOT NULL
	);		
	
-- Venues table
CREATE TABLE tbl_venues (
	venue_id		integer PRIMARY KEY,
	team_id			integer REFERENCES tbl_teams(team_id),
	country_id		integer REFERENCES tbl_countries(country_id),
	timezone_id		integer REFERENCES tbl_timezones(timezone_id),
	ven_city		varchar(40) NOT NULL,
	ven_name		varchar(40) NOT NULL,
	ven_altitude	numeric(4,0) DEFAULT 0 CHECK (ven_altitude >= -200
								 AND ven_altitude <= 4500),
	ven_latitude	numeric(8,6) DEFAULT 0.000000 CHECK (ven_latitude >= -90.000000
								 AND ven_latitude <=  90.000000),
	ven_longitude	numeric(9,6) DEFAULT 0.000000 CHECK (ven_longitude >= -180.000000
								 AND ven_longitude <=  180.000000)
	);

-- Venue surface/dimensions/capacity historical tracking table
CREATE TABLE tbl_venuehistory (
    venuehistory_id     integer PRIMARY KEY,
    venue_id            integer REFERENCES tbl_venues(venue_id),
    venuehist_date      text,
    venuesurface_id     integer REFERENCES tbl_venuesurfaces(venuesurface_id),
    venue_length		integer DEFAULT 105 CHECK (venue_length >= 90 AND venue_length <= 120),
    venue_width			integer DEFAULT 68 CHECK (venue_width >= 45 AND venue_width <= 90),
    venuehist_capacity  integer DEFAULT 0 CHECK (venuehist_capacity >= 0),
    venuehist_seats     integer DEFAULT 0 CHECK (venuehist_seats >= 0)
    );
		
-- Match table
CREATE TABLE tbl_matches (
	match_id				integer PRIMARY KEY,
	match_date				text,
	match_firsthalftime	 	integer DEFAULT 45 CHECK (match_firsthalftime > 0),
	match_secondhalftime 	integer DEFAULT 45 CHECK (match_secondhalftime >= 0),
	match_firstovertime     integer DEFAULT 0 CHECK (match_firstovertime >= 0),
	match_secondovertime    integer DEFAULT 0 CHECK (match_secondovertime >= 0),
	match_attendance		integer DEFAULT 0 CHECK (match_attendance >= 0),
	competition_id			integer REFERENCES tbl_competitions(competition_id),
	phase_id                integer REFERENCES tbl_phases(phase_id),
	venue_id				integer REFERENCES tbl_venues(venue_id),
	referee_id				integer REFERENCES tbl_referees(referee_id)
	);
	
-- Lineup table
CREATE TABLE tbl_lineups (
	lineup_id		integer PRIMARY KEY,
	match_id		integer REFERENCES tbl_matches(match_id),
	team_id			integer REFERENCES tbl_teams(team_id),
	player_id		integer REFERENCES tbl_players(player_id),
	position_id		integer REFERENCES tbl_positions(position_id),
	lp_starting		boolean DEFAULT FALSE,
	lp_captain		boolean DEFAULT FALSE
	);
		
-- ---------------------------------------
-- Linking tables to Match Overview tables
-- ---------------------------------------

-- League matches
CREATE TABLE tbl_leaguematches (
    match_id    integer REFERENCES tbl_matches(match_id),
	round_id	integer REFERENCES tbl_rounds(round_id),
	PRIMARY KEY (match_id, round_id)
	);   

-- Group matches
CREATE TABLE tbl_groupmatches (
    match_id    integer REFERENCES tbl_matches(match_id),
    grpround_id integer REFERENCES tbl_grouprounds(grpround_id),
    group_id    integer REFERENCES tbl_groups(group_id),
	round_id	integer REFERENCES tbl_rounds(round_id),
	PRIMARY KEY (match_id, grpround_id, group_id, round_id)
	);   

-- Knockout matches
CREATE TABLE tbl_knockoutmatches (
    match_id    integer REFERENCES tbl_matches(match_id),
	koround_id	integer REFERENCES tbl_knockoutrounds(koround_id),
	matchday_id integer REFERENCES tbl_matchdays(matchday_id),
	PRIMARY KEY (match_id, koround_id, matchday_id)
	);   

-- Home/away teams
CREATE TABLE tbl_hometeams (
	match_id	integer REFERENCES tbl_matches(match_id),
	team_id		integer	REFERENCES tbl_teams(team_id),
	PRIMARY KEY (match_id, team_id)
	);
	
CREATE TABLE tbl_awayteams (
	match_id	integer REFERENCES tbl_matches(match_id),
	team_id		integer	REFERENCES tbl_teams(team_id),
	PRIMARY KEY (match_id, team_id)
	);	

-- Home/away managers	
CREATE TABLE tbl_homemanagers (
	match_id	integer REFERENCES tbl_matches(match_id),
	manager_id	integer	REFERENCES tbl_managers(manager_id),
	PRIMARY KEY (match_id, manager_id)
	);
	
CREATE TABLE tbl_awaymanagers (
	match_id	integer REFERENCES tbl_matches(match_id),
	manager_id	integer	REFERENCES tbl_managers(manager_id),
	PRIMARY KEY (match_id, manager_id)
	);	
	
-- -------------------------------------------------
-- Environmental Condition Tables
-- -------------------------------------------------

-- Environment main table
CREATE TABLE tbl_environments (
	enviro_id			integer PRIMARY KEY,
	match_id			integer REFERENCES tbl_matches(match_id),
	env_kickofftime		time,
	env_temperature 	numeric(4,2) CHECK (env_temperature >= -15.0 
						        		AND env_temperature <= 45.0)
	);

-- Weather conditions table
CREATE TABLE tbl_weather (
	weather_id			integer PRIMARY KEY,
	wx_conditiondesc	varchar(40) NOT NULL
	);

-- ------------------------------------------	
-- Linking tables	to Weather Condition tables
-- ------------------------------------------

-- Kickoff weather condition table
CREATE TABLE tbl_weatherkickoff (
	enviro_id		integer REFERENCES tbl_environments(enviro_id),
	weather_id		integer REFERENCES tbl_weather(weather_id),
	PRIMARY KEY (enviro_id, weather_id)
	);

-- Halftime weather condition table
CREATE TABLE tbl_weatherhalftime (
	enviro_id		integer REFERENCES tbl_environments(enviro_id),
	weather_id		integer REFERENCES tbl_weather(weather_id),
	PRIMARY KEY (enviro_id, weather_id)
	);

-- Fulltime weather condition table
CREATE TABLE tbl_weatherfulltime (
	enviro_id		integer REFERENCES tbl_environments(enviro_id),
	weather_id		integer REFERENCES tbl_weather(weather_id),
	PRIMARY KEY (enviro_id, weather_id)
	);

-- -------------------------------------------------
-- Match Event Tables
-- -------------------------------------------------

-- Goal strikes table
CREATE TABLE tbl_goalstrikes (
	gtstype_id		integer PRIMARY KEY,
	gts_desc		varchar(15) NOT NULL
	);
	
-- Goal events table
CREATE TABLE tbl_goalevents (
	gtetype_id		integer PRIMARY KEY,
	gte_desc		varchar(30) NOT NULL
	);

-- Goals table	
CREATE TABLE tbl_goals (
	goal_id			integer PRIMARY KEY,
	team_id			integer REFERENCES tbl_teams(team_id),
	lineup_id		integer REFERENCES tbl_lineups(lineup_id),
	gtstype_id		integer REFERENCES tbl_goalstrikes(gtstype_id),
	gtetype_id		integer REFERENCES tbl_goalevents(gtetype_id),
	gls_time		integer NOT NULL CHECK (gls_time > 0 AND gls_time <= 120),
	gls_stime		integer DEFAULT 0 CHECK (gls_stime >= 0 AND gls_stime <= 15)
	);
	
-- Cards table
CREATE TABLE tbl_cards (
	card_id			integer PRIMARY KEY,
	card_type		varchar(12) NOT NULL
	);
	
-- Fouls table
CREATE TABLE tbl_fouls (
	foul_id		integer PRIMARY KEY,
	foul_desc 	varchar(40) NOT NULL
	);

-- Offenses table
CREATE TABLE tbl_offenses (
	offense_id		integer PRIMARY KEY,
	lineup_id		integer REFERENCES tbl_lineups(lineup_id),
	foul_id			integer REFERENCES tbl_fouls(foul_id),
	card_id			integer REFERENCES tbl_cards(card_id),
	ofns_time		integer NOT NULL CHECK (ofns_time > 0 AND ofns_time <= 120),
	ofns_stime		integer DEFAULT 0 CHECK (ofns_stime >= 0 AND ofns_stime <= 15)
	);

-- Penalty Outcomes table
CREATE TABLE tbl_penoutcomes (
	penoutcome_id	integer PRIMARY KEY,
	po_desc			varchar(15) NOT NULL
	);

-- Penalties table
CREATE TABLE tbl_penalties (
	penalty_id		integer PRIMARY KEY,
	lineup_id		integer REFERENCES tbl_lineups(lineup_id),
	foul_id			integer REFERENCES tbl_fouls(foul_id),
	penoutcome_id	integer REFERENCES tbl_penoutcomes(penoutcome_id),
	pen_time		integer NOT NULL CHECK (pen_time > 0 AND pen_time <= 120),
	pen_stime		integer DEFAULT 0 CHECK (pen_stime >= 0 AND pen_stime <= 15)
	);
	
-- Penalty Shootouts table
CREATE TABLE tbl_penaltyshootouts (
    penshootout_id  integer PRIMARY KEY,
    lineup_id       integer REFERENCES tbl_lineups(lineup_id),
    round_id        integer REFERENCES tbl_rounds(round_id),
    penoutcome_id   integer REFERENCES tbl_penoutcomes(penoutcome_id)
    );
    
-- Penalty Shootout opener table
CREATE TABLE tbl_penshootoutopeners (
    match_id    integer REFERENCES tbl_matches(match_id),
    team_id     integer REFERENCES tbl_teams(team_id),
    PRIMARY KEY (match_id, team_id)
    );
    
-- Substitutions table
CREATE TABLE tbl_substitutions (
	subs_id			integer PRIMARY KEY,
	subs_time		integer NOT NULL CHECK (subs_time > 0 AND subs_time <= 120),
	subs_stime		integer DEFAULT 0 CHECK (subs_stime >= 0 AND subs_stime <= 15)
	);

-- In Substitutions table
CREATE TABLE tbl_insubstitutions (
	subs_id			integer REFERENCES tbl_substitutions(subs_id),
	lineup_id		integer	REFERENCES tbl_lineups(lineup_id),
	PRIMARY KEY (subs_id, lineup_id)
	);

-- Out Substitutions table
CREATE TABLE tbl_outsubstitutions (
	subs_id			integer REFERENCES tbl_substitutions(subs_id),
	lineup_id		integer	REFERENCES tbl_lineups(lineup_id),
	PRIMARY KEY (subs_id, lineup_id)
	);

-- Switch Positions table
CREATE TABLE tbl_switchpositions (
	switch_id			integer PRIMARY KEY,
	lineup_id			integer REFERENCES tbl_lineups(lineup_id),
	switchposition_id	integer REFERENCES tbl_positions(position_id),
	switch_time			integer NOT NULL CHECK (switch_time > 0 AND switch_time < 120),
	switch_stime		integer DEFAULT 0 CHECK (switch_stime >= 0 AND switch_stime <= 15)
	);

