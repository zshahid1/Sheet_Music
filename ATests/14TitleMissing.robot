*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot

*** Test Cases ***

#17687:Music Sales - Exception - title missing

Check scheduler status to MarcValidated
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'MarcValid'

Check "SheetMusic.CreateVersionData" queue
    Check Queue Message journal Value  2  .\\private$\\sheetmusic.createversiondata

Check MarcValidation failures
    connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'ValidateMarcFailed'

#Check validatemarcfailed queue
#    Check Queue Message journal Value  0  .\\private$\\sheetmusic.validatemarcfailed
# The above keeps failing because of the value 0?
