*** Settings ***
Library  OperatingSystem
#Library  FakerLibrary   locale=en_GB  #seed=124 - by adding this to the script it means that it always return the same result - remove to make complete random
Library  Selenium2Library
Library  XML

*** Test Cases ***

#Remove line from xml
#    ${xml}  parse xml  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147721_Mets.xml
#    log  ${xml}
#    ${textToRemove}  get element text  ${xml}  xpath=.//datafield[@tag='245']/subfield[@code='a']
#    log  ${textToRemove}
#    set element text  ${xml}  \  xpath=.//datafield[@tag='245']/subfield[@code='a']
#    ${textToRemove}  get element text  ${xml}  xpath=.//datafield[@tag='245']/subfield[@code='a']
#    log  ${xml}
#    save xml  ${xml}  \\\\SFA-APP1\\Sheetmusic\\Test files\\smd_147721_Mets.xml
