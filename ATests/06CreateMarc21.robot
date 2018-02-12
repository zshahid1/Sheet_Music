*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot

*** Variables ***
${DB_USER_NAME} =  sa
${DB_USER_PASSWORD} =  Pa55word
${DB_HOST} =  192.168.245.60
${DB_PORT} =  9433
${PREVIOUS_ROW_COUNT}
${DB_NAME} =  SheetMusicDirectCatalogue
${Xml File}   //SFA-APP1/Sheetmusic/MusicSales/Working/smd_134342/smd_134342_Mets.xml

*** Test Cases ***
#17651 - PreProcessor/Loader for Music Sales


Check Marc21 xml fragment is inserted to mets file
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'MarcCreated'
    ${root}=  Parse XML  ${Xml File}
    ${test}=  Get Element Text  ${root}
    XML.Element Should Exist    ${root}  xpath=.//record

Check Queue Message Value for Create Version data
    Check Queue Message journal Value  1  .\\private$\\SheetMusic.createversiondata

LAST - Check database for failure
    Connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'PublisherPreProcessedFailed'

