#!/bin/bash

#    Title: installdb-fmrd-sqlite.sh
# Synopsis: Setup FMRD schema (SQLite version) and pre-load lookup tables
#   Format: ./installdb-fmrd-sqlite.sh <filename.db>
#     Date: 2011-12-17
#  Version: 0.8
#   Author: Howard Hamilton, Soccermetrics Research & Consulting, LLC

if [ "$#" -eq 1 ]
then
    echo "Setting up database file: $1"
    echo "Creating SQL tables..."
    sqlite3 -batch $1 < fmrd-sqlite.sql
    echo "Creating SQL views..."
    sqlite3 -batch $1 < fmrd-views-sqlite.sql
    ./PreloadSqliteTables.pl $1
else
    echo "Usage: installdb-fmrd-sqlite.sh <filename.db>"
fi
