$clients = Get-Content "C:\Temp\VPNClients.txt"
$Grp = 'VPN_Europe_Split_Devices'

foreach ($client in $clients) {
    
    $SAN = Get-ADComputer $client | Select -Property SamAccountName
    Write-Host -ForegroundColor Cyan "SamAccountName of Computer: $SAN"

    Add-ADGroupMember -Identity $Grp -Members $SAN -Erroraction Continue -Verbose
    Write-Host -ForegroundColor DarkCyan "$SAN added to AD Group $Grp"
}