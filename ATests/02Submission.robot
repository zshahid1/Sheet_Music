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
# 17056 - Receive Submission from Music sales
# Descrition - Digital sheet music to be delivered to FTP & automatically picked up for ingest

ftpSubmission
    start sheetmusic scheduler
    stop sting scheduler
    Run FTP file submission for SheetMusic

Workflow entity status
    sleep  27s
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%Submitted'

Check Workflow entity type id 69
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntity] WHERE [WorkflowEntityTypeID] = '69'

Check if file in Working folder
    Open Predefined APP Server Connection
    SFA-APP1.directory should exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342

Stop SheetMusic Scheduler
    stop sheetmusic scheduler

#Check Queue Message Value for Copy to archive - removed from WorkflowDB
#    Check Queue Message journal Value  1  .\\private$\\sheetmusic.copytoarchive

Scheduler should delete submission from FTP
    SSHLibrary.Open Connection    192.168.246.101
    SSHLibrary.Login    Administrator    Pa55word
    SSHLibrary.File should not exist  /D/ECO/FTPUnsecure/SheetMusic MusicSales/smd_134342.zip
