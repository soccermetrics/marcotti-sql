#!/bin/bash

#    Title: installdb-fmrd-mysql.sh
# Synopsis: Setup FMRD schema and pre-load lookup tables
#   Format: ./installdb-fmrd-mysql.sh <database_name>
#     Date: 2010-08-02
#  Version: 0.8
#   Author: Howard Hamilton, Soccermetrics Research & Consulting, LLC

# load database configuration script
if [ -f auth.cfg ]
then
    . auth.cfg
fi

if [ "$#" -eq 1 ]
then

    # delete and create new database

    python flush_mysql.py $1 $DBUSER_MY $DBPASS_MY
    mysql -u $DBUSER_MY -p $DBPASS_MY $1 < fmrd-mysql.sql
    mysql -u $DBUSER_MY -p $DBPASS_MY $1 < fmrd-views.sql

    ./PreloadTables.pl $1
else
    echo "Usage: installdb-fmrd-mysql.sh <database_name>"
fi
