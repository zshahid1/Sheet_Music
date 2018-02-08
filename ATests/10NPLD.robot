*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Library  XML
#Resource  ../Resources/DB/SQL_Server.robot
#Resource  ../Resources/Keywords.robot

*** Variables ***
${Xml File}   //SFA-APP1/Sheetmusic/MusicSales/Working/smd_147709/smd_147709_Mets.xml

*** Test Cases ***
#Non Print Legal deposit
#Start SheetMusic Scheduler
#    start sheetmusic scheduler

#ftpSubmission
#    Run FTP file submission for SheetMusic
#    sleep  8s

Check rights fragment inserted into mets file
    ${root}=  Parse XML  ${Xml File}
    XML.Element Should Exist    ${root}  xpath=.//RightsDeclaration
    ${Valid} =  get element text  ${root}  xpath=.//RightsDeclaration  normalize_whitespace=True
    should be equal  '${Valid}'  'Copyright'
    XML.Element Should Exist    ${root}  xpath=.//mdWrap[@MDTYPE="METSRIGHTS"]

#Stop SheetMusic Scheduler
#    stop sheetmusic scheduler

# Change of Acceptance criteria
#.//mets:digiprovMD[@ID = 'amd00000001-event001']//premis:eventOutcome