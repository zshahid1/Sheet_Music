*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
#Library  Dialogs
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot

*** Test Cases ***

#19103 - Re-submission/duplication - Check Duplicate Entity and Content

Run first FTP file submission
    start sheetmusic scheduler
    run ftp file submission for sheetmusic

Positive - DuplicateEntityNotFound in the history
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateEntityNotFound'

Wait for submission to finish
    sleep  27s

Check duplicate submission = DuplicateEntityFound, NoNewContentFound
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateEntityFound'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NoNewContentFound'


#Has been put into 20ResubNCSM
#Run duplicate file with different pdf
#    Run FTP duplicate file different pdf submission for SheetMusic
#
#Wait for different pdf submission to finish
#    sleep  27s
#
#Check DuplicateEntityFound and NoNewContentFound in the history
#    connect
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateEntityFound'
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NewContentFound'

#Force new content found scenario:
#a: make sure you have put a submission through to completed (follow new submission above) so that we have a submission to "resubmit" against.
#b: amend the same submission by replacing the pdf with another one
#c: resubmit to SheetMusic
#Then in the WorkflowEntityActivity table there should be a status DuplicateEntityFound and NewContentFound in the history

