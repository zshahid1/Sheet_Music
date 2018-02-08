*** Settings ***
Library  Selenium2Library
Library  DatabaseLibrary


*** Variables ***

${BROWSER} =  Chrome / firefox / ie
${START_URL} =  http://192.168.245.100/BL.DLS.IngestManagement.Console/Collection/
${DATABASE}         192.168.245.60
@{DB_LOGIN}         sa  Pa55word


*** Test Cases ***
#17654 - Expose Digital Sheet Music (DSM) in the UI

View SheetMusic Content stream in list
#1
    open browser  http://192.168.245.100/BL.DLS.IngestManagement.Console/Collection/  firefox
    click link   SheetMusic
#1.1 Status page
    click link  SubmittedForIngest
#1.3 View link clicked - check if relevant files are visible
    click element  id=itemsummarytable_wrapper
    click link  View
    close browser

Workflow monitor containing SheetMusic    #Check if SheetMusic files are filtered and visible
    open browser  http://sting1.ad.bl.uk/BL.DLS.IngestManagement.Console/WorkflowMonitor/  firefox
    sleep  2s
    click element  xpath=//*[@id="SelectedStreamFilterCriteria"]/option[6]
    sleep  2s
    close browser