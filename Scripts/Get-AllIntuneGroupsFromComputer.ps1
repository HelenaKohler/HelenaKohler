<#
.Synopsis
    Get-AllIntuneGroupsFromComputer

.DESCRIPTION
    This script gets all the intune groups where the given Computer is in.

.NOTES
    Created:	 27.04.2022
    Version:	 1.0
    Author:      Ralf Bussenius
    
    This script is provided 'AS IS' with no warranties, confers no rights and 
    is not supported by the author.
    
    1.0 - Ralf Bussenius - 27.04.2022
        Initial Version
#>

$Script:showWindowAsync = Add-Type -MemberDefinition @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru
Function Show-Powershell()
{
$null = $showWindowAsync::ShowWindowAsync((Get-Process -Id $pid).MainWindowHandle, 10)
}
Function Hide-Powershell()
{
$null = $showWindowAsync::ShowWindowAsync((Get-Process -Id $pid).MainWindowHandle, 2)
}

Hide-Powershell

Function Get-AuthThoken(){
# Define AppId, secret, scope, tenant name and endpoint URL
$AppId = '933f0fbc-494e-4eef-affd-2b74ae72719f'
$AppSecret = 'F~2_~qGF9.DDnD-x2X3awbq_dqnd9wuJw3'
$TenantName = "bdfgrp.onmicrosoft.com"
$Scope = "https://graph.microsoft.com/.default"
$TokenURL = "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token"

# Set up the timespan for the expiration
$3600sec = New-TimeSpan -Seconds 3600
[datetime]$ExpiryDate = (Get-Date) + $3600sec

# Create the body for the appropiate token request
$Body = @{
    client_id = $AppId
    scope = $Scope
    client_secret = $AppSecret
    "grant_type" = "client_credentials"
}

# Splat the parameters for Invoke-Restmethod for cleaner code
$PostSplat = @{
    ContentType = 'application/x-www-form-urlencoded'
    Method = 'POST'
    Body = $Body
    Uri = $TokenURL
}

# Request access token for Microsft.Graph
$Request = Invoke-RestMethod @PostSplat

# Create header
$Header = @{
    Authorization = "$($Request.token_type) $($Request.access_token)"
    'ExpiresOn'=$ExpiryDate
}

# return the header to get used
$Header
}

function Get-UserInput {
    Add-Type -A System.Windows.Forms
    # error provider object
    $ep = New-Object System.Windows.Forms.ErrorProvider
    # form object
    $form1 = New-Object System.Windows.Forms.Form -P @{
        ClientSize = '320,80'
        Text = "Please input the name of a computer"
    }

    # text input 
    $txt = New-Object System.Windows.Forms.TextBox -P @{
        Name = 'txt1'
        Location = '10,10'
        Size = '290,20'
        Anchor = 'Top,Left,Right'
        MaxLength = 29
        TextAlign = 'Center'
        Font = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
    
        # subscribe KeyDown event
        add_KeyDown = {
            if ($_.KeyCode -eq "Enter"){
                $form1.Close()
            }
        }
    }   

    # add button
    $btn = New-Object System.Windows.Forms.Button -P @{
        Text = "OK"
        Location = '10,40'
        Size = '300,30'
        Anchor = 'Bottom,Left,Right'
        add_Click = {
            $form1.Close()
        }
    }
    $form1.Controls.AddRange(@($txt,$btn))
    [void]$form1.ShowDialog()
    $txt.Text
}

$AuthToken = Get-AuthThoken

<#
# Get all devices to choose from
$URI = "https://graph.microsoft.com/beta/devices?`$select=displayName"
$AllDevices = New-Object System.Collections.ArrayList
Do{
    if($authToken.ExpiresOn -lt (Get-Date).AddMinutes(2)){
        $authToken = Get-AuthThoken
    }

    $Request = $null
    $Request = Invoke-RestMethod -Uri $URI -Headers $AuthToken -Method Get

    $Null = $Request.value | foreach {$AllDevices.Add($_)}

    $Uri = $Request.'@odata.nextLink'

}while($Uri)

$DeviceName = ($AllDevices | Out-GridView -Title "Select a client" -OutputMode Single).displayName
#>

# Get Obejct ID from Device Name
#$DeviceName = "VIEMWIN10-217"
$DeviceName = Get-UserInput

$URI = "https://graph.microsoft.com/beta/devices?`$filter=(displayName eq '$($DeviceName)')"
$Request = $null
$Request = Invoke-RestMethod -Uri $URI -Headers $AuthToken -Method Get

$DeviceID = $Request.value.id

# Get all groups

$URI = "https://graph.microsoft.com/beta/devices/$DeviceID/transitiveMemberOf"
$Request = $null
$Request = Invoke-RestMethod -Uri $URI -Headers $AuthToken -Method Get

$Groups = $Request.value | select displayName, description
$Groups | Out-GridView -Title "All Groups from $($DeviceName)" -Wait