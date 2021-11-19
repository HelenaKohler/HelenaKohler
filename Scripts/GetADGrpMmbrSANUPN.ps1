Get-ADGroupMember -Identity 'HAM-GG-BSS-VPN_VPNtest_GPO _BSS HAM' |%{get-aduser $_.SamAccountName | select userPrincipalName } > C:\temp\VPNADGrpMmbrs.txt
