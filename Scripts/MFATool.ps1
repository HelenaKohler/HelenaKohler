# ************************************************************
# ************************************************************
# ***                                                      ***
# *** MFATool.ps1                                          ***
# ***                                                      ***
# ***                                                      ***
# ***                                                      ***
# ***                                                      ***
# *** Version: 1.1                                         ***
# *** Build  : 2019.0424.1636.0                            ***
# *** Date   : 24.04.2019                                  ***
# *** Author : Till Skidzun                                ***
# ***                                                      ***
# ***                                                      ***
# ***                                                      ***
# ***                                                      ***
# ************************************************************
# ************************************************************

# $ErrorActionPreference = "SilentlyContinue"

# ************************************************************
# *** Parameter
# ************************************************************


# ************************************************************
# *** Import Module
# ************************************************************

import-module activedirectory
Import-Module AzureAD
Import-Module MSOnline

# ************************************************************
# *** Set variables
# ************************************************************

$LogTime  = Get-Date -Format "yyyyMMdd_hhmmss"

$outputfile      = "_Logs\Added-User-"+$LogTime+".txt"
$outputfileNoMFA = "_Logs\OutputNoMFA-"+$LogTime+".txt"

# tesa M365 MFA Included
#$AzureADGroupID  = "635334cd-be06-44df-9f16-ab2fd8ad3370"

# ca-pilot
# $AzureADGroupID  = "434ddacf-5f40-4c1b-89ce-8b2da40e607f"

# $InputOUList  = "OU=DE0156,OU=Consumer,DC=Global,DC=BDFGroup,DC=net"

$InputOUList  = "OU=Consumer,DC=Global,DC=BDFGroup,DC=net",
                "OU=LaPrairie,DC=Global,DC=BDFGroup,DC=net",
                "OU=tesaSE,DC=Global,DC=BDFGroup,DC=net",
                "OU=BSS,DC=Global,DC=BDFGroup,DC=net",
                "OU=GlobalAccounting,DC=Global,DC=BDFGroup,DC=net"

$LogDatei          = "MFAStatistics-"+$LogTime+".log"
$LogDateiDetailed  = "MFAStatisticsDetailed-"+$LogTime+".log"

$UserCountTotal      = 0
$UserCountInternal   = 0
$UserCountExternal   = 0
$UserCountMale       = 0
$UserCountFemale     = 0
$UserCountTotalNoMFA = 0
$UserCountTotalMFA   = 0


# ************************************************************
# *** Login to AzureAD
# ************************************************************
Write-Host -foreground Magenta "******************************************"
Write-Host " Login with your ADM-Account to Azure AD:"
Write-Host -foreground Magenta "******************************************"
Write-Host
Connect-MsolService
Connect-AzureAD



# ************************************************************
# *** Create List
# ************************************************************

foreach($OU in $InputOUList)
{
    <#
  $UserCountTotal      = 0
  $UserCountInternal   = 0
  $UserCountExternal   = 0
  $UserCountMale       = 0
  $UserCountFemale     = 0  
  $UserCountTotalNoMFA = 0
  $UserCountTotalMFA   = 0
  #>


  # *** Collect enabled accounts of internal and external employees from AD on premises
  Write-Host " Create userlist from AD on premises:" $OU " " -NoNewline
  $UserList = Get-ADUser -Filter {(UserPrincipalName -notlike '*@Global.BDFGroup.net') -and (Enabled -eq $true) -and ((extensionAttribute14 -eq 'internalemployee') -or (extensionAttribute14 -eq 'externalemployee') -or (extensionAttribute14 -eq 'serviceaccountazure') -or (extensionAttribute14 -eq 'adminaccountazure'))} -SearchBase $OU -Properties extensionAttribute3,extensionAttribute14,gender -server HAMI0005 
  Write-Host -ForegroundColor Yellow "Done"
  #$UserCountTotal = $UserList.count

  foreach($user in $UserList)
  {
    Write-Host -ForegroundColor Magenta $user.extensionAttribute14 ' : ' $user.UserPrincipalName -NoNewline

    # *** Check MFA-Status

    $OnlineUser = Get-MSolUser -UserPrincipalName $user.UserPrincipalName -ErrorAction SilentlyContinue
    $MFAMethods = $OnlineUser.StrongAuthenticationMethods

    If($MFAMethods.count -eq 0)
    {
      Write-Host -ForegroundColor Yellow ' MFA Not configured ' -NoNewline

      Add-Content $LogDateiDetailed ($user.extensionAttribute14 + ';' + $user.extensionAttribute3 + ';' + $OnlineUser.Department + ';' + $user.SamAccountName + ';' + $OnlineUser.UserPrincipalName + ';' + $OnlineUser.DisplayName + ';NO MFA configured')
      #$UserCountTotalNoMFA = $UserCountTotalNoMFA +1
      
      <#      
      If($AzureADGroupID -in (Get-AzureADUserMembership -ObjectId $OnlineUser.ObjectId -All $true).ObjectID )
      {
        Write-Host -ForegroundColor Green ' Member of tesa  M365 MFA included'
      }
      ELSE
      {
        Write-Host -ForegroundColor Black -BackgroundColor White ' add to Group'
        Add-Content $outputfileNoMFA ($user.UserPrincipalName)
       # Add-AzureADGroupMember -ObjectId $AzureADGroupID -RefObjectId $OnlineUser.ObjectId

      }
      #>
    }
    ELSE
    {

      Foreach($MFA in $MFAMethods)
      {
        If($MFA.IsDefault -eq $true)
        {
          Add-Content $LogDateiDetailed ($User.extensionAttribute14 + ';' + $User.extensionAttribute3 + ';' + $OnlineUser.Department + ';' + $User.SamAccountName + ';' + $OnlineUser.UserPrincipalName + ';' + $OnlineUser.DisplayName + ';' + $MFA.MethodType)
          <#
          $UserCountTotalMFA = $UserCountTotalMFA +1
          if($User.gender -eq "male"){$UserCountMale = $UserCountMale +1}
          if($User.gender -eq "female"){$UserCountFemale = $UserCountFemale +1}
          if($User.extensionAttribute14 -eq "internalemployee"){$UserCountInternal = $UserCountInternal +1}
          if($User.extensionAttribute14 -eq "externalemployee"){$UserCountExternal = $UserCountExternal +1}
          #>
        }
      }

      # *** Check if already in ca-pilot
      <#
      If($AzureADGroupID -in (Get-AzureADUserMembership -ObjectId $OnlineUser.ObjectId -All $true).ObjectID )
      {
        #Write-Host -ForegroundColor Green ' Member of ca-pilot'
        Write-Host -ForegroundColor Green ' Member of tesa M365 MFA Included'
      }
      ELSE
      {
        Write-Host -ForegroundColor Black -BackgroundColor White ' add to Group'
        Add-Content $outputfile ($user.UserPrincipalName)
     #   Add-AzureADGroupMember -ObjectId $AzureADGroupID -RefObjectId $OnlineUser.ObjectId

      }
      #>
    }

  }

  <#
  Add-Content $LogDatei ("Statistics for           : " + $OU)
  Add-Content $LogDatei ("All users                : " + $UserCountTotal)
  Add-Content $LogDatei ("No MFA                   : " + $UserCountTotalNoMFA)
  Add-Content $LogDatei ("MFA configured           : " + $UserCountTotalMFA)
  Add-Content $LogDatei ("internal users configured: " + $UserCountInternal)
  Add-Content $LogDatei ("external users configured: " + $UserCountExternal)
  Add-Content $LogDatei ("male users configured    : " + $UserCountMale)
  Add-Content $LogDatei ("female users configured  : " + $UserCountFemale)

  $LogTime = Get-Date -Format "yyyyMMdd_hhmmss"
  Add-Content $LogDatei ('Ende: ' + $LogTime)
  #>
}
