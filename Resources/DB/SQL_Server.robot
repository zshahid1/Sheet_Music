*** Settings ***
#Resource  ../Resources/Keywords.robot
Library  String
#Library  Dialogs
Library  Selenium2Library
Library  DatabaseLibrary
Library  OperatingSystem
Library  SSHLibrary
Library  String

*** Variables ***

${DB_USER_NAME} =  sa
${DB_USER_PASSWORD} =  Pa55word
${DB_HOST} =  192.168.245.60
${DB_PORT} =  9433
${PREVIOUS_ROW_COUNT}
${DB_NAME} =  SheetMusicDirectCatalogue

*** Keywords ***

Connect
    Connect to database  pymssql  ${DB_NAME}  ${DB_USER_NAME}  ${DB_USER_PASSWORD}  ${DB_HOST}  ${DB_PORT}

Cleardown SheetMusic Database
    Connect
   ${sqlstring}  catenate  DELETE FROM [SheetMusicDirectCatalogue].[dbo].[CatalogueRecord];
    ...  DELETE FROM [SheetMusicDirectCatalogue].[dbo].[Log];
    ...  DELETE FROM [SheetMusicDirectCatalogue].[dbo].[SyncDetails];
    execute sql string  ${sqlstring}


