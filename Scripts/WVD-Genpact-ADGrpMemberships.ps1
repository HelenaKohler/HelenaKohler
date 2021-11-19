#(Get-ADUser -Filter * -SearchBase “OU=Users,OU=INGEN3,OU=GlobalAccounting,DC=Global,DC=BDFGroup,DC=net”) | Select Samaccountname > C:\Users\adm1kohlerh\Desktop\KohlerH\INGEN3.txt

Write-Host "Read InputFile"
$InputFile = "C:\Users\adm1kohlerh\Desktop\KohlerH\CNGEN5.txt"
$InputList = Get-Content $InputFile
$ADGrp1 = "HAM-GG-WEU_GenPact_PRD_1"
$ADGrp2 = "HAM-GG-WVD_Mig_GP_NO_BILLING"
$ADGrp3 = "HAM-GG-BSS_TS_Bexact_users"


foreach ($user in $InputList)
  {
    $ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName
    $SAN = $ADuser.SamAccountName

    
        Write-Host "User $SAN added to AD-Group $ADGrp1" -ForegroundColor Green
        Add-ADGroupMember -Identity $ADGrp1 -Members $ADuser -Verbose

       Write-Host "User $SAN added to AD-Group $ADGrp2" -ForegroundColor DarkGreen
        Add-ADGroupMember -Identity $ADGrp2 -Members $ADuser -Verbose
       
       Write-Host "User $SAN removed from AD-Group $ADGrp3" -ForegroundColor DarkMagenta
        Remove-ADGroupMember -Identity $ADGrp3 -Members $ADuser -Verbose -Confirm:$False

        

       #Write-Host "User $SAN removed from AD-Group $ADGrp2" -ForegroundColor Cyan
        #Remove-ADGroupMember -Identity $ADGrp2 -Members $ADUser -Verbose -Confirm:$False
  }