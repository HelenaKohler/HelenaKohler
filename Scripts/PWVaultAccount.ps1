[string]$baseUri = "https://bss-vault.global.bdfgroup.net"
[string]$PVWAAppName = "passwordvault"


function GET-CyberarkToken ([ValidateSet("CyberArk", "LDAP", "Windows", "RADIUS")] [string]$type = "Windows",$SessionVariable="PSVaultSession",[int]$connectionnumber="3") {
    $URI = "$baseURI/$PVWAAppName/api/Auth/$type/Logon"
    if ($type -eq "XY")
    {
        $boundParameters  =@{ContentType ="application/json"
                             SkipHeaderValidation= $true
                             SslProtocol = $tlsversion
                             connectionNumber = $connectionnumber}
        $body = $boundParameters | ConvertTo-Json
        $SessionToken = Invoke-RestMethod -Uri $URI -Method POST -Body $body -SessionVariable $SessionVariable -UseDefaultCredentials
    }
    else
    {
        $username = Read-Host "Please enter username for $type user"
        $securepassword = Read-Host "Please enter password for $type user" -AsSecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        $boundParameters  =@{username = $username
                            password = $password
                            connectionNumber = $connectionnumber}
        $body = $boundParameters | ConvertTo-Json
        $SessionToken = Invoke-RestMethod -Uri $URI -Method POST -Body $body -ContentType "application/json"
    }
    @{"Authorization" = "$([string]$SessionToken)"}
}
function GET-CyberarkAccountIDPassword ($CyberArk_Token = $CyberArk_Token, $AccountID = $(throw "AccountID is required!"),$reason = "PSAutomation") {
    $URI = "$baseURI/$PVWAAppName/api/Accounts/$($AccountID)/Password/Retrieve"
    $boundParameters  =@{reason = $reason}
    $body = $boundParameters | ConvertTo-Json
    (Invoke-RestMethod -Uri $URI -Method POST -ContentType "application/json" -Headers $CyberArk_Token)
}
#### REQUEST TOKEN FROM CyberArk Vault
if ($useLDAP -eq $true)
{
    #Get token to operate with Cyberark Vault (useLDAP switch, interactive for testing)
    $CyberArk_Token = GET-CyberarkToken -SessionVariable "PSAutomation" -type LDAP -connectionnumber 55                                 
}
else
{
    #Get token to operate with Cyberark Vault (uses Windows integrated Authentication)
    $CyberArk_Token = GET-CyberarkToken -SessionVariable "PSAutomation" -connectionnumber 55                                            
}



