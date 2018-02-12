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

#17681 - Mets creation

Check if mets file created
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342\\smd_134342_Mets.xml

Check Mets file status
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'MetsFileCreated'

Check SheetMusic.Preprocess queue
    Check Queue Message journal Value  1  .\\private$\\sheetmusic.processitems

#Negative path needed to displays Metscreation failed?
