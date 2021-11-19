Write-Host "Read InputFile"
$InputFile = "E:\RDS_Scripts\KohlerH\UsersToAddToADGrp.txt"
$InputList = Get-Content $InputFile
$ADGrp = "HAM-GG-BSS_TS_MADA010004_BILLING"

foreach ($user in $InputList)
  {
    $ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName
    $SAN = $ADuser.SamAccountName

        Write-Host "User $SAN added to AD-Group $ADGrp"
        Add-ADGroupMember -Identity $ADGrp -Members $ADuser -Verbose

       
  }