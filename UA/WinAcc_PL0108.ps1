#
# Author: San Steven Johannsen
#
# Funktion: Zum Erstellen von Windows-Accounts für PL0108
#

$Error.Clear()

Try {
#region WinAccCreateProgressBar

$WinAccCreateProgressBarForm = New-Object System.Windows.Forms.Form 
$WinAccCreateProgressBarForm.Size = New-Object System.Drawing.Size(400,300)
$WinAccCreateProgressBarForm.Text = "Windows-Account PL0108 erstellen..."
$WinAccCreateProgressBarForm.ControlBox = $false
$WinAccCreateProgressBarForm.FormBorderStyle = "FixedSingle"
$WinAccCreateProgressBarForm.StartPosition = "CenterScreen"
$WinAccCreateProgressBarForm.ShowInTaskbar = $false

$WinAccCreateProgressBarLabel = New-Object System.Windows.Forms.Label
$WinAccCreateProgressBarLabel.Location = New-Object System.Drawing.Size(5,10)
$WinAccCreateProgressBarLabel.Size = New-Object System.Drawing.Size(375,20)
$WinAccCreateProgressBarForm.Controls.Add($WinAccCreateProgressBarLabel)

$WinAccCreateProgressBar = New-Object System.Windows.Forms.ProgressBar
$WinAccCreateProgressBar.Location = New-Object System.Drawing.Size(5,35)
$WinAccCreateProgressBar.Size = New-Object System.Drawing.Size(375,20)
$WinAccCreateProgressBar.Style = "Continuous"
$WinAccCreateProgressBar.Value = 0
$WinAccCreateProgressBar.Step = 33
$WinAccCreateProgressBarForm.Controls.Add($WinAccCreateProgressBar)

$WinAccCreateProgressBarTextBox = New-Object System.Windows.Forms.RichTextBox
$WinAccCreateProgressBarTextBox.Location = New-Object System.Drawing.Size(5,70) 
$WinAccCreateProgressBarTextBox.Size = New-Object System.Drawing.Size(375,140)
$WinAccCreateProgressBarTextBox.ReadOnly = $true
$WinAccCreateProgressBarForm.Controls.Add($WinAccCreateProgressBarTextBox)

$WinAccCreateProgressBarButtonOk = New-Object System.Windows.Forms.Button
$WinAccCreateProgressBarButtonOk.Location = New-Object System.Drawing.Size(150,215)
$WinAccCreateProgressBarButtonOk.Size = New-Object System.Drawing.Size(120,40)
$WinAccCreateProgressBarButtonOk.Text = "Ok"
$WinAccCreateProgressBarButtonOk.Enabled =$false
$WinAccCreateProgressBarButtonOk.Add_Click({$WinAccCreateProgressBarForm.Close()})
$WinAccCreateProgressBarForm.Controls.Add($WinAccCreateProgressBarButtonOk)

[void]$WinAccCreateProgressBarForm.Show()
[void]$WinAccCreateProgressBarForm.Focus()
[void]$WinAccCreateProgressBarForm.Refresh()

#endregion WinAccCreateProgressBar

#region Functions
function Create-Username ()
    {
    param ([string]$LastName, [string]$FirstName, [string]$lncounter)
    $LastName = $LastName -replace " ","" -replace "'","" -replace "-",""
    $FirstName = $FirstName -replace " ","" -replace "'","" -replace "-",""
    $fncounter = 1
    $Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter))
    While (Get-ADUser -filter {samaccountname -eq $Username}) 
    { 
    $fncounter += 1
    $lncounter -= 1
    $Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter))
    }
    return $Username
    }

. E:\Scripts\Fertig\UA-Tool\PS\Office365.ps1

#endregion Functions

#region WinAcc Variablen
$SurName = $UA_ToolTab1_6PL0108TextBoxSurName.Text
$GivenName = $UA_ToolTab1_6PL0108TextBoxGivenName.Text
$UserID = $UA_ToolTab1_6PL0108TextBoxUserID.Text
$Kst = $UA_ToolTab1_6PL0108TextBoxDepart.Text
$Manager = $UA_ToolTab1_6PL0108TextBoxManager.Text
$JobTitle = $UA_ToolTab1_6PL0108TextBoxJobTitle.Text
$Ablauf = $UA_ToolTab1_6PL0108TextBoxValidTo.Text
$Office = $UA_ToolTab1_6PL0108TextBoxOffice.Text
$Department = $UA_ToolTab1_6PL0108ComboBox.Text
$Telefon =  $UA_ToolTab1_6PL0108TextBoxTelefon.Text
$Mailbox = If ($UA_ToolTab1_6PL0108CheckBox1.Checked -eq $true) {"1"} Else {"0"}
$Homedrive = If ($UA_ToolTab1_6PL0108CheckBox2.Checked -eq $true) {"1"} Else {"0"}
$AccountType = If ($UA_ToolTab1_6PL0108RadioButton1.Checked -eq $true) {"Intern"} ElseIf ($UA_ToolTab1_6PL0108RadioButton2.Checked -eq $true) {"Trainee"} ElseIf ($UA_ToolTab1_6PL0108RadioButton3.Checked -eq $true) {"Praktikant"} ElseIf ($UA_ToolTab1_6PL0108RadioButton4.Checked -eq $true) {"Werkstudent"} ElseIf ($UA_ToolTab1_6PL0108RadioButton5.Checked -eq $true) {"Extern"}

$DomainCotroller = Get-ADDomainController
$DomainCotroller = $DomainCotroller.HostName

$SurName = $SurName.Trim()
$SurName = $SurName -replace "ä", "ae"
$SurName = $SurName -replace "Ä", "Ae"
$SurName = $SurName -replace "ö", "oe"
$SurName = $SurName -replace "Ö", "Oe"
$SurName = $SurName -replace "ü", "ue"
$SurName = $SurName -replace "Ü", "Ue"
$SurName = $SurName -replace "ß", "ss"
$GivenName = $GivenName.Trim()
$GivenName = $GivenName -replace "ä", "ae"
$GivenName = $GivenName -replace "Ä", "Ae"
$GivenName = $GivenName -replace "ö", "oe"
$GivenName = $GivenName -replace "Ö", "Oe"
$GivenName = $GivenName -replace "ü", "ue"
$GivenName = $GivenName -replace "Ü", "Ue"
$GivenName = $GivenName -replace "ß", "ss"

$SurName2 = $SurName -replace (" ","")
$GivenName2 = $GivenName -replace (" ","")
$DisplayName2 = $SurName + ", " + $GivenName

If ($UserID -eq "") {$UserID = Create-Username -LastName $SurName -FirstName $GivenName -lncounter "6"}

If ($Mailbox -eq "1")
    {
    If ($AccountType -eq "Extern") {$UserPrincipal = $GivenName2 + "." + $SurName2 + ".external@Beiersdorf.com"}
    Else {$UserPrincipal = $GivenName2 + "." + $SurName2 + "@Beiersdorf.com"}
    }
Else {$UserPrincipal = $UserID + '@Global.BDFGroup.net'}
$pool = "lync08.global.bdfgroup.net"
$SMTP = $GivenName2 + "." + $SurName2 + "@Beiersdorf.com"
[String]$Psswrd = "Frewq123"
$StreetAddress = "Gnieznieska 32"
$CityAddress = "Poznan"
$PostalCodeAdr = "61-021"
$CountryAddress = "PL"
$Attr14 = "internalemployee"

If ($Manager) {$Manager2 = Get-ADUser -Filter {Name -eq $Manager}}
If ($Ablauf) {$Ablauf2 = (Get-Date $Ablauf -displayhint date).AddDays(1)}


If ($Department -eq "PL0108") {
    $OU = "ou=Users,ou=PL0108,ou=Consumer,dc=global,dc=bdfgroup,dc=net"
    If ($AccountType -eq "Extern") {$DisplayName = $DisplayName2 + " ext. /BDF POZ"} Else {$DisplayName = $DisplayName2 + " /BDF POZ"}
    $Company = "NIVEA Polska Sp. z o.o."
    $Attr3 = "PL0108"
    $Attr3Database = "*" + $Attr3 + "*"
    $Database = (Get-MailboxDatabase $Attr3Database -Status | Select Name | Sort Name -Descending | Select -First 1).Name
    $Template = "UsernamePL0108"
    $ScriptPath = "PL0108-POZ\PL0108-POZ-vista01.bat"
    }

If ($Department -eq "PL0235") {
    $OU = "ou=Users,ou=PL0235,ou=Consumer,dc=global,dc=bdfgroup,dc=net"
    If ($AccountType -eq "Extern") {$DisplayName = $DisplayName2 + " ext. /BMP POZ"} Else {$DisplayName = $DisplayName2 + " /BMP POZ"}
    $Company = "Beiersdorf Manufacturing Poznan Sp. z o.o."
    $Attr3 = "PL0235"
    $Attr3Database = "*" + $Attr3 + "*"
    $Database = (Get-MailboxDatabase $Attr3Database -Status | Select Name | Sort Name -Descending | Select -First 1).Name
    $Template = "UsernamePL0235"
    $ScriptPath = "PL0235-POZ\PL0235-POZ-vista01.bat"
    }

If ($AccountType -eq "Praktikant") {$Description = "bis " + $Ablauf + " - Praktikant"}
If ($AccountType -eq "Werkstudent") {$Description = "bis " + $Ablauf + " - Werkstudent"}
If ($AccountType -eq "Extern") {$Description = "bis " + $Ablauf; $SMTP = $GivenName2 + "." + $SurName2 + ".external@Beiersdorf.com"; $Attr14 = "externalemployee"}
If ($AccountType -eq "Intern" -and $Ablauf) {$Description = "bis " + $Ablauf}
If ($AccountType -eq "Trainee" -and $Ablauf) {$Description = "bis " + $Ablauf + " - Trainee"} ElseIf ($AccountType -eq "Trainee") {$Description = "Trainee"}

#endregion WinAcc Variablen

#region WinAcc AD-Account
$WinAccCreateProgressBar.Value = 5
$WinAccCreateProgressBarLabel.Text = "Der AD-Account wird erstellt..."
$WinAccCreateProgressBarTextBox.Text += "Der AD-Account wird erstellt.........."
[void]$WinAccCreateProgressBarForm.Refresh()

New-ADUser -Name ($DisplayName) -Displayname ($DisplayName) –SamAccountName ($UserID) -GivenName ($GivenName) -Surname ($Surname) -UserPrincipalName ($UserPrincipal) –Enabled $true –ChangePasswordAtLogon $true -AccountPassword (ConvertTo-SecureString $Psswrd -AsPlainText -force) -Path ($OU) -Server $DomainCotroller
Set-ADUser ($UserID) -Description ($Description) -ScriptPath $ScriptPath -StreetAddress $StreetAddress -City $CityAddress -PostalCode $PostalCodeAdr -Country $CountryAddress -Company ($Company) -AccountExpirationDate $Ablauf2 -replace @{"extensionattribute3" = $Attr3; "extensionattribute14" = $Attr14; msnpallowdialin=$true} -Server $DomainCotroller

    If ($Kst) {Set-ADUser ($UserID) -Department ($Kst) -Server $DomainCotroller}
    If ($Manager2) {Set-ADUser ($UserID) -Manager ($Manager2) -Server $DomainCotroller}
    If ($Office) {Set-ADUser ($UserID) -Office ($Office) -Server $DomainCotroller}
    If ($JobTitle) {Set-ADUser ($UserID) -Title ($JobTitle) -Server $DomainCotroller}

If ($AccountType -ne "Extern") {Get-ADUser -Identity $Template -Properties memberof -Server $DomainCotroller | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $UserID -Server $DomainCotroller}

If ($Mailbox -eq "1") {Office365 -AccountType $AccountType -DomainCotroller $DomainCotroller -UserID $UserID}

If ($Mailbox -ne "1") {$WinAccCreateProgressBar.Value = 50; [void]$WinAccCreateProgressBarForm.Refresh()}
#endregion WinAcc AD-Account

#region WinAcc Mailbox
If ($Mailbox -eq "1")
    {
    $WinAccCreateProgressBar.Value = 10
    $WinAccCreateProgressBarLabel.Text = "Das Postfach wird erstellt..."
    $WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Das Postfach wird erstellt.........."
    [void]$WinAccCreateProgressBarForm.Refresh()
    
    function CreatedCheck
    {
    $CreatedAcc = Get-ADUser -Filter {SamAccountName -eq $UserID} -Server $DomainCotroller

    If ($CreatedAcc)
        {
        Enable-Mailbox $CreatedAcc.SamAccountName -Database $Database -Alias $UserID -PrimarySmtpAddress $SMTP -DomainController $DomainCotroller -ActiveSyncMailboxPolicy "Default Mailbox Mobile Policy" -ErrorAction Stop
        }
    Else
        {
        Start-Sleep 3
        $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
        [void]$WinAccCreateProgressBarForm.Refresh()
        CreatedCheck
        }
    }

    function CreatedMailCheck
    {
    $CreatedAcc = Get-ADUser -Filter {SamAccountName -eq $UserID} -Server $DomainCotroller -Properties proxyAddresses

    If ($CreatedAcc.proxyAddresses -like "SMTP:*")
        {
        Set-Mailbox $UserID -EmailAddressPolicyEnabled $false -DomainController $DomainCotroller
        }
    Else
        {
        Start-Sleep 3
        $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
        [void]$WinAccCreateProgressBarForm.Refresh()
        CreatedMailCheck
        }
    }

    CreatedCheck

    $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
    $WinAccCreateProgressBarLabel.Text = "Das Postfach wird konfiguriert..."
    $WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Das Postfach wird konfiguriert.........."
    [void]$WinAccCreateProgressBarForm.Refresh()

    CreatedMailCheck
    }
#endregion WinAcc Mailbox

#region WinAcc Homedrive
If ($Homedrive -eq "1")
    {
    $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
    $WinAccCreateProgressBarLabel.Text = "Das Homedrive wird erstellt..."
    $WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Das Homedrive wird erstellt.........."
    [void]$WinAccCreateProgressBarForm.Refresh()

    $Homedirectory = "\\POZS0001\data\home\" + $UserID
    Set-ADUser $UserID –HomeDrive "H:" –HomeDirectory $Homedirectory -Server $DomainCotroller
    }
#endregion WinAcc Homedrive

#region WinAcc Lync
If ($Mailbox -eq "1")
    {
    $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 10
    $WinAccCreateProgressBarLabel.Text = "Lync wird aktiviert..."
    $WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Lync wird aktiviert.........."
    [void]$WinAccCreateProgressBarForm.Refresh()
    
    function CreatedLyncEnableCheck
    {
    $CreatedLync = Get-CsAdUser -Filter {SamAccountName -eq $UserID} -DomainController $DomainCotroller

    If ($CreatedLync.proxyAddresses -like "SMTP:*")
        {
        Enable-CsUser $CreatedLync.SamAccountName -RegistrarPool $Pool –SipAddressType EmailAddress –SipDomain beiersdorf.com -DomainController $DomainCotroller
        }
    Else
        {
        Start-Sleep 3
        $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
        [void]$WinAccCreateProgressBarForm.Refresh()
        CreatedLyncEnableCheck
        }
    }

    function CreatedLyncCheck
    {
    $CreatedLync = Get-CsAdUser -Filter {SamAccountName -eq $UserID} -DomainController $DomainCotroller

    If ($CreatedLync.Enabled -eq $true)
        {
        $CreatedLync2 = Get-CsUser -Filter {SamAccountName -eq $UserID} -DomainController $DomainCotroller

        If ($CreatedLync2)
            {
            Grant-CsConferencingPolicy $CreatedLync2.SamAccountName –PolicyName "Conf_AllModalities_NoRec_Size50_Default" -DomainController $DomainCotroller
            Grant-CsExternalAccessPolicy $CreatedLync2.SamAccountName –PolicyName "Allow Federation+Public+Outside Access" -DomainController $DomainCotroller
            Grant-CsClientPolicy $CreatedLync2.SamAccountName -PolicyName "Global_SkypeEnabled" -DomainController $DomainCotroller
            }
        Else
            {
            CreatedLyncEnableCheck
            }
        }
    Else
        {
        Start-Sleep 3
        $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
        [void]$WinAccCreateProgressBarForm.Refresh()
        CreatedLyncCheck
        }
    }

    CreatedLyncEnableCheck

    $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
    $WinAccCreateProgressBarLabel.Text = "Lync wird konfiguriert..."
    $WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Lync wird konfiguriert.........."
    [void]$WinAccCreateProgressBarForm.Refresh()

    CreatedLyncCheck
    }

#region EnterpriseVoice
If ($Telefon) 
{
$NrExt = $Telefon.trim()
$TelNrStamm = "+48618746"
$NrExt = $NrExt.remove(0,$NrExt.length - 3)
$DialPlan = "SIPPOZ.BDFGroup.net"
$VoicePolicy = "POZ EV international"

$TelNr = "+48 61 8746 " + $NrExt
$LineURI = "Tel:" + $TelNrStamm + $NrExt + ";ext=" + $NrExt
$LineURI2 = "tel:" + $TelNrStamm + $NrExt + "*"
$TelNr2 = "*" + $NrExt + "*"

$CheckUser = Get-ADUser $UserID -Properties proxyAddresses -Server $DomainCotroller

If ($CheckUser.proxyAddresses -like "SMTP:*") {$CheckUserLineURI = "1"} Else {$CheckUserLineURI = "2"}

$WinAccCreateProgressBar.Value = 72
$WinAccCreateProgressBarLabel.Text = "Die Nummer wird überprüft..."
$WinAccCreateProgressBarTextBox.Text += [System.Environment]::NewLine + "Die Nummer $NrExt wird überprüft.........."
[void]$WinAccCreateProgressBarForm.Refresh()
       
$CheckLync = Get-CsUser -Filter {LineURI -like $LineURI2} -DomainController $DomainCotroller

$WinAccCreateProgressBar.Value = 75
[void]$WinAccCreateProgressBarForm.Refresh()

If ($CheckLync)
    {
    $UA_ToolTab1_6PL0108ClosureTextBox.Text = "Die Nummer $NrExt ist bereits im Lync vergeben! Abbruch...!" + [System.Environment]::NewLine + [System.Environment]::NewLine + "User: " + $CheckLync.Name
    $WinAccCreateProgressBar.Value = 100
    $WinAccCreateProgressBarLabel.Text = "Fehler!"
    $WinAccCreateProgressBarTextBox.Text += "Fehler" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Die Nummer $NrExt ist bereits im Lync vergeben! Abbruch...!" + [System.Environment]::NewLine + "User: " + $CheckLync.Name
    [void]$WinAccCreateProgressBarForm.Refresh()
    $WinAccCreateProgressBarForm.Add_Shown({$WinAccCreateProgressBarForm.Activate()})
    $WinAccCreateProgressBarButtonOk.Enabled =$true
    $WinAccCreateProgressBarForm.Visible = $false
    [void]$WinAccCreateProgressBarForm.ShowDialog()
    $Error.Clear()
    }
ElseIf ($CheckUserLineURI -eq "2")
    {
    $UA_ToolTab1_6PL0108ClosureTextBox.Text = "Der User hat keine Mailbox! Abbruch...!"
    $WinAccCreateProgressBar.Value = 100
    $WinAccCreateProgressBarLabel.Text = "Fehler!"
    $WinAccCreateProgressBarTextBox.Text += "Fehler" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Der User hat keine Mailbox! Abbruch...!"
    [void]$WinAccCreateProgressBarForm.Refresh()
    $WinAccCreateProgressBarForm.Add_Shown({$WinAccCreateProgressBarForm.Activate()})
    $WinAccCreateProgressBarButtonOk.Enabled =$true
    $WinAccCreateProgressBarForm.Visible = $false
    [void]$WinAccCreateProgressBarForm.ShowDialog()
    $Error.Clear()
    }
Else 
{
$WinAccCreateProgressBar.Value = 80
$WinAccCreateProgressBarLabel.Text = "Enterprise Voice wird aktiviert..."
$WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Enterprise Voice wird aktiviert.........."
[void]$WinAccCreateProgressBarForm.Refresh()

function CreatedLyncCheck
{
$CreatedLync = Get-CsAdUser -Filter {SamAccountName -eq $UserID} -DomainController $DomainCotroller

If ($CreatedLync.Enabled -eq $true)
    {
    $CreatedLync2 = Get-CsUser -Filter {SamAccountName -eq $UserID} -DomainController $DomainCotroller

    If ($CreatedLync2)
        {
        $WinAccCreateProgressBar.Value = 85
        $WinAccCreateProgressBarLabel.Text = "Enterprise Voice wird konfiguriert..."
        $WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + "Enterprise Voice wird konfiguriert.........."
        [void]$WinAccCreateProgressBarForm.Refresh()
        
        Set-ADUser $UserID -Replace @{telephoneNumber = $TelNr} -Server $DomainCotroller

        Set-CsUser $UserID -EnterpriseVoiceEnabled $true -LineURI $LineURI -DomainController $DomainCotroller
        Grant-CsVoicePolicy $UserID -PolicyName $VoicePolicy -DomainController $DomainCotroller
        Grant-CsDialPlan $UserID -PolicyName $DialPlan -DomainController $DomainCotroller

        $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
        [void]$WinAccCreateProgressBarForm.Refresh()
        }
    Else
        {
        Start-Sleep 3
        $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
        [void]$WinAccCreateProgressBarForm.Refresh()
        CreatedLyncCheck
        }
    }
Else
    {
    Start-Sleep 3
    $WinAccCreateProgressBar.Value = [int]$WinAccCreateProgressBar.Value + 5
    [void]$WinAccCreateProgressBarForm.Refresh()
    CreatedLyncCheck
    }
}

CreatedLyncCheck

}
}
#endregion EnterpriseVoice
#endregion WinAcc Lync

$WinAccCreateProgressBar.Value = 100
$WinAccCreateProgressBarLabel.Text = "Der Account wurde erstellt."
$WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Der Account wurde erfolgreich erstellt und konfiguriert!"
[void]$WinAccCreateProgressBarForm.Refresh()
$WinAccCreateProgressBarForm.Add_Shown({$WinAccCreateProgressBarForm.Activate()})
$WinAccCreateProgressBarButtonOk.Enabled =$true
$WinAccCreateProgressBarForm.Visible = $false
$WinAccCreateProgressBarForm.TopMost = $true
[void]$WinAccCreateProgressBarForm.ShowDialog()
$UA_ToolTab1_6PL0108ClosureTextBox.Text = "Account created. User-ID: $UserID"
$DateLogging = Get-Date -Format dd.MM.yyyy
$TimeLogging = (Get-Date).ToShortTimeString()
$UAToolLogging = $TimeLogging + ";" + $env:USERNAME + ";Windows-Account PL0108;OK"
$LoggingFile = "E:\Scripts\Fertig\UA-Tool\Log\" + $DateLogging + ".txt"
Add-Content $LoggingFile ($UAToolLogging)
$UA_ToolForm.Focus()
}
Catch {
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
$MailMessage.From = "UA-Tool_WinAccPL0108_ERROR@Beiersdorf.com"
$MailMessage.To.Add("SanSteven.Johannsen.external@Beiersdorf.com")
$MailMessage.Subject = "WinAccPL0108 Script hat einen Fehler gefunden"
$MailMessage.Body = $MailMessageText
$SMTP.Send($MailMessage)
$UA_ToolTab1_6PL0108ClosureTextBox.Text = $Error.Exception.Message
$WinAccCreateProgressBar.Value = 100
$WinAccCreateProgressBarLabel.Text = "Fehler!"
$WinAccCreateProgressBarTextBox.Text += "Fehler" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Es sind Fehler aufgetreten! Abbruch...!"
[void]$WinAccCreateProgressBarForm.Refresh()
$WinAccCreateProgressBarForm.Add_Shown({$WinAccCreateProgressBarForm.Activate()})
$WinAccCreateProgressBarButtonOk.Enabled =$true
$WinAccCreateProgressBarForm.Visible = $false
$WinAccCreateProgressBarForm.TopMost = $true
[void]$WinAccCreateProgressBarForm.ShowDialog()
$DateLogging = Get-Date -Format dd.MM.yyyy
$TimeLogging = (Get-Date).ToShortTimeString()
$UAToolLogging = $TimeLogging + ";" + $env:USERNAME + ";Windows-Account PL0108;FEHLER"
$LoggingFile = "E:\Scripts\Fertig\UA-Tool\Log\" + $DateLogging + ".txt"
Add-Content $LoggingFile ($UAToolLogging)
$Error.Clear()
$UA_ToolForm.Focus()
}