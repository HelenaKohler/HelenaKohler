import-module activedirectory
Import-Module AzureAD
Import-Module MSOnline

Write-Host -foreground Magenta "******************************************"
Write-Host " Login with your ADM-Account to Azure AD:"
Write-Host -foreground Magenta "******************************************"
Write-Host
Connect-MsolService
Connect-AzureAD

<#

Function Check-AzureUser()
{
  param(
    [Parameter(Mandatory=$true)][string]$UserPrincipalName
 )
                      ## check if user exists in azure ad 
                    #check if upn is not empty    
                    if($UserPrincipalName){
                    $UserPrincipalName = $UserPrincipalName.ToString()
                    $azureaduser = Get-AzureADUser -All $true | Where-Object {$_.Userprincipalname -eq "$UserPrincipalName"}
                       #check if something found    
                       if($azureaduser){
                             Write-Host "User: $UserPrincipalName was found in $displayname AzureAD." -ForegroundColor Green >> C:\Users\adm1kohlerh\Desktop\KohlerH\GWUsersYesAzure.txt
                                                          return $true
                             }
                             else{
                             Write-Host "User $UserPrincipalName was not found in $displayname Azure AD " -ForegroundColor Red >> C:\Users\adm1kohlerh\Desktop\KohlerH\GWUsersNoAzure.txt
                             return $false
                             }
                    }
}


#>

$ADgrp = "BSS_TS_ExternalPublished_UsergroupsForSessionhosts"
$GWuserGrps = Get-ADGroupMember -Identity $ADgrp | Select -ExpandProperty SamAccountName


foreach ($GWUserGrp in $GWuserGrps)

    { 
       $GWusers = Get-ADGroupMember -Identity $GWUserGrp -Recursive | %{get-aduser $_.SamAccountName | select userPrincipalName } >> C:\Users\adm1kohlerh\Desktop\KohlerH\GWUsersCheckAzure.txt
    }


Write-Host "Read InputFile"
$InputFile = "C:\Users\adm1kohlerh\Desktop\KohlerH\GWUsersCheckAzure1.txt"
$InputList = Get-Content $InputFile

foreach ($UserPrincipalName in $InputList)

    {

        if($UserPrincipalName){
                    $UserPrincipalName = $UserPrincipalName.ToString()
                    $azureaduser = Get-AzureADUser -All $true | Where-Object {$_.Userprincipalname -eq "$UserPrincipalName"}

                    if($azureaduser){
                             Write-Host "User: $UserPrincipalName was found in $displayname AzureAD." -ForegroundColor Green >> C:\Users\adm1kohlerh\Desktop\KohlerH\GWUsersYesAzure.txt
                             return $true
                             }
                             else{
                             Write-Host "User $UserPrincipalName was not found in $displayname Azure AD " -ForegroundColor Red >> C:\Users\adm1kohlerh\Desktop\KohlerH\GWUsersNoAzure.txt
                             return $false
                             }
                    }
    }

    