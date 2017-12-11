*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot

*** Test Cases ***

# 19386:Re-submission/duplication - New content, Same metadata
#
#a: make sure you have put a submission through to completed so that we have a submission to "resubmit" against.
#b: amend the same submission by replacing the pdf with another one
#c: resubmit to SheetMusic
#
#Scenario: duplicate submission (new content)
#	Given that we resubmit the same submission again (but with a different pdf)
#	And the previous submission has already been through to completed in SI
#	Then in the WorkflowEntityActivity table should include the statuses:
#		DuplicateEntityFound
#		NewContentFound
#		NonIngestableFilesRemoved
#		NewContentSameMetedata
#	And the mets file should NOT contain an aleph update master catalogue behavior sec
#	And it should go on to SI as normal

Check databases
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'Completed'

Different PDF duplicate file submission
    run ftp duplicate file different pdf submission for sheetmusic

Wait for submission
    sleep  25s

Check databases
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateEntityFound'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NewContentFound'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NonIngestableFilesRemoved'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NewContentSameMetadata'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'SubmittedForIngest'

#Check Mets file does NOT contain an aleph update master catalogue behavior sec
#    ${root} =  Parse XML  ${Xml File}
#    element should exist  ${root}  xpath=.//
#    XML.element should exist  ${root}  xpath=.//
#    should be equal  '${hashvalue}'  ''