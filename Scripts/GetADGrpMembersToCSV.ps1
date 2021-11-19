$users = Get-ADGroupMember -Identity 'BSS_TS_P_Paris_VMWorkaround_BILLING'  -recursive | Select -ExpandProperty userprincipalname # > C:\temp\GWGrps.csv

foreach ($user in $users)
    {
    Remove-ADGroupMember -Identity 'BSS_TS_P_Paris_VMWorkaround_BILLING' -Members $user
    }