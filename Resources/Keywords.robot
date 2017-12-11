*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Library  OperatingSystem
Library  SSHLibrary
Library  String
Library  XML  use_lxml=True
Resource  ../Resources/Variables.robot
Resource  ../Resources/DB/SQL_Server.robot
Library  Collections

*** Keywords ***
Open Predefined APP Server Connection
    Open Connection  ${APP_SERVER_IP}
    Login  @{SERVER_LOGIN}
    Start Command  examplelibrary.py
    import library  Remote  http://${APP_SERVER_IP}:8270  WITH NAME  ${APP_SERVER_NAME}

Connect to STING
    Open Connection  ${STING_SERVER_IP}
    Login  @{STING_SERVER_LOGIN}
    Start Command  examplelibrary.py
    import library  Remote  http://${STING_SERVER_IP}:8270  WITH NAME  ${STING_SERVER_NAME}

Start STING Scheduler
    connect to sting
    STING1.file should exist  D:\\Powershell\\startStrategic.ps1
    ${Results}  STING1.Run And Return Rc And Output     powershell.exe -File "D:\\Powershell\\startStrategic.ps1"
    log  ${Results}
    close connection

Stop STING Scheduler
    connect to sting
    STING1.file should exist  D:\\Powershell\\stopStrategic.ps1
    ${Results}  STING1.Run And Return Rc And Output     powershell.exe -File "D:\\Powershell\\stopStrategic.ps1"
    log  ${Results}
    close connection

Run SheetMusicMetadataImporter
    [Arguments]  ${AppBuildNo}
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  D:\\powershell\\runmetadataimporter.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "D:\\powershell\\runmetadataimporter.ps1" "${AppBuildNo}"
    log  ${Results}
    close connection

Run FTP file submission for SheetMusic
    SSHLibrary.Open Connection    192.168.246.101
    SSHLibrary.Login    Administrator    Pa55word
    SSHLibrary.Put File  \\\\192.168.245.55\\Sheetmusic\\Test files\\valid test files\\smd_147709.zip  /D/ECO/FTPUnsecure/SheetMusic MusicSales/
#    SSHLibrary.Put File  \\\\192.168.245.55\\Sheetmusic\\Test files\\valid test files\\smd_147709.zip  /D/ECO/FTPUnsecure/SheetMusic MusicSales/
#    SSHLibrary.Put File  \\\\192.168.245.55\\Sheetmusic\\Test files\\valid test files\\smd_134342.zip  /D/ECO/FTPUnsecure/SheetMusic MusicSales/

Run FTP duplicate file different pdf submission for SheetMusic
    SSHLibrary.Open Connection    192.168.246.101
    SSHLibrary.Login    Administrator    Pa55word
    SSHLibrary.Put File  \\\\192.168.245.55\\Sheetmusic\\Test files\\Different PDF\\smd_147709.zip  /D/ECO/FTPUnsecure/SheetMusic MusicSales/

Run Jhove failure file submission
    SSHLibrary.Open Connection    192.168.246.101
    SSHLibrary.Login    Administrator    Pa55word
    SSHLibrary.Put File  \\\\192.168.245.55\\Sheetmusic\\Test files\\Jhove Failure\\smd_148049.zip  /D/ECO/FTPUnsecure/SheetMusic MusicSales/

Start SheetMusic Scheduler
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\StartSheetMusic.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Sheetmusic\\Powershell\\StartSheetMusic.ps1"
    log  ${Results}
    close connection

Stop SheetMusic Scheduler
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\StopSheetMusic.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Stopmusic\\Powershell\\StartSheetMusic.ps1"
    log  ${Results}
    close connection

Clear Log file
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Clear Log Files.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Sheetmusic\\Powershell\\Clear Log Files.ps1" "${SchedBuildNo}"
    log  ${Results}
    close connection

Cleardown Workflow database
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Cleardown Workflow Database.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Sheetmusic\\Powershell\\Cleardown Workflow Database.ps1"
    log  ${Results}
    close connection

Purge message queues
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Purge Message Queues.ps1
    ${Return}  SFA-APP1.Run And Return Rc And Output   powershell.exe -File "C:\\Sheetmusic\\Powershell\\Purge Message Queues.ps1" "${SchedBuildNo}"
    Log  ${Return}
    close connection

Check Queue Message Value
    [Arguments]  ${Value}  ${QueueName}
    Open Predefined APP Server Connection
    ${QueMsgVal}  SFA-APP1.Run And Return Rc And Output  powershell.exe -File "C:\\Sheetmusic\\Powershell\\CheckQueueMsg.ps1" "${QueueName}"
    Log  ${QueMsgVal}
    should be equal  ${QueMsgVal[1]}  ${Value}

Check Queue Message journal Value
    [Arguments]  ${Value}  ${QueueName}
    Open Predefined APP Server Connection
    ${QueMsgVal}  SFA-APP1.Run And Return Rc And Output  powershell.exe -File "C:\\Sheetmusic\\Powershell\\CheckQueueMsgJournal.ps1" "${QueueName}"
    Log  ${QueMsgVal}
    should be equal  ${QueMsgVal[1]}  ${Value}

Change workflow.config cleanup instance to 0
    ${workflow.config}  Parse xml   \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\workflow.config
    comment  ${getElementattribute}  get element attribute  ${workflow.config}  instances
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    0    xpath=workflow[1]/actionGroup[@name='SheetMusic.CleanUp']/[@instances='1']
    save xml    ${setElementattribute}    \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\workflow.config
    Log element  ${workflow.config}

Change workflow.config cleanup instance to 1
    ${workflow.config}  Parse xml   \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\workflow.config
    comment  ${getElementattribute}  get element attribute  ${workflow.config}  instances
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    1    xpath=workflow[1]/actionGroup[@name='SheetMusic.CleanUp']/[@instances='0']
    save xml    ${setElementattribute}    \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\workflow.config
    Log element  ${workflow.config}

Set Workflow.config Action ON/OFF
    [Arguments]  ${ON/OFF}  ${Action}
    ${ValueToSet}  set variable if
    ...  "${ON/OFF}"=="ON"  1  0
    Open Predefined APP Server Connection
    ${Workflow.config}    Parse Xml    ${WFConfig}
    ${getElementattribute}    xml.Get Element Attribute    ${Workflow.config}    instances    xpath=.//actionGroup[@name='${ActionPrefix}${Action}']
    Log  ${getElementattribute}
    ${setElementattribute}  Run Keyword if  "${ValueToSet}"!="${getElementattribute}"
    ...  Set Element Attribute    ${Workflow.config}    instances    ${ValueToSet}    xpath=.//actionGroup[@name='${ActionPrefix}${Action}']
    ...  ELSE  Set Variable  "${Action} already set to ${ON/OFF}"
    Run Keyword if  "${ValueToSet}"!="${getElementattribute}"
    ...  save xml    ${setElementattribute}    ${WFConfig}
    ...  ELSE  Log  ${setElementattribute}

hange workflow.config cleanup instance to 1
    ${workflow.config}  Parse xml   \\\\SFA-APP1\\Octopus\\Applications\\Testing\\BL.DLS.SheetMusic.Scheduler\\1.0.71.174\\Settings\\workflow.config
    comment  ${getElementattribute}  get element attribute  ${workflow.config}  instances
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    1    xpath=workflow[1]/actionGroup[@name='SheetMusic.CleanUp']/[@instances='0']
    save xml    ${setElementattribute}    \\\\SFA-APP1\\Octopus\\Applications\\Testing\\BL.DLS.SheetMusic.Scheduler\\1.0.71.174\\Settings\\workflow.config
    Log element  ${workflow.config}

#Library  Collections
#Library  OperatingSystem
#Library  String
SI Validation Post Request
    [Arguments]  ${metsfile}
    ${XML}  operatingsystem.get file  ${metsfile}
    Create Session    SI    http://SFA-APP1/BL.DLS.StrategicIngest.Validation.Service
#    Create Session    SI    http://STING1/BL.DLS.StrategicIngest.Validation.Service
    ${header}    Create Dictionary    'Content-Type'=multipart/form-data
    ${file}    Create Dictionary    'file'=${XML}
    ${resp}  post request  SI  /Validate/PostFile  files=${file}  headers=${header}
    ${StatusCode}  set variable  ${resp.status_code}
    should be equal  ${StatusCode}  ${200}
    ${json}  set variable  ${resp.json()}
    Log  ${json}  level=trace
    ${Outcome}  get from dictionary  ${json}  Outcome
    should not be equal  ${Outcome}  Failure

SI Validate directory of mets files
    [Arguments]  ${metsSubLocation}
    @{files}  list files in directory  ${metsSubLocation}  absolute=true
    :FOR  ${file}  in  @{files}
        \  ${ext}  split extension  ${file}
        \  ${XML}  set variable if  "${ext[1]}"=="xml"  TRUE  FALSE
        \  ${METS}  set variable if  "${file.find('mets')}"!="-1" or "${file.find('Mets')}"!="-1"  TRUE  FALSE
        \  run keyword if  "${XML}"=="TRUE" and "${mets}"=="TRUE"
        \  ...  run keyword and continue on failure  SI Validation Post Request  ${file}
        \  ...  ELSE  Log  This File is not an XML Mets file and therefore cannot be sent to the ValidationService
#*** Test Cases ***
#Run SI Validation
#    SI Validate directory of mets files  ${directoryofmets}

Remove Title from 245 field
    ${mets}  OperatingSystem.get file  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml
    ${tmp1}  fetch from right  ${mets}  <marc:datafield tag="245" ind1="0" ind2=" ">\n${SPACE*12}<marc:subfield code="a">
    ${tmp2}  fetch from left  ${tmp1}  </marc:subfield>\n
    ${changedmets}  replace string  ${mets}  ${tmp2}  ${EMPTY}  count=1
    OperatingSystem.create file   \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml  ${changedmets}

#Pass build number into variable
#${NewestBuild}  OperatingSystem.run and return rc and output  Powershell.exe -File "${ScriptRunner}" "${APP_SERVER_NAME}" "${RecentBuildforRoot}" "${AppRoot}"

Cleardown SheetMusic Database
    Connect
   ${sqlstring}  catenate  DELETE FROM [SheetMusicDirectCatalogue].[dbo].[CatalogueRecord];
    ...  DELETE FROM [SheetMusicDirectCatalogue].[dbo].[Log];
    ...  DELETE FROM [SheetMusicDirectCatalogue].[dbo].[SyncDetails];
    execute sql string  ${sqlstring}

Cleardown workflow Mddb queues log files
    Open Predefined APP Server Connection
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Purge Message Queues.ps1
    ${Return}  SFA-APP1.Run And Return Rc And Output   powershell.exe -File "C:\\Sheetmusic\\Powershell\\Purge Message Queues.ps1" "${SchedBuildNo}"
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Cleardown Workflow Database.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Sheetmusic\\Powershell\\Cleardown Workflow Database.ps1"
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Clear Log Files.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Sheetmusic\\Powershell\\Clear Log Files.ps1" "${SchedBuildNo}"
    SFA-APP1.file should exist  C:\\Sheetmusic\\Powershell\\Cleardown Mddb Database.ps1
    ${Results}  SFA-APP1.Run And Return Rc And Output     powershell.exe -File "C:\\Sheetmusic\\Powershell\\Cleardown Mddb Database.ps1" "${SchedBuildNo}"
    Log  ${Return}
    close connection