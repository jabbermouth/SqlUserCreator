#!/bin/bash

if [$SQL_NODES -eq ""]; then
  SQL_NODES=$SQL_SERVER
fi

SID=$(echo -n $ACCOUNT_PASSWORD | md5sum | cut -c1-32)
SID=${SID^^}

while IFS=',' read -ra ADDR; do
  for i in "${ADDR[@]}"; do
    SQL_STATEMENTS="IF NOT EXISTS 
        (SELECT name  
        FROM master.sys.server_principals
        WHERE name = '$ACCOUNT_USER')
    BEGIN
        CREATE LOGIN [$ACCOUNT_USER] WITH PASSWORD='$ACCOUNT_PASSWORD', DEFAULT_DATABASE=[$SQL_DATABASE], CHECK_POLICY=OFF, SID=0x$SID
    END"

    /usr/local/bin/mssql -s "$i" -d "$SQL_DATABASE" -u "$SQL_USER" -p "$SQL_PASSWORD" --query "$SQL_STATEMENTS"
  done
done <<< "$SQL_NODES"

SQL_STATEMENTS="USE [$SQL_DATABASE]

IF NOT EXISTS
    (SELECT name
     FROM sys.database_principals
     WHERE name = '$ACCOUNT_USER')
BEGIN
    CREATE USER [$ACCOUNT_USER] FOR LOGIN [$ACCOUNT_USER] WITH DEFAULT_SCHEMA=[dbo]
    ALTER ROLE db_owner ADD MEMBER [$ACCOUNT_USER]
END"

/usr/local/bin/mssql -s $SQL_SERVER -d "$SQL_DATABASE" -u "$SQL_USER" -p "$SQL_PASSWORD" --query "$SQL_STATEMENTS"
