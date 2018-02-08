*** Settings ***
Library  Selenium2Library
Library  OperatingSystem

*** Variables ***
#${Location}     ${CURDIR}Powershell
${Dynamic}      ${CURDIR}\\IEZonesEPM2.ps1

*** Keywords ***
Set IE Security Zones all EPM (On/Off):
  [Arguments]  ${OnOff}
  [Documentation]  IE Enable Protected Mode
  ...  When using IEZonesEPM2 use either:
  ...  To set all Zones 'ON' use On as argument
  ...  To set all Zones 'OFF use Off as argument
  ${Data}  set variable if  '${OnOff}'=='Off'  3  0
  ${LogDetails}  OperatingSystem.Run  %SystemRoot%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -File "${Dynamic}" "${Data}"
  Log  ${LogDetails}
  Sleep  1

Set IE Protected Mode
    Set IE Security Zones all EPM (On/Off):  On