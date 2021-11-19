$ErrorActionPreference = 'SilentlyContinue'

Write-Host "Login to MS Online Service"
Connect-MsolService

Write-Host "Read InputFile"
$InputFile = "C:\Users\ADm1kohlerh\Desktop\KohlerH\INGEN3.txt"
$InputList = Get-Content $InputFile
$OutputFile = "C:\Temp\Output.csv"
Add-Content $OutputFile ("Samaccountname;AD-UPN;AD-Group;LicensedInAzure")


foreach ($user in $InputList)
    {
     $ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName,MemberOf   
     
     if($ADuser.MemberOf -like '*O365-License*')
        {
            $ADuserInGroup = (($ADuser.MemberOf -like '*O365-License*').split("="))[1].replace(",OU","")
           }
        else
            {
            $ADuserInGroup = "" 
            }
    
       $OnlineUsers = Get-MsolUser -UserPrincipalName $ADuser.UserPrincipalName
       $UPNInAzure = $OnlineUsers.UserPrincipalName
       
      Add-Content $OutputFile ($ADuser.SamAccountName + ";" + $ADuser.UserPrincipalName + ';' + $ADuserInGroup + ";" + $UPNInAzure) 
        }

