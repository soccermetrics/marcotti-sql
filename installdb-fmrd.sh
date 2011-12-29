#!/bin/bash

#    Title: installdb-fmrd.sh
# Synopsis: Setup FMRD schema and pre-load lookup tables
#   Format: ./installdb-fmrd.sh <database_name>
#     Date: 2010-08-02
#  Version: 0.8
#   Author: Howard Hamilton, Soccermetrics Research & Consulting, LLC

if [ "$#" -eq 1 ]
then
    dropdb $1
    createdb $1

    psql -f fmrd.sql $1
    psql -f fmrd-views.sql $1

    ./PreloadTables.pl $1
else
    echo "Usage: installdb-fmrd.sh <database_name>"
fi
