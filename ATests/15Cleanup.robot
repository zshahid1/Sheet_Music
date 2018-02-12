*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot
Library           DatabaseLibrary
Library           String
#Resource          DCI2.html

*** Test Cases ***

#17686 - Cleanup

Turn Cleanup on
    set workflow.config action on/off  ON  ${CleanUp}

Stop scheduler
    stop sheetmusic scheduler

start sheetmusic and Sting scheduler
    Start SheetMusic Scheduler

Wait for cleanup
    sleep  1m

Check if scheduler removes files from working folder
    Open Predefined APP Server Connection
    SFA-APP1.directory should not exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342
    SFA-APP1.file should not exist  C:\\Sheetmusic\\MusicSales\\Working\\smd_134342

Check status update
    connect
    check if exists in database  SELECT [Status] = 'Completed' FROM [workflow].[dbo].[WorkflowEntity]

Check Sheetmusic.cleanup journal
    Check Queue Message journal Value  2  .\\private$\\SheetMusic.cleanup

#Stop SheetMusic Scheduler
#    stop sheetmusic scheduler

#Change workflow.config cleanup instance to 0
#    set workflow.config action on/off  OFF  ${CleanUp}