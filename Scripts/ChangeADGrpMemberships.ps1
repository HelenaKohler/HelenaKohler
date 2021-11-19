$OldADGrp = 'HAM-GG-BSS_TS_HAMA1725_NO_BILLING'
$Userlist = Get-ADGroupMember -Identity $OldADGrp | Select -Property SamAccountname
$NewADGrp = 'HAM-GG-BSS_TS_HAMS2624_NO_BILLING'

foreach ($user in $Userlist)
{
    Add-ADGroupMember -Identity $NewADGrp -Members $user
   # Remove-ADGroupMember -Identity $OldADGrp -Members $user
}