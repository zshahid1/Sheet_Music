*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Library  DatabaseLibrary
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot

*** Test Cases ***
# 19104:Re-submission/duplication - Same content, Same metadata

#Same Content Same Metadata
#a: make sure you have put a submission through to completed so that we have a submission to "resubmit" against.
#b: put the same submission through again
#Scenario: duplicate submission
#	Given that we resubmit the same submission again
#	And the previous submission has already been through to completed in SI
#	Then the submission should be rejected
#	And the Cleanup procedure should execute

Run duplicate FTP file submission
    start sheetmusic scheduler
    run ftp file submission for sheetmusic

Check duplicate submission = DuplicateEntityFound - NoNewContentFound
    sleep  27s
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateEntityFound'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NoNewContentFound'

Check duplicate submission
    SSHLibrary.Open Connection    192.168.246.101
    SSHLibrary.Login    Administrator    Pa55word
    SSHLibrary.File should not exist  /D/ECO/FTPUnsecure/SheetMusic MusicSales/smd_134342.zip

Check duplicate entity queue
    Check Queue Message journal Value  4  .\\private$\\sheetmusic.CheckDuplicateEntity

Check if it goes to ingest rejected
    check if exists in database   SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'IngestRejected'
    Check Queue Message journal Value  2  .\\private$\\sheetmusic.RejectIngest

Workflow entity type id
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'Completed'

Check if any failures
    Check Queue Message journal Value  Contains No Messages  .\\private$\\sheetmusic.CheckDuplicateEntityFailed
    Check Queue Message journal Value  Contains No Messages  .\\private$\\sheetmusic.SameContentCheckMetadataFailed
    connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'RejectIngestFailed'
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'CleanupFailed'
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateContentCheckFailed'
