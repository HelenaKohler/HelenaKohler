### Logfile ###
$logfile = "C:\Windows\BSS_Logging\Corporate_VPNv5_install.txt"

### Set paralell DNS Request to off ###
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient" -Name DisableSmartNameResolution -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" -Name DisableParallelAandAAAA -Value 1 -Type DWord

<#
.SYNOPSIS
Write a Log file 

.DESCRIPTION
function to write text to a logfile with different log level

.PARAMETER logtext
define the logtext to be written in the log

.PARAMETER level
set the level, 
0 = Info
1 = Action
2 = Error

.NOTES
v1
#>
function Write-Log([string]$logtext, [int]$level=0)
    {
    $logdate = get-date -format "yyyy-MM-dd HH:mm:ss"
    if($level -eq 0)
        {
        $logtext = "[INFO] " + $logtext
        $text = "["+$logdate+"] - " + $logtext
        Write-Host $text
        }
    if($level -eq 1)
        {
        $logtext = "[ACTION] " + $logtext
        $text = "["+$logdate+"] - " + $logtext
        Write-Host $text -ForegroundColor Yellow
        }
    if($level -eq 2)
        {
        $logtext = "[ERROR] " + $logtext
        $text = "["+$logdate+"] - " + $logtext
        Write-Host $text -ForegroundColor Red
        }
    $text >> $logfile
    }

### Set interface metric for all interfaces containing LAN or Ethernet in the interface alias ###
$interfaces = Get-NetIPInterface
foreach ($interface in $interfaces)
    {
    if ($interface.interfacealias -like "*LAN*" -and $interface.InterfaceMetric -le 26)
        {
        Write-Log -logtext "$($interface.interfacealias) - $($interface.interfacemetric)" -level 0
        Set-NetIPInterface -InterfaceAlias $interface.interfacealias -InterfaceMetric 30
        Write-Log -logtext "Interface Metric set to 30" -level 1
        $int_log = Get-NetIPInterface -InterfaceAlias $interface.InterfaceAlias
        Write-Log -logtext "$($int_log.InterfaceAlias)" + " | " + "$($int_log.InterfaceMetric)" -level 0
        }
        elseif ($interface.InterfaceAlias -like "*Ethernet*" -and $interface.InterfaceMetric -le 26)
        {
        Write-Log -logtext "$($interface.interfacealias) - $($interface.interfacemetric)" -level 0
        Set-NetIPInterface -InterfaceAlias $interface.interfacealias -InterfaceMetric 30 -AutomaticMetric disabled
        Write-Log -logtext "Interface Metric set to 30" -level 1
        $int_log = Get-NetIPInterface -InterfaceAlias $interface.InterfaceAlias
        Write-Log -logtext "$($int_log.InterfaceAlias) - $($int_log.InterfaceMetric)" -level 0
        }          
    }

### Creation of VPN connection ###    
$EAPXML = '<EapHostConfig xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><EapMethod><Type xmlns="http://www.microsoft.com/provisioning/EapCommon">25</Type><VendorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorId><VendorType xmlns="http://www.microsoft.com/provisioning/EapCommon">0</VendorType><AuthorId xmlns="http://www.microsoft.com/provisioning/EapCommon">0</AuthorId></EapMethod><Config xmlns="http://www.microsoft.com/provisioning/EapHostConfig"><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>25</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV1"><ServerValidation><DisableUserPromptForServerValidation>false</DisableUserPromptForServerValidation><ServerNames>hams.*\.global\.bdfgroup\.net;.*\.beiersdorfgroup.com</ServerNames><TrustedRootCA>7a 75 ab 5d d8 47 be e8 3d 60 6b b3 66 a2 97 59 cc d9 bc 50 </TrustedRootCA></ServerValidation><FastReconnect>true</FastReconnect><InnerEapOptional>false</InnerEapOptional><Eap xmlns="http://www.microsoft.com/provisioning/BaseEapConnectionPropertiesV1"><Type>26</Type><EapType xmlns="http://www.microsoft.com/provisioning/MsChapV2ConnectionPropertiesV1"><UseWinLogonCredentials>true</UseWinLogonCredentials></EapType></Eap><EnableQuarantineChecks>false</EnableQuarantineChecks><RequireCryptoBinding>false</RequireCryptoBinding><PeapExtensions><PerformServerValidation xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">false</PerformServerValidation><AcceptServerName xmlns="http://www.microsoft.com/provisioning/MsPeapConnectionPropertiesV2">true</AcceptServerName></PeapExtensions></EapType></Eap></Config></EapHostConfig>'
$VPN_Name = "Corporate VPN"
$server_address = "corp-eu-vpn.beiersdorfgroup.com"
Add-VpnConnection -Name $VPN_Name -ServerAddress $server_address -TunnelType "L2tp" -EncryptionLevel "Required" -AuthenticationMethod Eap -SplitTunneling -AllUserConnection:$true -RememberCredential -EapConfigXmlStream $EAPXML -DnsSuffix "global.bdfgroup.net" -PassThru

### VPN connection routes for private networks to use vpn connection ###
Add-VpnConnectionRoute -ConnectionName $VPN_Name -DestinationPrefix "10.0.0.0/8"
Add-VpnConnectionRoute -ConnectionName $VPN_Name -DestinationPrefix "172.16.0.0/12"
Add-VpnConnectionRoute -ConnectionName $VPN_Name -DestinationPrefix "192.168.0.0/16"
Add-VpnConnectionRoute -ConnectionName $VPN_Name -DestinationPrefix "185.46.212.64/26"

### Log Output ###
$VPNConn = Get-VpnConnection -Name $VPN_Name -AllUserConnection
Write-Log -logtext $VPNConn.name -level 0

# SIG # Begin signature block
# MIITYwYJKoZIhvcNAQcCoIITVDCCE1ACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4f6dqIBQaygkXOqw+MZmXlWN
# /q6gghEvMIIH/zCCBeegAwIBAgITIAAAAVt94l62Zkl6rgABAAABWzANBgkqhkiG
# 9w0BAQsFADBnMRMwEQYKCZImiZPyLGQBGRYDbmV0MRgwFgYKCZImiZPyLGQBGRYI
# QkRGR3JvdXAxFjAUBgoJkiaJk/IsZAEZFgZHbG9iYWwxHjAcBgNVBAMTFUJlaWVy
# c2RvcmZHcm91cFN1YjJDYTAeFw0xNzAyMDExMjUxNDBaFw0yMjAyMDExMzAxNDBa
# MB8xHTAbBgNVBAMTFENvZGVTaWduaW5nIC9CU1MgSEFNMIGfMA0GCSqGSIb3DQEB
# AQUAA4GNADCBiQKBgQCfEarBaUvJWEBAzjpY4ZyQ0e7RY4NhOg8ynwPxuHCLPGOI
# PCGRx17olkK885KrwwRcL7Gd18T1rY4s+jpnrXVyw4SOFFSDejasKA/KgKJcDVKP
# CFM6V4cfCT6Dsn5Rpjvk2ppxMRm/ZT/2AIcse6wmwwnvMB2g55vDA2SAZXb40QID
# AQABo4IEbjCCBGowPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGCNxUIhf76coWRh0yF
# /Ycygtr/E4emuTyBB9D3F4zxawIBZAIBDzATBgNVHSUEDDAKBggrBgEFBQcDAzAL
# BgNVHQ8EBAMCB4AwGwYJKwYBBAGCNxUKBA4wDDAKBggrBgEFBQcDAzAdBgNVHQ4E
# FgQUh7TjjXHqAn/0H4/fdqLwUI3wBLAwHwYDVR0jBBgwFoAUd0GrVp0WocZMt92x
# KfIff9N2MGkwggGsBgNVHR8EggGjMIIBnzCCAZugggGXoIIBk4ZEaHR0cDovL3Br
# aS5nbG9iYWwuYmRmZ3JvdXAubmV0L2NlcnRkYXRhL0JlaWVyc2RvcmZHcm91cFN1
# YjJDYSgxKS5jcmyGgcFsZGFwOi8vL0NOPUJlaWVyc2RvcmZHcm91cFN1YjJDYSgx
# KSxDTj1IQU1TMTMxMSxDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMs
# Q049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1CREZHcm91cCxEQz1uZXQ/
# Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERp
# c3RyaWJ1dGlvblBvaW50hkBodHRwOi8vY2EuYmVpZXJzZG9yZi5jb20vQ2VydEVu
# cm9sbC9CZWllcnNkb3JmR3JvdXBTdWIyQ2EoMSkuY3JshkVodHRwOi8vY2EuZ2xv
# YmFsLmJkZmdyb3VwLm5ldC9DZXJ0RW5yb2xsL0JlaWVyc2RvcmZHcm91cFN1YjJD
# YSgxKS5jcmwwggG9BggrBgEFBQcBAQSCAa8wggGrMFAGCCsGAQUFBzAChkRodHRw
# Oi8vcGtpLmdsb2JhbC5iZGZncm91cC5uZXQvY2VydGRhdGEvQmVpZXJzZG9yZkdy
# b3VwU3ViMkNhKDEpLmNydDCBtQYIKwYBBQUHMAKGgahsZGFwOi8vL0NOPUJlaWVy
# c2RvcmZHcm91cFN1YjJDYSxDTj1BSUEsQ049UHVibGljJTIwS2V5JTIwU2Vydmlj
# ZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1CREZHcm91cCxEQz1u
# ZXQ/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25B
# dXRob3JpdHkwUQYIKwYBBQUHMAKGRWh0dHA6Ly9jYS5nbG9iYWwuYmRmZ3JvdXAu
# bmV0L0NlcnRFbnJvbGwvQmVpZXJzZG9yZkdyb3VwU3ViMkNhKDEpLmNydDBMBggr
# BgEFBQcwAoZAaHR0cDovL2NhLmJlaWVyc2RvcmYuY29tL0NlcnRFbnJvbGwvQmVp
# ZXJzZG9yZkdyb3VwU3ViMkNhKDEpLmNydDA6BgNVHREEMzAxoC8GCisGAQQBgjcU
# AgOgIQwfQ29kZVNpZ25pbmdAR2xvYmFsLkJERkdyb3VwLm5ldDANBgkqhkiG9w0B
# AQsFAAOCAgEAnEztzNNbf8Yb9wTXova1mCkTw54RFat5FfYnZzS1+X9GF4v8H4lO
# 4svz/i18xR9axkz4X0biY5NkEHdBj9fqRBOYf8PrBnuzvJnAQxs+FImeS7R0oeQF
# x9a3MQrJSjtzGyVS1JNQj+ZXRsDY5SW8GoRLzZFgo8ETqJ8YLEYG6ngpZS2K9jlN
# 2vKhywwWhW0i5BK1/tjnU8Lx4cpmH9MaaTOXlB7GvU0BDHPLBT2UUtMR4UcJJJPa
# 2HzaQO1sTJykSPu5XyZMay0EkynreFjNxTpLBJ2wZ9cZJArweY2cl7YISYB+IAwu
# D7UBAvkG0WhsndCK50sYDaWidvJuVw21Oa4Sz3WknbxeUyYCq5kHsjkee+a+/hRr
# nM91zHtgi9NgRmVPIMIrqCBfj7ovgUjmaSW6pGaWjZv6cl9yYjwF2Cvup73OjYl8
# QArmT37fTpJZXZuhH2UZUc4SAuTj/1BXjznZyLF/P3MyWLOQkkEj9w9C/LwgieJj
# NHoT675YmM7wDxDsOMpVJg9tqOdpmllePrQ+SBYNUQBfW16utMdFaHrIwTKvzHF7
# jHsUgsKKjlyUeqJe8zce9Or2NYT/Xz6I9kS2sNJzWnz4ifAUOqtui9TqUJDoQKIV
# FTXs0tB5Z7HaR3dnfNs9eeAYpQp+EQ88eKZH4P8ZbnXGesbqIdkMPGMwggkoMIIH
# EKADAgECAhMWAAAAD7xHaa2zUS1rAAAAAAAPMA0GCSqGSIb3DQEBCwUAMCAxHjAc
# BgNVBAMTFUJlaWVyc2RvcmZHcm91cFJvb3RDYTAeFw0yMDA3MjkwNjE3MzNaFw0y
# NjA3MjkwNjI3MzNaMGcxEzARBgoJkiaJk/IsZAEZFgNuZXQxGDAWBgoJkiaJk/Is
# ZAEZFghCREZHcm91cDEWMBQGCgmSJomT8ixkARkWBkdsb2JhbDEeMBwGA1UEAxMV
# QmVpZXJzZG9yZkdyb3VwU3ViMkNhMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAxO413M+KFbyHSkJkB9rXIUiD7yVxlKRBy6hqrVegvQjktR7iLgYPNW4t
# c2CKsPY2q4E93OZmFEr/ec+5CflN70ktuhnfuSDQafCU5h9e5cjqa89G0Rnaywoi
# wDkUZxyOYixmVHWDnY6lt/NSADrdp7laQCkFoABPXODuFNCtm4xUpFBsieNhfoAC
# 5a/UbE588BK7KPL89yvzMoW1AkX3B//BDeoJzmlL23L4evIPaWS+RTPcqInZoLHS
# r2Fhuxz3GGeLWpC7F6VFYniy1SNlAibiFGjqNwqK5LIFmIuoSow537P7QhCKpOAw
# RAxYvMDx5j6Qyq2rVMxz7R/Gs1hykTrcDNjmqTVaMvmJP1dRc7L4b77gLH9y323A
# GXTwhqwJHGWgAAUAyzWA2LqYTSa1+IRG4xFsAXMY/0a5JVYMJOicQ4M+qCsagdNL
# DD1XpR/BPhmN/o2pa8IDClBmwiUq8Dy3WY3ccFXvUYJG7CtDaZDXDqs5TrmkPJ9Y
# RyiXviIdpyY4d6YBbmpDQXg+k3tTVS+QzMtfabP3Rh/pd+5jQmNeDBQH6H9MdjRQ
# W0cUr4hNgQq8jL64G4PaE5xhGiNJpnf2cM06fcYeEGN+H9nEXPMLTMBC4/yhGtq7
# zLtcCIdpgcmJIdqENcliqEqG6nyWz2j3UWo3Td7J3JTwhxIANi0CAwEAAaOCBBIw
# ggQOMBIGCSsGAQQBgjcVAQQFAgMBAAIwIwYJKwYBBAGCNxUCBBYEFMIN3VGh+WId
# 8iJ7Mh5X4EQdNZ/eMB0GA1UdDgQWBBR3QatWnRahxky33bEp8h9/03YwaTAZBgkr
# BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUw
# AwEB/zAfBgNVHSMEGDAWgBRwogdEt2LD6bXHYcq9fh/3UqzurzCCAaAGA1UdHwSC
# AZcwggGTMIIBj6CCAYugggGHhoG+bGRhcDovLy9DTj1CZWllcnNkb3JmR3JvdXBS
# b290Q2EsQ049SEFNUzA5NDcsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZp
# Y2VzLENOPVNlcnZpY2VzLGNuPWNvbmZpZ3VyYXRpb24sZGM9YmRmZ3JvdXAsZGM9
# bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1j
# UkxEaXN0cmlidXRpb25Qb2ludIZCaHR0cDovL2NhLmdsb2JhbC5iZGZncm91cC5u
# ZXQvQ2VydEVucm9sbC9CZWllcnNkb3JmR3JvdXBSb290Q2EuY3Jshj1odHRwOi8v
# Y2EuYmVpZXJzZG9yZi5jb20vQ2VydEVucm9sbC9CZWllcnNkb3JmR3JvdXBSb290
# Q2EuY3JshkFodHRwOi8vcGtpLmdsb2JhbC5iZGZncm91cC5uZXQvY2VydGRhdGEv
# QmVpZXJzZG9yZkdyb3VwUm9vdENhLmNybDCCAbQGCCsGAQUFBwEBBIIBpjCCAaIw
# TQYIKwYBBQUHMAKGQWh0dHA6Ly9wa2kuZ2xvYmFsLmJkZmdyb3VwLm5ldC9jZXJ0
# ZGF0YS9CZWllcnNkb3JmR3JvdXBSb290Q2EuY3J0MIG1BggrBgEFBQcwAoaBqGxk
# YXA6Ly8vQ049QmVpZXJzZG9yZkdyb3VwUm9vdENhLENOPUFJQSxDTj1QdWJsaWMl
# MjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxjbj1jb25maWd1cmF0aW9uLGRj
# PWJkZmdyb3VwLGRjPW5ldD9jQUNlcnRpZmljYXRlP2Jhc2U/b2JqZWN0Q2xhc3M9
# Y2VydGlmaWNhdGlvbkF1dGhvcml0eTBOBggrBgEFBQcwAoZCaHR0cDovL2NhLmds
# b2JhbC5iZGZncm91cC5uZXQvQ2VydEVucm9sbC9CZWllcnNkb3JmR3JvdXBSb290
# Q2EuY3J0MEkGCCsGAQUFBzAChj1odHRwOi8vY2EuYmVpZXJzZG9yZi5jb20vQ2Vy
# dEVucm9sbC9CZWllcnNkb3JmR3JvdXBSb290Q2EuY3J0MA0GCSqGSIb3DQEBCwUA
# A4ICAQBYLglUB5guZBZE0hTp08aM4DPmBg3baHfs71Sbsy72AuXGQ5zhRUHNq+Q6
# 0BFS+SthAQ8ExILkInUyz9SVbWpNMJlqcRPVTzGmAvZorS6H6xO8q6++xnTXWlZ3
# /jUgNX+B04eVoFVvYKZwYEK5IQsnGH1e12PeVOA1Y5BpQEHjEcho6NNheGdJRna8
# iwD2LAkBGGwTZgyotLF9lSKO+R+xQbN+/XFN6YruDxfaOxBfesl05p/ikZBAsUcK
# Ki4QhmXHXjvkke9/YWTiTOggwgSWjaGHFyleUThSgjQ3ZWcjhD4yMTmYP7gW18p5
# CHAFGi5cb3gg5SeSkI/qgpckTXA4TxtodJGDwr/Lf2oXaKP2UYmnz9UVtHEU+Nlb
# 77sNcG/9vubxrkZ/ikHMOzrWWg+cnX2pXy7Rp90Ag9+Rsx60nCKC0xvzzLAGMUPv
# Xo/5FsI0k5ozOhyMy5CpYIUIVwSS2nN0AVY/rUTXgrVQQ+AmXDEBwx1cB0lnGPVl
# Ohi83OP3IS/SB0T7cZr6zWan0x/3fSO1UPPn2uxv1E6qZed+zT5hjhMAPZLZdTl/
# dhZZxhelfl1LOdrMKW3HjXRugf4Iwjh/AvtdUC7ApWIstgZSAi0c3SV1J0IITzHk
# QZfjMw4BhwA+jfG/+Z5gpEEPunqHHYuuuedC0AsnxKNNhfHxbTGCAZ4wggGaAgEB
# MH4wZzETMBEGCgmSJomT8ixkARkWA25ldDEYMBYGCgmSJomT8ixkARkWCEJERkdy
# b3VwMRYwFAYKCZImiZPyLGQBGRYGR2xvYmFsMR4wHAYDVQQDExVCZWllcnNkb3Jm
# R3JvdXBTdWIyQ2ECEyAAAAFbfeJetmZJeq4AAQAAAVswCQYFKw4DAhoFAKB4MBgG
# CisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcC
# AQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYE
# FEUigAq94aRGp2fBR1nIK6W9gc2BMA0GCSqGSIb3DQEBAQUABIGACKY2BjdzBuV8
# /Pyd9GZkQEBQZ/2peACsGxbt2O9STjX78rEZ68ExKSlUyng/iWvj4teS+p3q5NFX
# lYgK1Y9Er36vGsUteKKLnaOnB/jv8NOE5usrpX0MnvTnyh0jhecLinDOlUqkJfBU
# aY3cy5aQUBSf/i4VziRjHhuSdyNt/UM=
# SIG # End signature block
