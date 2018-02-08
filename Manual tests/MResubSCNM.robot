*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Library  Dialogs
Library  DatabaseLibrary
#Resource  ../Resources/Keywords.robot
#Resource  ../Resources/DB/SQL_Server.robot

*** Test Cases ***

#19383:Re-submission/duplication - Same content, New metadata

#Manual only!


#Check submission has already gone through to completed
#
#
#Turn ValidateContent instance to 0
#
#
#Resubmit file
#     run ftp file submission
#
#Stop scheduler
#    stop sheet music scheduler
#
#Edit mdhash element in the Mets file
#
#
#Turn ValidateContent instance to 1
#
#
#start scheduker
#    start sheet music scheduler
#
#Check status: DuplicateEntityFound to Completed
#    connect
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%DuplicateEntityFound'
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%NoNewContentFound'
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%SameContentNewMetadata'
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%ResubmitMetadataToAlephSucceeded'
#    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%Completed'
#
#Check marc file should contain a 985 datafield/tag
#
#
#Check marc file should contain a ITM datafield/tag
#
#
#Check mdRef href should contain the previous submissions mdark
#
#
#Check marc should be added to the Aleph day file
#
#
#Check file cleans up and cleanup queue