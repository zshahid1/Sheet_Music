*** Variables ***
#Access and Credentials Variables
${APP_SERVER_IP}     192.168.245.55
${APP_SERVER_NAME}   SFA-APP1
@{SERVER_LOGIN}      Administrator  Pa55word

${STING_SERVER_IP}     192.168.245.100
${STING_SERVER_NAME}   STING1
@{STING_SERVER_LOGIN}  Administrator  Pa55word


${AppBuildNo}  1.0.21.16
${SchedBuildNo}   1.0.104.248
${147721}               ////Sheetmusic//MusicSales//Working//smd_147721
${134342}               ////Sheetmusic//MusicSales//Working//smd_134342
${147721}               //SFA-APP1/Sheetmusic/MusicSales/Working/smd_147721/smd_147721_Mets.xml
${147709}               //SFA-APP1/Sheetmusic/MusicSales/Working/smd_147709/smd_147709_Mets.xml
${ValidateMarc}         ValidateMarc
${WFConfig}             \\\\SFA-APP1\\Octopus\\Applications\\Testing\\BL.DLS.SheetMusic.Scheduler\\1.0.104.248\\Settings\\workflow.config
${ActionPrefix}         SheetMusic.
${ValidateSubmission}   ValidateSubmission
${ProcessSubmission}    ProcessSubmission
${CreateMets}           CreateMets
${TransformMetadata}    TransformMetadata
${CreateVersionData}    CreateVersionData
${CleanUp}              CleanUp
${UpdateContentFile}    UpdateContentFile
${CreateTechMd}         CreateTechMd
${ValidateContent}      ValidateContent
${CreateVersionData}    CreateVersionData

#${PSLocation}           ${CURDIR}/Powershell/
#${ScriptRunner}         ${PSLocation}RemoteScriptRunner.ps1
#${RecentBuildforRoot}   ${PSLocation}RecentBuildforRoot.ps1
