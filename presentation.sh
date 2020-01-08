#!/bin/bash
mysql -uroot -pcloudera -e 'CREATE DATABASE presentation CHARACTER SET UTF8'
mysql -uroot -pcloudera presentation < ./presentation.sql
