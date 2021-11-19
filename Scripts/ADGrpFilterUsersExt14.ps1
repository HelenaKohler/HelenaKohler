$group = 'HAM-GG-BSS_TS_HAMS0687_BILLING'
$grpmembers = Get-ADGroupMember $group | Select samaccountname, objectclass
$san = "E:\RDS_Scripts\KohlerH\san.txt"
$mail = "E:\RDS_Scripts\KohlerH\mail.txt"
$ext14notcorrect = "E:\RDS_Scripts\KohlerH\zonk.txt"

foreach($member in $grpmembers)
{
    if ($member.objectclass -eq "user")
    {
        $memberp14 = get-aduser $member.samaccountname -Properties * | Select-Object -ExpandProperty extensionattribute14
        
        if ($memberp14 -like '*employee*')
        {

        $membermail = get-aduser $member.samaccountname -Properties * | Select-object -ExpandProperty userprincipalname
        Write-Host $member.SamAccountName -ForegroundColor Green
        Write-Host $membermail -ForegroundColor Cyan
        $member.samaccountname | out-file -filepath $san -append
        $membermail | out-file -filepath $mail -append
        }
    else
    {Write-Host -ForegroundColor Red $member.SamAccountName, $memberp14
     $member.SamAccountName, $memberp14 | out-file -filepath $ext14notcorrect -append  }
    }

    else
    {Write-Host -ForegroundColor Red $member.SamAccountName $member.objectclass}
}