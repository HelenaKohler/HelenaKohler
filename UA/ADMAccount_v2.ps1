#
# Author: San Steven Johannsen
#
# Funktion: Zum Erstellen von ADM-Accounts
#
# v2 edit 2021-01-21 Helena Kohler: Dial-in access permission cleared
#

Try {
#region ADMCreateProgressBar

$ADMCreateProgressBarForm = New-Object System.Windows.Forms.Form 
$ADMCreateProgressBarForm.Size = New-Object System.Drawing.Size(400,300)
$ADMCreateProgressBarForm.Text = "ADM-Account erstellen..."
$ADMCreateProgressBarForm.ControlBox = $false
$ADMCreateProgressBarForm.FormBorderStyle = "FixedSingle"
$ADMCreateProgressBarForm.StartPosition = "CenterScreen"
$ADMCreateProgressBarForm.ShowInTaskbar = $false

$ADMCreateProgressBarLabel = New-Object System.Windows.Forms.Label
$ADMCreateProgressBarLabel.Location = New-Object System.Drawing.Size(5,10)
$ADMCreateProgressBarLabel.Size = New-Object System.Drawing.Size(375,20)
$ADMCreateProgressBarForm.Controls.Add($ADMCreateProgressBarLabel)

$ADMCreateProgressBar = New-Object System.Windows.Forms.ProgressBar
$ADMCreateProgressBar.Location = New-Object System.Drawing.Size(5,35)
$ADMCreateProgressBar.Size = New-Object System.Drawing.Size(375,20)
$ADMCreateProgressBar.Style = "Continuous"
$ADMCreateProgressBar.Value = 0
$ADMCreateProgressBar.Step = 33
$ADMCreateProgressBarForm.Controls.Add($ADMCreateProgressBar)

$ADMCreateProgressBarTextBox = New-Object System.Windows.Forms.RichTextBox
$ADMCreateProgressBarTextBox.Location = New-Object System.Drawing.Size(5,70) 
$ADMCreateProgressBarTextBox.Size = New-Object System.Drawing.Size(375,140)
$ADMCreateProgressBarTextBox.ReadOnly = $true
$ADMCreateProgressBarForm.Controls.Add($ADMCreateProgressBarTextBox)

$ADMCreateProgressBarButtonOk = New-Object System.Windows.Forms.Button
$ADMCreateProgressBarButtonOk.Location = New-Object System.Drawing.Size(150,215)
$ADMCreateProgressBarButtonOk.Size = New-Object System.Drawing.Size(120,40)
$ADMCreateProgressBarButtonOk.Text = "Ok"
$ADMCreateProgressBarButtonOk.Enabled =$false
$ADMCreateProgressBarButtonOk.Add_Click({$ADMCreateProgressBarForm.Close()})
$ADMCreateProgressBarForm.Controls.Add($ADMCreateProgressBarButtonOk)

[void]$ADMCreateProgressBarForm.Show()
[void]$ADMCreateProgressBarForm.Focus()
[void]$ADMCreateProgressBarForm.Refresh()

#endregion ADMCreateProgressBar

[string]$SamAccountName = $UA_ToolTab1_1TextBoxUserID.Text
$AccountType = If ($UA_ToolTab1_1RadioButton1.Checked -eq $true) {"ADM1"} ElseIf ($UA_ToolTab1_1RadioButton2.Checked -eq $true) {"ADM2"}

$DomainCotroller = Get-ADDomainController
$DomainCotroller = $DomainCotroller.HostName

$SamAccountName = $SamAccountName.Trim()
$User = Get-ADUser -Identity $SamAccountName -Properties *
$AddUserNameAttr9 = [string]$User.extensionattribute1
$UserDisplay = $User.DisplayName
$Attribute3 = $User.extensionattribute3
$Attribute14 = "adminaccount"
$DisplayName = If ($AccountType -eq "ADM1") {"ADM 1 " + $User.DisplayName} Else {"ADM 2 " + $User.DisplayName}
$Kststelle = $User.Department
$Surname = $User.Surname
$GivenName = $User.GivenName
$Company = $User.Company
$Description = $User.Description
$UserID = $User.samAccountName
$UserID = If ($AccountType -eq "ADM1") {"ADM1" + $UserID} Else {"ADM2" + $UserID}
$Ablauf = $User.AccountExpirationDate

$ADMCreateProgressBar.Value = 30
$ADMCreateProgressBarLabel.Text = "Der ADM-Account wird erstellt..."
$ADMCreateProgressBarTextBox.Text += "Der ADM-Account wird erstellt.........."
[void]$ADMCreateProgressBarForm.Refresh()

##########################################################
##########################################################

function Create-Password
{
    param ([int]$length, [string]$pattern)
    $pattern_class = @("L", "U", "N", "S")
    $charpool = @{ 
        "L" = "abcdefghijkmnopqrstuvwxyz";
        "U" = "ABCDEFGHJKLMNPQRSTUVWXYZ";
        "N" = "1234567890";
        "S" = "!#%&$+-?;:"
    }
    $rnd = New-Object System.Random
    Start-Sleep -milliseconds $rnd.Next(500) 
    if (!$pattern -or $pattern.length -lt $length) {
        if (!$pattern)
        {
            $pattern = ""
            $start = 0
        } else {
            $start = $pattern.length - 1
        }
        for ($i=$start; $i -lt $length; $i++)
        {
            $pattern += $pattern_class[$rnd.Next($pattern_class.length)]
        }
     }
     $password = ""
     for ($i=0; $i -lt $length; $i++)
     {   
        $wpool = $charpool[[string]$pattern[$i]]      
        $password += $wpool[$rnd.Next($wpool.length)]    
     }                
     return $password
}

$Psswrd = Create-Password -length 12 -pattern ULNUSLLSUNLS

##########################################################

#New-ADUser -Name ($DisplayName) –SamAccountName ($UserID) –DisplayName ($DisplayName) -GivenName ($GivenName) -Surname ($Surname) -UserPrincipalName ($UserID + '@Global.BDFGroup.net') –Enabled $true –ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString "9WEYC387o:uU" -AsPlainText -force) -Path "ou=Adminaccounts,ou=Users,ou=DE0156,ou=Consumer,dc=global,dc=bdfgroup,dc=net" -Server $DomainCotroller

##########################################################

New-ADUser -Name ($DisplayName) –SamAccountName ($UserID) –DisplayName ($DisplayName) -GivenName ($GivenName) -Surname ($Surname) -UserPrincipalName ($UserID + '@Global.BDFGroup.net') –Enabled $true –ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString $Psswrd -AsPlainText -force) -Path "ou=Adminaccounts,ou=Users,ou=DE0156,ou=Consumer,dc=global,dc=bdfgroup,dc=net" -Server $DomainCotroller

##########################################################
##########################################################

Set-ADUser ($UserID) -Description ($Description) -Department ($Kststelle) -Company ($Company) -AccountExpirationDate $Ablauf  -replace @{"extensionattribute3" = $Attribute3; "extensionattribute14" = $Attribute14} -Server $DomainCotroller
Set-ADUser ($UserID) -clear msnpallowdialin -Server $DomainCotroller


$ADMCreateProgressBar.Value = 50
$ADMCreateProgressBarLabel.Text = "Der ADM-Account wird konfiguriert..."
$ADMCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Der ADM-Account wird konfiguriert.........."
[void]$ADMCreateProgressBarForm.Refresh()

function CreatedCheck
{
$CreatedAcc = Get-ADUser -Filter {SamAccountName -eq $UserID} -Properties DistinguishedName -Server $DomainCotroller

If ($CreatedAcc)
    {
    Set-ADUser $User.SamAccountName -add @{seeAlso = [string]$CreatedAcc.DistinguishedName} -Server $DomainCotroller
    If ($AddUserNameAttr9) {Set-ADUser ($UserID) -replace @{"extensionattribute9" = ($AddUserNameAttr9)} -Server $DomainCotroller}
    }
Else
    {
    Start-Sleep 3
    $ADMCreateProgressBar.Value = [int]$ADMCreateProgressBar.Value + 10
    [void]$ADMCreateProgressBarForm.Refresh()
    CreatedCheck
    }
}

CreatedCheck

##########################################################
##########################################################

$SMTP = New-Object Net.Mail.SmtpClient("smtp.global.bdfgroup.net")
$ADMMail = New-Object Net.Mail.MailMessage 
$ADMMail.From = "UA-Tool_CreateADMAccount@Beiersdorf.com"
$ADMMail.To.Add("UserAdministrationHAM@Beiersdorf.com")
$ADMMail.Subject = "Account Information for New ADM Account"
$ADMMail.Body = "
Dear Mrs/Mr " + $SurName + ", " + $GivenName + ",

A new ADM account was created for you.

User-ID: " + $UserID + "
Password: " + $Psswrd + "


Best regards / mit freundlichen Grüßen,

User Administration

Beiersdorf Shared Services GmbH
Mail Box 69
Quickbornstrasse 24
20253 Hamburg
Germany

T +49 40 4909-3737
E UserAdministrationHAM@beiersdorf.com
"

$SMTP.Send($ADMMail)

##########################################################

#$ol = New-Object -comObject Outlook.Application

#$mail = $ol.CreateItem(0)
#$mail.To = "$UserDisplay"
#$mail.CC ="User Administration /BSS HAM"
#$mail.Subject = "Account Information for New ADM Account"
#$mail.Body = "Dear Mrs/Mr " + $SurName + ", " + $GivenName + ",

#A new ADM account was created for you.

#User-ID: $UserID
#Passwort: Start123

#Best regards / mit freundlichen Grüßen,

#User Administration Hamburg

#Beiersdorf Shared Services GmbH
#Mail Box 69
#Quickbornstrasse 24
#20253 Hamburg
#Germany

#T +49 40 4909-3737
#E  UserAdministrationHAM@Beiersdorf.com"
#$mail.importance = 2
#$mail.save()

#$inspector = $mail.GetInspector
#$inspector.Display()

##########################################################
##########################################################

$ADMCreateProgressBar.Value = 100
$ADMCreateProgressBarLabel.Text = "Der ADM-Account wurde erstellt."
$ADMCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Der ADM-Account wurde erstellt!"
[void]$ADMCreateProgressBarForm.Refresh()
$ADMCreateProgressBarForm.Add_Shown({$ADMCreateProgressBarForm.Activate()})
$ADMCreateProgressBarButtonOk.Enabled =$true
$ADMCreateProgressBarForm.Visible = $false
$ADMCreateProgressBarForm.TopMost = $true
[void]$ADMCreateProgressBarForm.ShowDialog()
$UA_ToolTab1_1ClosureTextBox.Text = "ADM-Account created." + [System.Environment]::NewLine + "User-ID: $UserID" + [System.Environment]::NewLine + "Login credentials send via mail."
$DateLogging = Get-Date -Format dd.MM.yyyy
$TimeLogging = (Get-Date).ToShortTimeString()
$UAToolLogging = $TimeLogging + ";" + $env:USERNAME + ";ADM-Account;OK"
$LoggingFile = "E:\Scripts\Fertig\UA-Tool\Log\" + $DateLogging + ".txt"
Add-Content $LoggingFile ($UAToolLogging)
$UA_ToolForm.Focus()
}
Catch
{
$MailMessageText = @($Error) + 
@([System.Environment]::NewLine) + 
@("Exception Type: $($Error.Exception.GetType().FullName)") +
@([System.Environment]::NewLine) + 
@("Exception Message: $($Error.Exception.Message)") +
@([System.Environment]::NewLine) + 
@("Position: $($Error.InvocationInfo.PositionMessage)") +
@([System.Environment]::NewLine) + 
@("User: $env:USERNAME")
$SMTP = New-Object Net.Mail.SmtpClient("smtp.global.bdfgroup.net")
$MailMessage = New-Object Net.Mail.MailMessage 
$MailMessage.From = "UA-Tool_ADMAcc_ERROR@Beiersdorf.com"
$MailMessage.To.Add("UserAdministrationHAM@Beiersdorf.com")
$MailMessage.Subject = "ADMAcc Script hat einen Fehler gefunden"
$MailMessage.Body = $MailMessageText
$SMTP.Send($MailMessage)
$UA_ToolTab1_1ClosureTextBox.Text = $Error.Exception.Message
$ADMCreateProgressBar.Value = 100
$ADMCreateProgressBarLabel.Text = "Fehler!"
$ADMCreateProgressBarTextBox.Text += "Fehler" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Es sind Fehler aufgetreten! Abbruch...!"
[void]$ADMCreateProgressBarForm.Refresh()
$ADMCreateProgressBarForm.Add_Shown({$ADMCreateProgressBarForm.Activate()})
$ADMCreateProgressBarButtonOk.Enabled =$true
$ADMCreateProgressBarForm.Visible = $false
$ADMCreateProgressBarForm.TopMost = $true
[void]$ADMCreateProgressBarForm.ShowDialog()
$DateLogging = Get-Date -Format dd.MM.yyyy
$TimeLogging = (Get-Date).ToShortTimeString()
$UAToolLogging = $TimeLogging + ";" + $env:USERNAME + ";ADM-Account;FEHLER"
$LoggingFile = "E:\Scripts\Fertig\UA-Tool\Log\" + $DateLogging + ".txt"
Add-Content $LoggingFile ($UAToolLogging)
$Error.Clear()
$UA_ToolForm.Focus()
}