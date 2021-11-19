$Attribute14 = "serviceaccountazure"
$extusers = @()
$extusers = Get-ADUser -Filter "Name -like 'EXT_Z*'" -Properties SamAccountName, UserPrincipalName, extensionAttribute14
#Write-Host $extusers
 
 foreach ($extuser in $extusers)
     { 
        
        Write-Host $extuser.SamAccountName -ForegroundColor DarkGray
        Write-Host $extuser.UserPrincipalName -ForegroundColor Gray
        Write-Host $extuser.extensionattribute14 -ForegroundColor White

        if ($extuser.UserPrincipalname -like '*Global.BDFGroup.net*')
            {
                $wrongUPN = $extuser.UserPrincipalName
                $extusersan = $extuser.SamAccountName

                #Set UPN
                $correctedupn = "$extusersan" + "@beiersdorf.com"
                Set-ADUser -Identity $extusersan -UserPrincipalName $correctedUPN 
                Write-Host $wrongUPN -ForegroundColor Red
                Write-Host $correctedupn -ForegroundColor Green                        
            }

        
        if ($extuser.extensionattribute14 -notlike '*azure*')
                {
                Write-Host $extuser.extensionAttribute14 -ForegroundColor DarkRed
                Set-ADUser -Identity $extuser.SamAccountName -replace @{"extensionAttribute14" = $Attribute14} 
                Write-Host $extuser.extensionAttribute14 -ForegroundColor DarkGreen

                }

     }