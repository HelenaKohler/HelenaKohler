$groups = gc "C:\Users\adm1kohlerh\Desktop\backup\_Logs\PIAADMGrps.csv"
$users = @()

foreach ($row in $groups)
    {
                $users += Get-ADGroupMember -Identity $row -Recursive | Select -ExpandProperty SamAccountName   
    }
$users | Out-File "C:\Users\adm1kohlerh\Desktop\backup\_Logs\PIAADMGrpsUsers.txt"

#$users = gc "C:\Users\adm1kohlerh\Desktop\backup\_Logs\PIAADMGrpsUsers.txt"

foreach ($user in $users)
  {
    $ADuser = Get-ADUser -Identity $user -Properties UserPrincipalName, SamAccountName

    if($ADuser.UserPrincipalname -like '*Global.BDFGroup.net*')
        { 
        $firstname = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty GivenName
        $lastname = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty Surname
        $wrongUPN = Get-ADUser -Identity $ADuser  -Properties * | Select-object -ExpandProperty UserPrincipalName
        $displayname = Get-ADUser -Identity $ADUser -Properties * | Select-Object -ExpandProperty DisplayName
        $correctUPN = $ADuser.SamAccountName + "@beiersdorf.com"
        Write-Host "$displayname" : "$correctUPN" -ForegroundColor Green
       # Set-ADUser -UserPrincipalName $correctUPN -Identity $ADuser
       # Write-Host "User added to AD-Group $O365LicenceGrp"
       # Add-ADGroupMember -Identity $O365LicenceGrp -Members $ADuser -Verbose

        }
    else 
        {
        Write-Host "$wrongUPN" -ForegroundColor Red
        }

  }