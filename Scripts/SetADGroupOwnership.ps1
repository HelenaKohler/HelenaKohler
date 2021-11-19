$user = Get-Aduser -Identity BuckCh
$aduser = $user.DistinguishedName

Get-ADGroup | Where-Object {$_.ManagedBy -eq $aduser} | fl

$ADGroupList = Get-Content "C:\Users\adm1kohlerh\OneDrive - BDF Group\Desktop\ADGroups.txt"


$user = Get-ADUser KohlerH 

foreach ($ADGroup in $ADGroupList)
{
    Write-Host "Setting $user.samaccountname as owner for group $ADGroup. Distinguished Name: $user.DistinguishedName)"
    Set-ADGroup S-1-5-21-117609710-963894560-725345543-832684 -Replace @{managedBy=$user.DistinguishedName}
}