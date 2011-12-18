#!/usr/bin/perl

#    Title: PreloadSqliteTables.pl
# Synopsis: Load FMRD tables that we prefer to pre-load (SQLite3 version)
#   Format: ./PreloadSqliteTables.pl
#     Date: 2011-12-17
#  Version: 1.0
#   Author: Howard Hamilton, Soccermetrics Research & Consulting, LLC

use DBI;
use DBI qw(:sql_types);
use DBD::SQLite;
use Term::ReadKey;

# declare subroutines
sub trim($);
sub rtrim($);

($dbname) = @ARGV;

# connect to database
print("Connecting to database file $dbname\n");
$dbh = DBI->connect("dbi:SQLite:dbname=$dbname","","");
$dbh->do("PRAGMA foreign_keys = ON");

print("Enter maximum number of league or shootout rounds: ");
chomp(my $roundnum = <STDIN>);
print("[A]lpha or [N]umeric group names: ");
chomp(my $groupchar = <STDIN>);

print "Preload tables...\n";

# Populate database tables
load_confederations();
load_countries();
load_timezones();
load_rounds($roundnum);
load_group_rounds();
load_knockout_rounds();
load_matchdays();
load_phases();
load_groups($groupchar);
load_surfaces();
load_penoutcomes();
load_fieldpos();
load_flankpos();
load_positions();
load_wxconditions();
load_goalstrikes();
load_goalevents();
load_cards();
load_fouls();

print("Disconnecting database file $dbname\n");
# close database
$dbh->disconnect();

print("Database pre-loading complete.\n");

# ---------------------------------------------------------
# Subroutines
# ---------------------------------------------------------

# load confederations subroutine
sub load_confederations {
    print("Loading Confederations table\n");
	# open list file
	open(LIST,"lists/confed-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_confederations(confed_id, confed_name) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		my ($cstr) = split;
		$sth->execute($id,$cstr);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);	
}

# load country table
sub load_countries {
    print("Loading Countries table\n");
	# open list file -- 2 columns: country and confederation (comma-delimited)
	open(LIST,"lists/country-list.dat");

	# prepare query and insertion statements
	$sth = $dbh->prepare("INSERT INTO tbl_countries(country_id,confed_id,cty_name) VALUES (?,?,?)");
	$qth = $dbh->prepare("SELECT confed_id FROM tbl_confederations WHERE confed_name=?");
	
	$id = 100;
	# execute
	while (<LIST>) {
		chomp;
		my (@cstr) = split(/,\s+/);
		$qth->execute($cstr[1]) || die "Could not execute query: " . $qth->$errstr;
		my @data;
		while (@data = $qth->fetchrow_array) {
			my $confedid = $data[0];
			$sth->execute($id,$confedid,$cstr[0]);
			$id++;
		}
		$qth->finish();
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);
}

# load time zones table
sub load_timezones {
    print("Loading Time Zones table\n");
	# open list file -- 3 columns: confederation, country, and offset
	open(LIST,"lists/timezone-list.dat");
	
	# prepare query and insertion statements
	$sth = $dbh->prepare("INSERT INTO tbl_timezones(timezone_id,confed_id,tz_name,tz_offset) VALUES (?,?,?,?)");
	$qth = $dbh->prepare("SELECT confed_id FROM tbl_confederations WHERE confed_name=?");
	
	$id = 100;
	# execute
	while (<LIST>) {
		chomp;
		my (@cstr) = split(/,\s+/);
		$qth->execute(trim($cstr[0])) || die "Could not execute query: " . $qth->$errstr;
		while (my @data = $qth->fetchrow_array) {
			my $confedid = $data[0];
			$sth->execute($id,$confedid,trim($cstr[1]),trim($cstr[2]));
			$id++;
		}
		$qth->finish();
	}
	
	# commit
	$dbh->commit();	
	# close list file
	close(LIST);	
}

# load competition phases table
sub load_phases {
    print("Loading Competition Phases table\n");
	# open list file
	open(LIST,"lists/phase-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_phases(phase_id,phase_desc) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load groups table
sub load_groups {
    print("Loading Groups table\n");
	$groupkey = $_[0];	# get group identifier
	
	if (uc($groupkey) eq 'A') {
	    open(LIST,"lists/group-letters-list.dat");
    }
    elsif (uc($groupkey) eq 'N') {
        open(LIST,"lists/group-numbers-list.dat");
    }
    else {
        print "ERROR: Identifier must be 'A' or 'N'.  Groups table not populated.\n";
        return;
    }
	
	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_groups(group_id,group_desc) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
}

# load rounds table
sub load_rounds {
    print("Loading Rounds table\n");
	$maxrounds = $_[0];	# get maximum number of rounds
	
	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_rounds(round_id,round_desc) VALUES (?,?)");
	
	$id = 10;
	for ($i=1; $i<=$maxrounds; $i++) {
		$cstr = "Round " . $i;
		$sth->execute($id,$cstr);
		$id++;
	}
	# commit
	$dbh->commit();
}

# load group rounds table
sub load_group_rounds {
    print("Loading Group Rounds table\n");
	# open list file
	open(LIST,"lists/group-round-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_grouprounds(grpround_id,grpround_desc) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load knockout rounds table
sub load_knockout_rounds {
    print("Loading Knockout Rounds table\n");
	# open list file
	open(LIST,"lists/knockout-round-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_knockoutrounds(koround_id,koround_desc) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load knockout round matchday table
sub load_matchdays {
    print("Loading Knockout Round Matchdays table\n");
	# open list file
	open(LIST,"lists/matchday-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_matchdays(matchday_id,matchday_desc) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load venue playing surfaces table
sub load_surfaces {
    print("Loading Playing Surfaces table\n");
	# open list file
	open(LIST,"lists/fieldsurface-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_venuesurfaces(venuesurface_id,vensurf_desc) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load penalty outcomes table
sub load_penoutcomes {
    print("Loading Penalty Outcomes table\n");
	# open list file
	open(LIST,"lists/penalties-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_penoutcomes(penoutcome_id,po_desc) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load field position table
sub load_fieldpos {
    print("Loading Field Positions table\n");
	# open list file
	open(LIST,"lists/fieldname-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_fieldnames(posfield_id,posfield_name) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load flank name table
sub load_flankpos {
    print("Loading Flank Names table\n");
	# open list file
	open(LIST,"lists/flankname-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_flanknames(posflank_id,posflank_name) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		my (@cstr) = $_;
		if ($cstr[0] eq "undef") {
			$cstr[0] = undef;
		}
		$sth->execute($id,$cstr[0]);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load positions table
sub load_positions {
    print("Loading Positions table\n");
    # open list file -- 2 columns (space-delimited)
    open(LIST, "lists/position-list.dat");
    
    # prepare query and insertion statements
    $sth = $dbh->prepare("INSERT INTO tbl_positions(position_id,posfield_id,posflank_id) VALUES (?,?,?)");
    $qth[0] = $dbh->prepare("SELECT posflank_id FROM tbl_flanknames WHERE posflank_name=?");
    $qth[1] = $dbh->prepare("SELECT posfield_id FROM tbl_fieldnames WHERE posfield_name=?");
    $null = $dbh->prepare("SELECT posflank_id FROM tbl_flanknames WHERE posflank_name IS NULL");
    
    $null->execute();
    @nullval = $null->fetchrow_array;
    
    $id = 10;
    # execute
    while(<LIST>) {
        chomp;
		my (@cstr) = split;
		$qth[0]->execute($cstr[0]) || die "Could not execute query: " . $qth[0]->$errstr;
		$qth[1]->execute($cstr[1]) || die "Could not execute query: " . $qth[1]->$errstr;		
		my @data1, @data2;
		while (@data2 = $qth[1]->fetchrow_array) {
			my $flankid, $fieldid;
			if ($cstr[0] eq "undef") {
			    $flankid = $nullval[0];
			} else {
			    @data1 = $qth[0]->fetchrow_array;
			    $flankid = $data1[0];
			}
			$fieldid = $data2[0];
			$sth->execute($id,$fieldid,$flankid);
			$id++;
		}
		$qth[0]->finish();
		$qth[1]->finish();      
    }
    $null->finish();    
    # commit
    $dbh->commit();
    
    # close list file
    close(LIST);
}

# load weather conditions table
sub load_wxconditions {
    print("Loading Weather Conditions table\n");
	# open list file
	open(LIST,"lists/wxcond-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_weather(weather_id,wx_conditiondesc) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load goal strikes table
sub load_goalstrikes {
    print("Loading Goal Strikes table\n");
	# open list file
	open(LIST,"lists/goalstrike-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_goalstrikes(gtstype_id,gts_desc) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load goal events table
sub load_goalevents {
    print("Loading Goal Events table\n");
	# open list file
	open(LIST,"lists/goaltype-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_goalevents(gtetype_id,gte_desc) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load cards table
sub load_cards {
    print("Loading Cards table\n");
	# open list file
	open(LIST,"lists/card-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_cards(card_id,card_type) VALUES (?,?)");
	
	$id = 1;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# load fouls table
sub load_fouls {
    print("Loading Fouls table\n");
	# open list file
	open(LIST,"lists/fouls-list.dat");

	# prepare
	$sth = $dbh->prepare("INSERT INTO tbl_fouls(foul_id,foul_desc) VALUES (?,?)");
	
	$id = 10;
	# execute
	while (<LIST>) {
		chomp;
		$sth->execute($id,$_);
		$id++;
	}
	
	# commit
	$dbh->commit();
	
	# close list file
	close(LIST);		
}

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
# Right trim function to remove trailing whitespace
sub rtrim($)
{
	my $string = shift;
	$string =~ s/\s+$//;
	return $string;
}
