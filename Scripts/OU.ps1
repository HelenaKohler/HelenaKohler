$grpmembers = Get-ADGroupMember -Identity HAM-GG-BSS_TS_HAMS0687_NO_BILLING | Get-ADObject -Properties samaccountname,extensionAttribute3 | select samaccountname,extensionattribute3
$DURmembers = $grpmembers | Where-Object {$_.extensionattribute3 -eq "ZA0147"} | select samaccountname #| Out-File E:\RDS_Scripts\KohlerH\filename.txt 
foreach ($DURmember in $DURmembers)
{Write-Host "OR Username LIKE '%"$DURmember.samaccountname"%' "
}