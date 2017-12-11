
# 19385:Re-submission/duplication - New content, New metadata

*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  DatabaseLibrary
Library  XML  use_lxml=True
Library  lxml
Resource  ../Resources/Keywords.robot

*** Variables ***
${Workflowconfig}      \\\\SFA-APP1\\Sheetmusic\\Test files\\workflow.config
${SendSourceAudio}      SendSourceAudio
${ActionPrefix}         SheetMusic.
${Cleanup}              CleanUp
${CheckDuplicateEntity}  CheckDuplicateEntity
${ValidateMarc}         ValidateMarc

*** Test Cases ***

#19385:Re-submission/duplication - New content, New metadata

# Manual only - cannot edit XML files

*** Comment ***

Check submission has already gone through to completed


Turn ValidateContent instance to 0


Resubmit a file with a different pdf
     run ftp duplicate file different pdf submission for sheetmusic

Stop scheduler
    stop sheet music scheduler

Edit mdhash element in the Mets file


Turn ValidateContent instance to 1


start scheduker
    start sheet music scheduler


Check database for valid statuses
    connect
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'DuplicateEntityFound'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NewContentFound'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NonIngestableFilesRemoved'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'NewContentNewMetedata'
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'MetadataResubmissionTagAdded'

Check Marc file contains a 985 tag
    ${root} =  Parse XML  ${Xml File}
    element should exist  ${root}  xpath=.//
    XML.element should exist  ${root}  xpath=.//

Check marc file should contain a ITM datafield/tag (should contain previous submission's mdark, see example attached)
     ${root}=  Parse xml   \\\\SFA-APP1\\Sheetmusic\\MusicSales\\Working\\smd_147721\\smd_147721_Mets.xml
     ${valid}  get element text  ${root}  xpath=.//datafield[@tag='985']/subfield[@code='a']
     should be equal  '${valid}'  'NewContentNewMetadata'

Check mdRef href should contain the previous submission's mdark (see example attached)



Check passes through SI successfully
    check if exists in database  SELECT * FROM [workflow].[dbo].[WorkflowEntityActivity] WHERE Status = 'Completed'