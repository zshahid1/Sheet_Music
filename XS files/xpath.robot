*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary
Library  XML

*** Variables ***
${Xml File}  //SFA-APP1/Sheetmusic/MusicSales/Working/smd_147778/smd_147778_Mets.xml
${HASHVALUE}  55db5f1441acacf57a0e5705087347324b0b4f403000100921e036b36312a2ca
*** Test Cases ***


#Check version fragment is created and put in mets file
#Parse-Xml-Test
#    ${root}=  Parse XML  ${Xml File}
#    Should Be Equal  ${root.tag}  mets
#    ${test}=  Get Element Text  ${root}
#    XML.Element Should Exist ${root}  xpath=.//versioningData
#    ${Versioning}  XML.Get Element Text  ${root}   xpath= .//versioningData
#    Should Be Equal    ${Versioning}    ${HASHVALUE}
#
#
#    XML.Element Should Exist  ${root}  xpath=.//mdWrap[@OTHERMDTYPE='VERSIONINGDATA']//versioningData
#    ${Versioning}  XML.Get Element Text  ${root}    xpath=.//mdWrap[@OTHERMDTYPE='VERSIONINGDATA']//versioningData  normalize_whitespace=True
#    Log  ${Versioning}
#    Should Be Equal    '${Versioning}'   '${HASHVALUE}'
#
#This drills down to one specific parent/child where there maybe manyvalues
#    XML.Element Should Exist  ${root}  .//mets:digiprovMD[@ID = 'amd00000001-event001']//premis:eventOutcome
#    XML.Element Should Exist   ${root}   xpath=.//key
#    XML.Element Should Exist    ${root}  xpath=.//mdWrap[@OTHERMDTYPE='VERSIONINGDATA']
#    ${myKeyVal}=  ${root} .//decendants::[name:key]


#  Set text to empty
#   ${Mets}  Parse xml   \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml
#   ${SetElementText}  set element text  ${Mets}  ${EMPTY}  xpath.//mdRef[@MDTYPE='MARC']/datafield[@tag='245']/subfield
#   save xml  ${SetElementText}  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml

# Remove text from the right hand side
#    ${mets}  OperatingSystem.get file  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml
#    log  ${mets}
#    ${tmp1}  fetch from right  ${mets}  <marc:datafield tag="245" ind1="0" ind2=" ">\n
#    ${tmp2}  fetch from left  ${tmp1}  </marc:subfield>\n
#    ${changedmets}  replace string  ${mets}  "${tmp2}"  "<marc:subfield code="a">"
#    log  ${changedmets}
#    OperatingSystem.create file   \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml  ${changedmets}

#    remove string  ${147709mets}  'Nobody's Fault But Mine (arr. Gitika Partington)'  xpath=.//subfield/[@code="a"'Nobody's Fault But Mine (arr. Gitika Partington)']
#    ${workflow.config}  Parse xml   \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147709_Mets.xml
#    ${SetText}  xml.set element text  ${workflow.config}  ${EMPTY}  xpath=.//subfield/[@code="a"]
#    save xml  ${SetText}  ${workflow.config}



*** Settings ***
Library           OperatingSystem
Library           DatabaseLibrary
Library           SSHLibrary
Library           String
Resource          DCI2.html
Library           XML
Resource          cor-ftp.txt

*** Keywords ***
TurnONCleanupEJC
    ConnectToCOR-APP
    ${Workflow.config}    Parse Xml    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Scheduler\\Settings\\workflow.config
    Comment    ${getElementattribute}    Get Element Attribute    ${Workflow.config}    instances    xpath=workflow[1]/actionGroup[1]
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    1    xpath=workflow[1]/actionGroup[@name='eJournals.Common.CleanUpAfterStrategicIngest']/[@instances='0']
    save xml    ${setElementattribute}    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Scheduler\\Settings\\workflow.config
    StopEJC
    StartEJC

TurnOffCleanUpEJC
    ConnectToCOR-APP
    ${Workflow.config}    Parse Xml    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Scheduler\\Settings\\workflow.config
    Comment    ${getElementattribute}    Get Element Attribute    ${Workflow.config}    instances    xpath=workflow[1]/actionGroup[1]
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    0    xpath=workflow[1]/actionGroup[@name='eJournals.Common.CleanUpAfterStrategicIngest']/[@instances='1']
    save xml    ${setElementattribute}    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Scheduler\\Settings\\workflow.config
    StopEJC
    StartEJC

StartLicenceCheckingEJP
    ConnectToCOR-APP
    ${Workflow.config}    Parse Xml    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Purchased.Scheduler\\Settings\\workflow.config
    Comment    ${getElementattribute}    Get Element Attribute    ${Workflow.config}    instances    xpath=workflow[1]/actionGroup[1]
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    1    xpath=workflow[1]/actionGroup[@name='eJournals.Purchased.CheckLicence']/[@instances='0']
    save xml    ${setElementattribute}    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Purchased.Scheduler\\Settings\\workflow.config
    StopEJP
    StartEJP

StopLicenceCheckingEJP
    ConnectToCOR-APP
    ${Workflow.config}    Parse Xml    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Purchased.Scheduler\\Settings\\workflow.config
    Comment    ${getElementattribute}    Get Element Attribute    ${Workflow.config}    instances    xpath=workflow[1]/actionGroup[1]
    ${setElementattribute}    Set Element Attribute    ${Workflow.config}    instances    0    xpath=workflow[1]/actionGroup[@name='eJournals.Purchased.CheckLicence']/[@instances='1']
    save xml    ${setElementattribute}    \\\\192.168.246.130\\Program Files\\The British Library\\BL.DLS.eJournals.Purchased.Scheduler\\Settings\\workflow.config
    StopEJP
    StartEJP
