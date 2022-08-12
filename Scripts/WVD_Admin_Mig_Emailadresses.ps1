$OutputFile = "C:\temp\Emailaddresses.csv"

$member = Get-ADGroupMember -Identity HAM-GG-BSS_TS_HAMS0570_NO_BILLING -Recursive


foreach($admuser in $member)

{ 
    $p = ""
    $p14 = ""
    $p9 = ""
    $admupn = ""
    $mailuser = ""

    $p = get-aduser $admuser -Properties extensionAttribute14, UserPrincipalName, extensionattribute9 
    $p14 = $p.extensionattribute14
    $p9 = $p.extensionattribute9
    $admUPN = $p.UserPrincipalName
    Write-Host $admupn -ForegroundColor Green
    Write-Host $p14 -ForegroundColor Blue
    Write-Host $p9 -ForegroundColor Red
    $mailuser = Get-ADuser -Filter {extensionattribute1 -eq $p9} | Select-Object -ExpandProperty userprincipalname
    Write-Host $mailuser -ForegroundColor Cyan 


    Add-Content $OutputFile ($p.SamAccountName + ";" + $admupn + ";" + $p14 + ";" + $p9 + ";" + $mailuser)

}