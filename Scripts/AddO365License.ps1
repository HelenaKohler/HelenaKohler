Write-Host "Read InputFile"
$InputFile = "E:\RDS_Scripts\KohlerH\AddO365License.txt"
$InputList = Get-Content $InputFile
$O365LicenceGrp = "HAM-GG-O365-License-E3-WithoutOLMailbox"

foreach ($user in $InputList)
  {
    $ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName
    $SAN = $ADuser.SamAccountName

        Write-Host "User $SAN added to AD-Group $O365LicenceGrp"
        Add-ADGroupMember -Identity $O365LicenceGrp -Members $ADuser -Verbose

       
  }