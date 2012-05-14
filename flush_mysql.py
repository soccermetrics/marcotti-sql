#!/usr/bin/python
#
# flush_mysql.py - Flush FMRD database
# Remove FMRD database if exists and create blank FMRD database w/o schema

import MySQLdb as mdb
import sys

dbname = sys.argv[1]
dbuser = sys.argv[2]
dbpasswd = sys.argv[3]

db = None

try:
    db = mdb.connect(user=dbuser,passwd=dbpasswd)
    c = db.cursor()
    c.execute("SET FOREIGN_KEY_CHECKS = 0")
    
    dropCmd = "DROP DATABASE IF EXISTS %s" % dbname
    createCmd = "CREATE DATABASE %s" % dbname
    c.execute(dropCmd)
    c.execute(createCmd)
    c.commit()
except mdb.Error, e:
    print "Error %d: %s"% (e.args[0],e.args[1])
    sys.exit(1)
finally:
    if db:
        db.close()
