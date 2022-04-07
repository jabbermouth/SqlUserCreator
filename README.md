# Overview

This allows a user account to be created in the specified database from the command line. TO use this an account with `ALTER ANY LOGIN` and either `ALTER ANY ROLE` or be in `db_owner` for the target database.

## Purpose

This was developed to be used as part of a CI/CD process to generate a database account with a random and unknown to humans password. The specific use case would see it used along with Helm and Kubernetes.

## From Docker

```
docker run -it --rm -e SQL_SERVER=your.sql.server -e SQL_DATABASE=YourDatabaseName -e SQL_USER=UserGenerator -e SQL_PASSWORD="ChangeToSecurePassword123!" -e ACCOUNT_USER="name-of-account-to-create" -e ACCOUNT_PASSWORD="SomethingRandom123!" jabbermouth/sqlusercreator
```

`SQL_` prefixed variables are related to the target server and account with permission to create users
`ACCOUNT_` prefixed variables are related to the new account to create

## Account Setup

To create an account with the minimum required permissions across all databases, run the following:

```
CREATE LOGIN [UserGenerator] WITH PASSWORD='ChangeToSecurePassword123!'
GRANT ALTER ANY LOGIN TO [UserGenerator]
GRANT ALTER ANY ROLE TO [UserGenerator]
```

A sysadmin (e.g. sa) account will also work.
