Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Import-Module -Name Az

Import-Module -Name Az.ResourceGraph

Connect-AzAccount

Write-Output "Getting existing names for naming schema $NamingSchema"
$exitingNames=(Search-AzGraph -Query "Resources | where type == 'microsoft.compute/virtualmachines' and name startswith('$($NamingSchema.replace('#',''))') | project name | order by name asc" -First 1000).data
$countChars=($NamingSchema.ToCharArray() | Where-Object {$_ -eq '#'}).Count

Write-Output "Getting new names for the session hosts"
$hostNames=[System.Collections.ArrayList]::new()
$_newHosts=$CountOfHosts
$_counterHost=1
do {
    $_newName=$($NamingSchema.replace('#',''))+("{0:d$countChars}" -f [int]$_counterHost)
    if (($exitingNames| where {$_.Name -eq $_newName}) -eq $null) {
        $hostNames.Add($_newName) | Out-Null
        $_newHosts--
    }
    $_counterHost++
} until ($_newHosts -eq 0 -or $_counterHost -eq [Math]::Pow(10,$countChars))
