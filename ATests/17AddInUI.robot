*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Library  string
#Library  Dialogs  type=console
Resource  ../Resources/Keywords.robot
Resource  ../Resources/DB/SQL_Server.robot

*** Variables ***
${147709mets}  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml
${Workflowconfig}      \\\\SFA-APP1\\Sheetmusic\\Test files\\workflow.config
${ActionPrefix}         SheetMusic.
${Cleanup}              CleanUp
${ValidateMarc}         ValidateMarc
#${xml}          \\\\SFA-APP1\\Sheetmusic\\Test files\\workflow.config

*** Test Cases ***
#17655:Add missing title using the UI

#*** Comment ***
Change workflowconfig ValidateMarc instance to 0
    Stop SheetMusic Scheduler
    Set Workflow.config Action ON/OFF  OFF  ${ValidateMarc}

Run FTPfile submission
    start sheetmusic scheduler
    run ftp file submission for sheetmusic

Wait for mets to appear
    sleep  7s

stop sheetmusic scheduler
    stop sheetmusic scheduler

Remove Title from 245 field - Manually edit this
    ${mets}  OperatingSystem.get file  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml
    ${tmp1}  fetch from right  ${mets}  <marc:datafield tag="245" ind1="0" ind2=" ">\n${SPACE*12}<marc:subfield code="a">
    ${tmp2}  fetch from left  ${tmp1}  </marc:subfield>\n
    ${changedmets}  replace string  ${mets}  ${tmp2}  ${EMPTY}  count=1
    OperatingSystem.create file   \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml  ${changedmets}

Start SheetMusic Scheduler
    start sheetmusic scheduler

Wait for everything to update
    sleep  7s

Check MarcValidation failures
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'ValidateMarcFailed'

Add missing title using UI
    open browser  http://192.168.245.100/BL.DLS.IngestManagement.Console/Collection/  ie
    click link   SheetMusic
    click link  ValidateMarcFailed
    click element  id=itemsummarytable_wrapper
    click link  View
    click element  id=1
    input text  modsValidatorEntry  Test123
    click element  id=modsValidatorSubmitButtonId

Wait for update
    sleep  5s

#Cannot get this to work
Check xml file contains new missing title
     ${root}=  Parse xml   \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\smd_147721\\smd_147721_Mets.xml
     ${valid}  get element text  ${root}  xpath=.//datafield[@tag='245']/subfield[@code='a']
     should be equal  '${valid}'  'Test123'

Check status update
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE '%MarcUpdatedAfterValidation'

Check Sheetmusic.updatemarcaftervalidation journal
    Check Queue Message journal Value  1  .\\private$\\SheetMusic.updatemarcaftervalidation

Change workflow.config Validatemarc instance to 1
    Set Workflow.config Action ON/OFF  ON  ${ValidateMarc}

Cleardown
    Cleardown workflow Mddb queues log files
