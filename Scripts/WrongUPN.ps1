Write-Host "Read InputFile"
$InputFile = "E:\RDS_Scripts\KohlerH\WrongUPN-Wave4.txt"
$InputList = Get-Content $InputFile
$O365LicenceGrp = "HAM-GG-O365-License-E3-WithoutOLMailbox"

foreach ($user in $InputList)
  {
    $ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName

    if($ADuser.UserPrincipalname -like '*Global.BDFGroup.net*')
        { 
        $firstname = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty GivenName
        $lastname = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty Surname
        $wrongUPN = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty UserPrincipalName
        $displayname = Get-ADUser -Identity $ADUser -Properties * | Select-Object -ExpandProperty DisplayName
        $correctUPN = "$firstname" + "." + "$lastname" + "." + "external@beiersdorf.com"
        Write-Host "$correctUPN" -ForegroundColor Green
        Set-ADUser -UserPrincipalName $correctUPN -Identity $ADuser
        Write-Host "User added to AD-Group $O365LicenceGrp"
        Add-ADGroupMember -Identity $O365LicenceGrp -Members $ADuser -Verbose

        }
    else 
        {
        Write-Host "$wrongUPN" -ForegroundColor Red
        }

  }