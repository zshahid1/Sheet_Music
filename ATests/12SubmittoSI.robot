*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot

*** Variables ***


*** Test Cases ***

# 17685:Submit to SI

#ftpSubmission
#   start sheetmusic scheduler
#    Run FTP file submission for SheetMusic
#    sleep  8s

Check message on SI
    Check Queue Message journal Value  2  .\\private$\\SheetMusic.submittosi

Check workflow for submitted For Ingest
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'SubmittedForIngest'

Check any errors
    connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntity] WHERE Status LIKE 'SubmitToSIFailed'


