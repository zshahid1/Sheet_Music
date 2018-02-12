*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot

*** Variables ***

${DB_USER_NAME} =  sa
${DB_USER_PASSWORD} =  Pa55word
${DB_HOST} =  192.168.245.60
${DB_PORT} =  9433
${PREVIOUS_ROW_COUNT}
${DB_NAME} =  SheetMusicDirectCatalogue

*** Test Cases ***
# 17680 - Validate Music Sales Submission

Check if file in Working folder
    Open Predefined APP Server Connection
    SFA-APP1.directory should exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342
    SFA-APP1.file should exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342\\smd_134342.pdf


Check if scheduler converts metadata file to XML
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342\\smd_134342_Metadata.xml

Check if status updates to SubmissionValid
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'SubmissionValid'

#Check if message appears in SheetMusic.CopyToArchive - removed from WorkflowDB
#    Check Queue Message journal Value  1  .\\private$\\sheetmusic.copytoarchive
