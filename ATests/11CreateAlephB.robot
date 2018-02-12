*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Library  XML
Resource  ../Resources/DB/SQL_Server.robot
Resource  ../Resources/Keywords.robot

*** Variables ***
${Xml File}  //SFA-APP1/Sheetmusic/MusicSales/Working/smd_134342/smd_134342_Mets.xml

*** Test Cases ***

#Start SheetMusic Scheduler
#    start sheetmusic scheduler

#ftpSubmission
#    Run FTP file submission for SheetMusic
#    sleep  8s

Check aleph behaviour fragment
    ${root}=  Parse XML  ${Xml File}
    element should exist  ${root}  xpath=.//behavior[@ID='beh01']
    XML.element should exist  ${root}  xpath=.//mechanism
#    ${Pos}  XML.get element text  ${root}  xpath=.//mechanism  normalize_whitespace=True
#    element should exist  xpath=.//mets:mechanism[@xlink:href='BL.DLS.StrategicIngest.Actions.Custom.UpdateAlephAction, BL.DLS.StrategicIngest']//mets:behaviorSec

#  <mets:behaviorSec>
#   <mets:behavior ID="beh01" LABEL="UpdateMasterCatalogue">
#    <mets:mechanism xlink:href="BL.DLS.StrategicIngest.Actions.Custom.UpdateAlephAction, BL.DLS.StrategicIngest" LOCTYPE="OTHER" />
#   </mets:behavior>
#  </mets:behaviorSec>

Check Aleph Behavior has been Added
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status LIKE 'AlephBehaviorAdded'

Check Queue Message Value for Submit to SI
    Check Queue Message journal Value  2  .\\private$\\SheetMusic.SubmitToSI

Check if any errors
    connect
    check if not exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntity] WHERE Status LIKE 'CreateAlephBehaviourFailed'

#Stop sheet msic scheduler
#    stop sheetmusic scheduler

#Cleardown database
#    cleardown workflow queues and log files