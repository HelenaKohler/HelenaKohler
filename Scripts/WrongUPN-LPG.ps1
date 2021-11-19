$user = "DelaureS"
$O365LicenceGrp = "HAM-GG-O365-License-E3-WithoutOLMailbox"

$ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName
        
        $firstname = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty GivenName
        $lastname = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty Surname
        $wrongUPN = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty UserPrincipalName
        $displayname = Get-ADUser -Identity $ADUser -Properties * | Select-Object -ExpandProperty DisplayName
        $correctUPN = "$firstname" + "." + "$lastname" + "." + "external@laprairiegroup.ch"
        Write-Host "$wrongUPN; CorrectUPN: $correctUPN" -ForegroundColor Green
        Set-ADUser -UserPrincipalName $correctUPN -Identity $ADuser
        Write-Host "User added to AD-Group $O365LicenceGrp"
        Add-ADGroupMember -Identity $O365LicenceGrp -Members $ADuser -Verbose