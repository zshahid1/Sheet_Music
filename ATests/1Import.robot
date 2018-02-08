*** Settings ***
Library  OperatingSystem
Resource  ../Resources/DB/SQL_Server.robot
#Resource  ../Resources/Keywords.robot
Suite Teardown  Cleardown SheetMusic Database

*** Variables ***
${DATABASE}          192.168.245.60
@{DB_LOGIN}          sa  Pa55word
${DATABASE_TITLE}    SheetMusicDirectCatalogue


*** Test Cases ***
# 17933 - Create Utility to aggregate metatdata
# Description - Imports metadata from SheetMusicDirect's API into a DB so we can query for metadata

#1. Database is empty
#    [Tags]  17933
#    Connect
#    check if not exists in database  SELECT LastSyncedDate FROM [SheetMusicDirectCatalogue].[dbo].[SyncDetails]
#
#2. Entering in new data
#    Run SheetMusicMetadataImporter  1.0.21.16
#
#3. Database Received data and displays records
#    [Tags]
#    Connect
#    check if exists in database  Select * FROM [SheetMusicDirectCatalogue].[dbo].[CatalogueRecord]
#
#4. Logging Start and Completion of process
#    [Tags]
#    Connect
#    check if exists in database  SELECT TOP 1000 [Id],[LogDateTime],[Message],[LogTypeId] FROM[SheetMusicDirectCatalogue].[dbo].[Log] WHERE [Message] LIKE 'started%' OR [Message] LIKE 'Completed%'
#
#7.1 Filtering out Hal Leonard records - Check CatalogueRecord Table does not contain CatalogueReference smd_h
#    [Tags]
#    Connect
#    check if not exists in database  SELECT * FROM [SheetMusicDirectCatalogue].[dbo].[CatalogueRecord] WHERE CatalogueReference ='smd_h'
#
#7.2 Check CatalogueRecord Table contain CatalogueReference smd_000001
#    [Tags]
#    Connect
#    check if exists in database  SELECT * FROM [SheetMusicDirectCatalogue].[dbo].[CatalogueRecord] WHERE CatalogueReference ='smd_000001'
#
#8. Music Sales in Batches
#    [Tags]
#    Connect
#    check if exists in database  SELECT * FROM [SheetMusicDirectCatalogue].[dbo].[Log] WHERE [Message] LIKE 'import has%';