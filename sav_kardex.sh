#!/bin/bash
NOW=$(date +%F)
mysqldump -u root -premi kardex> ./public/dump_kardexIII$NOW.sql
