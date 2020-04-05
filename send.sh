#!/bin/bash
sqlite3 mercuryms.sqlite "$(awk 'BEGIN {print "PRAGMA FOREIGN_KEYS = ON;"} /received/ {print "INSERT INTO SENT_MEDIA (MEDIA_ID) VALUES("$1");";}' <(sqlite3 mercuryms.sqlite "SELECT ID, PHONE_NUMBER, URI FROM MEDIA WHERE ID NOT IN (SELECT MEDIA_ID FROM SENT_MEDIA)" | timeout $TIMEOUT_SECONDS netcat $HOST $PORT))"
