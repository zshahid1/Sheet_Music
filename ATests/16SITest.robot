*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot


*** Test Cases ***

# 19028 - Ensure submission passes successfully through SI

Check any errors - amend this
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'ContentStreamUpdatedFailed'

Check if Mer updated
    connect
	check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'MerUpdated'

Check SI submission
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'ContentStreamUpdated'
    Check Queue Message journal Value  2  .\\private$\\sheetmusic.cleanup

Stop sheet msic scheduler
    stop sheetmusic scheduler
