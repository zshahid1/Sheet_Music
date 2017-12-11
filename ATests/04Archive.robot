*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot


*** Variables ***

${DB_USER_NAME} =  sa
${DB_USER_PASSWORD} =  Pa55word
${DB_HOST} =  192.168.245.60
${DB_PORT} =  9433
${PREVIOUS_ROW_COUNT}
${DB_NAME} =  SheetMusicDirectCatalogue

*** Test Cases ***

#18078 - Archiving for Music Sales

Check file exists in Working folder
    Open Predefined APP Server Connection
    SFA-APP1.directory should exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_147709

Check Queue Message Value for Copy to archive
    Check Queue Message journal Value  1  .\\private$\\sheetmusic.copytoarchive

Check if scheduler updates to CopiedToArchive
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'CopiedToArchive'


Check Queue Message Value for PreProcess
    Check Queue Message journal Value  1  .\\private$\\sheetmusic.processitems

