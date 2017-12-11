*** Settings ***
Library  SSHLibrary
Library  OperatingSystem
Library  XML
Resource  ../Resources/Keywords.robot
#Resource  ../Resources/DB/SQL_Server.robot

*** Variables ***
${Xml File}  //SFA-APP1/Sheetmusic/MusicSales/Working/smd_147709/smd_147709_Mets.xml
${HashValue}  bfb73ad56187b2e2106ec71ae888aa993b5df6eed6f1f7dc8f71a61fea3ccb5d

*** Test Cases ***

#19011:Re-submission/duplication - Amend versioning to also create mdHash

Check versioning data mdHash
    ${root} =  Parse XML  ${Xml File}
    element should exist  ${root}  xpath=.//mdhash
    XML.element should exist  ${root}  xpath=.//mdhash
    should be equal  '${hashvalue}'  'bfb73ad56187b2e2106ec71ae888aa993b5df6eed6f1f7dc8f71a61fea3ccb5d'

Start STING
   start sting scheduler