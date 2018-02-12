*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Library  XML
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot

*** Variables ***
${147709}  \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\smd_134342\\smd_134342_Mets.xml
${Jhove Fail}   //SFA-APP1/Sheetmusic/MusicSales/Working/smd_148049/smd_148049_Mets.xml
String  ${ValidationTrueFalse} =  "Not Well-Formed"

*** Test Cases ***

ftp Submission jhove fail
    start sheetmusic scheduler
    Run Jhove failure file submission

Check Message queue for SheetMusic Validate content
    sleep  19s
    Check Queue Message journal Value  2  .\\private$\\SheetMusic.Validatecontent

Jhove scenarios
    ${root}=  Parse XML  ${Jhove Fail}
    XML.Element Should Exist    ${root}  xpath=.//digiprovMD[@ID='amd00000001-event001']//eventOutcome
#    should be equal  ${test}  'Not Well-Formed' normalize_whitespace=True
    ${ValidationMsg}  get element text  ${root}  xpath=.//digiprovMD[@ID='amd00000001-event001']//eventOutcome
    ${ValidationTrueFalse}  Set Variable If
    ...  "${ValidationMsg}"=="Well-Formed, but not valid"   TRUE
    ...  "${ValidationMsg}"=="Well-Formed and valid"   TRUE
    ...  "${ValidationMsg}"=="Not Well-Formed"   TRUE
    Should be equal  ${ValidationTrueFalse}  TRUE

Jhove version check
    sleep  3s
    ${root}=  PARSE XML  ${147709}
    ${Valid}  get element text  ${root}  xpath=.//agentName  normalize_whitespace=True
    should be equal   '${Valid}'  'JHove;1.16.7'

Wait till update
    sleep  3s

Workflow entity displays Validated
    Connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'ValidatedContent'

Check message queue for create aleph behaviour
    Check Queue Message journal Value  2  .\\private$\\sheetmusic.createalephbehaviour

Check if any errors are found
    connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntity] WHERE Status LIKE 'ValidationFailed'
    stop sheetmusic scheduler

#Clear down.
#    cleardown workflow queues and log files

#Seperate Jhove tests
#Jhove validation passes
#    sleep  3s
#    ${root}=  Parse XML  ${Xml File}
#    XML.Element Should Exist    ${root}  xpath=.//eventOutcome
#    ${Valid} =  get element text  ${root}  xpath=.//eventOutcome  normalize_whitespace=True
#    should be equal  '${Valid}'  'Well-Formed and valid'

#Jhove validation fails
#    ${root}=  Parse XML  ${Jhove Fail}
#    ${test}=  Get Element Text  ${root}
#    XML.Element Should Exist    ${root}  xpath=.//eventOutcome
#    ${Valid} =  get element text  ${root}  xpath=.//eventOutcome  normalize_whitespace=True
#    should be equal  '${Valid}'  'Not Well-Formed'