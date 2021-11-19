$wvds = Get-Content C:\temp\WVDs.txt
$cred = Get-Credential

#$wvd = "WEU-BSS-PRD-191"


foreach ($wvd in $wvds) {
   Invoke-Command -ComputerName $wvd -Credential $cred -ScriptBlock {
      Set-MpPreference -EnableNetworkProtection Enabled
   }
}