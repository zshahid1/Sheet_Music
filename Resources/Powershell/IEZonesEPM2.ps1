param (

    [parameter(Mandatory=$True)]

    [INT32]$OnOrOFF

)



#IEZonesEPM - Internet Explorer Zones Enabled Protection Mode

#Checks Registry for Internet Explorer Security Zones 'Enabled Protection Mode' are set, if not then it sets them.

#Zone Data can be set to:

$On= 0

$Off= 3

#VARIABLE TO SET ALL ZONES ON OR OFF

$Data=$OnOrOFF



#Zone Path and Name

$Name= 2500

$LocalIntranetZonePath= "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1"

$TrustedSitesZonePath= "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2"

$InternetZonePath= "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"

$RestrictedSitesZonePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4"



#List Current Zone Settings

Write-Host "***Current Zone Settings***`n"



#Local Intranet Zone

$Val1= ((Get-itemproperty -Path $LocalIntranetZonePath -Name $Name).$Name)

If($Val1 -eq $On)

    {Write-Host "Local Intranet Zone EPM: On"}

else

    {Write-Host "Local Intranet Zone EPM: Off"}



#Trusted Sites Zone

$Val2= ((Get-itemproperty -Path $TrustedSitesZonePath -Name $Name).$Name)

If($Val2 -eq $On)

    {Write-Host "Trusted Sites Zone EPM: On"}

else

    {Write-Host "Trusted Sites Zone EPM: Off"}



#Internet Zone

$Val3= ((Get-itemproperty -Path $InternetZonePath -Name $Name).$Name)

If($Val3 -eq $On)

    {Write-Host "Internet Zone EPM: On"}

else

    {Write-Host "Internet Zone EPM: Off"}



#Restricted Sites Zone

$Val4= ((Get-itemproperty -Path $RestrictedSitesZonePath -Name $Name).$Name)

If($Val4 -eq $On)

    {Write-Host "Restricted Sites Zone EPM: On"}

else

    {Write-Host "Restricted Sites Zone EPM: Off"}





#Review if Updates are required

Write-Host "`n***Zone Updates***`n"



If(($Val1 -ne $Data) -or ($Val2 -ne $Data) -or ($Val3 -ne $Data) -or ($Val4 -ne $Data))

{

    #Local Intranet Zone Update

    If($Val1 -ne $Data)

    {

    Set-itemproperty -Path $LocalIntranetZonePath -Name $Name -Value $Data

    $Val1a= ((Get-itemproperty -Path $LocalIntranetZonePath -Name $Name).$Name)

    If($Val1a -eq $On)

        {Write-Host "Updated Local Intranet EnableProtectedMode now: On"}

    Else

        {Write-Host "Updated Local Intranet EnableProtectedMode now: Off"}

    }



    #Trusted Sites Zone Update

    If($Val2 -ne $Data)

    {

    Set-itemproperty -Path $TrustedSitesZonePath -Name $Name -Value $Data

    $Val2a= ((Get-itemproperty -Path $TrustedSitesZonePath -Name $Name).$Name)

    If($Val2a -eq $On)

        {Write-Host "Updated Trusted sites EnableProtectedMode now: On"}

    Else

        {Write-Host "Updated Trusted sites EnableProtectedMode now: Off"}

    }



    #Internet Zone Update

    If($Val3 -ne $Data)

    {

    Set-itemproperty -Path $InternetZonePath -Name $Name -Value $Data

    $Val3a= ((Get-itemproperty -Path $InternetZonePath -Name $Name).$Name)

    If($Val3a -eq $On)

        {Write-Host "Updated Internet EnableProtectedMode now: On"}

    Else

        {Write-Host "Updated Internet EnableProtectedMode now: Off"}

    }



    #Restricted Sites Zone Update

    If($Val4 -ne $Data)

    {

    Set-itemproperty -Path $RestrictedSitesZonePath -Name $Name -Value $Data

    $Val4a= ((Get-itemproperty -Path $RestrictedSitesZonePath -Name $Name).$Name)

    If($Val4a -eq $On)

        {Write-Host "Updated Restricted sites EnableProtectedMode now: On"}

    Else

        {Write-Host "Updated Restricted sites EnableProtectedMode now: Off"}

    }

}

Else

{Write-Host "No Updates Required"}





#List Zone Settings after update

Write-Host "`n***Zone Status set for TEST***`n"



#Local Intranet Zone

$Val5= ((Get-itemproperty -Path $LocalIntranetZonePath -Name $Name).$Name)

If($Val5 -eq $On)

    {Write-Host "Local Intranet Zone EPM: On"}

else

    {Write-Host "Local Intranet Zone EPM: Off"}



#Trusted Sites Zone

$Val6= ((Get-itemproperty -Path $TrustedSitesZonePath -Name $Name).$Name)

If($Val6 -eq $On)

    {Write-Host "Trusted Sites Zone EPM: On"}

else

    {Write-Host "Trusted Sites Zone EPM: Off"}



#Internet Zone

$Val7= ((Get-itemproperty -Path $InternetZonePath -Name $Name).$Name)

If($Val7 -eq $On)

    {Write-Host "Internet Zone EPM: On"}

else

    {Write-Host "Internet Zone EPM: Off"}



#Resricted Sites Zone

$Val8= ((Get-itemproperty -Path $RestrictedSitesZonePath -Name $Name).$Name)

If($Val8 -eq $On)

    {Write-Host "Restricted Sites Zone EPM: On"}

else

    {Write-Host "Restricted Sites Zone EPM: Off"}



#Process finished PopUp Window

If(($Val5 -eq $Off)-and($Val6 -eq $Off)-and($Val7 -eq $Off)-and($Val8 -eq $Off)){

(new-object -ComObject wscript.shell).Popup("Warning! Enabled Protected Mode OFF",3,"Internet Explorer Enabled Protected Mode",48)

}

ElseIf(($Val5 -eq $On)-and($Val6 -eq $On)-and($Val7 -eq $On)-and($Val8 -eq $On)){

(new-object -ComObject wscript.shell).Popup("All Zones Enabled Protected Mode Set to ON!",3,"Internet Explorer Enabled Protected Mode",64)

}

ElseIf(($Val5 -eq $Val1)-and($Val6 -eq $Val2)-and($Val7 -eq $Val3)-and($Val8 -eq $Val4)){

(new-object -ComObject wscript.shell).Popup("An Error Occurred and no changes could be made!",0,"Internet Explorer Enabled Protected Mode",16)

}

