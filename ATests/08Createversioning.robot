*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Library  XML
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot

*** Variables ***
${Xml File}   //SFA-APP1/Sheetmusic/MusicSales/Working/smd_134342/smd_134342_Mets.xml
${Xml File2}  //SFA-APP1/Sheetmusic/MusicSales/Working/smd_134342/smd_134342_Mets.xml
#${HASHVALUE}  55db5f1441acacf57a0e5705087347324b0b4f403000100921e036b36312a2ca
*** Test Cases ***

# 18063 - Create Versioning info for musicSales from Marc output record

#Run ftpSubmission
#    start sheetmusic scheduler
#    Run FTP file submission for SheetMusic

Check version fragment is created and put in mets file
    sleep  10s
    ${root}=  Parse XML  ${Xml File}
    ${test}=  Get Element Text  ${root}
    XML.Element Should Exist    ${root}  xpath=.//mdWrap[@OTHERMDTYPE='VERSIONINGDATA']

Workflow entity displays VersionDataCreated
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'VersionDataCreated'

Check queue for SheetMusic Validatecontent
    Check Queue Message journal Value  1  .\\private$\\SheetMusic.validatecontent

Check errors for Version data creation failed
    connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'VersionDataCreationFailed'

Stop sheet msic scheduler
    stop sheetmusic scheduler

#Cleardown
#    Cleardown workflow Mddb queues log files
# Notes:
#    XML.Element Should Exist  ${root}  xpath=.//mdWrap[@OTHERMDTYPE='VERSIONINGDATA']//versioningData
#    ${Versioning}  XML.Get Element Text  ${root}    xpath=.//mdWrap[@OTHERMDTYPE='VERSIONINGDATA']//versioningData  normalize_whitespace=True
#    Log  ${Versioning}
#    Should Be Equal    '${Versioning}'   '${HASHVALUE}'
