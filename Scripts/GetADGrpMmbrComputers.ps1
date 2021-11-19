Get-ADGroupMember -Identity 'VPN_Europe_Split_Devices' |%{get-adcomputer $_.SamAccountName | select Samaccountname } | fl > C:\temp\VPNADGrpMmbrsClients.txt
