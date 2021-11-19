#
# Author: Cornelia Düring
#
# Funktion: Zum Erstellen von Windows-Accounts für CN0231
#

$Error.Clear()

Try {
#region WinAccCreateProgressBar

$WinAccCreateProgressBarForm = New-Object System.Windows.Forms.Form 
$WinAccCreateProgressBarForm.Size = New-Object System.Drawing.Size(400,300)
$WinAccCreateProgressBarForm.Text = "Windows-Account Affiliate erstellen..."
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
        if($Affiliate -eq "CN0231" -or $Affiliate -eq "CN0216") 
        {
            $fncounter = 12 - $LastName.Length
            if ($fncounter -le 0) {$fncounter =1} else {}
            if ($fncounter -gt $FirstName.Length) {$fncounter = $FirstName.Length} else {}
            $zaehler = 0
            $Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter))
            While (Get-ADUser -filter {samaccountname -eq $Username}) 
                { 
                $fncounter -= 1
                #$lncounter -= 1
                if ($zaehler -gt 0) {$Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter)) + $zaehler} 
                else {$Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter))}
                $zaehler +=1
                }
        } 
    else 
        {
        $fncounter = 1
    
        $Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter))
        While (Get-ADUser -filter {samaccountname -eq $Username}) 
            { 
            $fncounter += 1
            $lncounter -= 1
            $Username = $LastName.Substring(0,[Math]::Min($lastname.length,$lncounter)) + $FirstName.Substring(0,[Math]::Min($firstname.length,$fncounter))
            }
        }
        return $Username
      }

. E:\Scripts\Fertig\UA-Tool\PS\Office365.ps1

#endregion Functions

#region WinAcc Variablen
$SurName = $UA_ToolTab1_6CN0231TextBoxSurName.Text
$GivenName = $UA_ToolTab1_6CN0231TextBoxGivenName.Text
$UserID = $UA_ToolTab1_6CN0231TextBoxUserID.Text
$Department = $UA_ToolTab1_6CN0231TextBoxDepart.Text
$Manager = $UA_ToolTab1_6CN0231TextBoxManager.Text
$JobTitle = $UA_ToolTab1_6CN0231TextBoxJobTitle.Text
$Ablauf = $UA_ToolTab1_6CN0231TextBoxValidTo.Text
$Office = $UA_ToolTab1_6CN0231TextBoxOffice.Text
$Affiliate = $UA_ToolTab1_6CN0231ComboBox.Text
$extra_OU = $UA_ToolTab1_6CN0231ComboBox2.Text
$Mailbox = If ($UA_ToolTab1_6CN0231CheckBox1.Checked -eq $true) {"1"} Else {"0"}
$Homedrive = If ($UA_ToolTab1_6CN0231CheckBox2.Checked -eq $true) {"1"} Else {"0"}
$AccountType = If ($UA_ToolTab1_6CN0231RadioButton1.Checked -eq $true) {"Intern"} ElseIf ($UA_ToolTab1_6CN0231RadioButton2.Checked -eq $true) {"Trainee"} ElseIf ($UA_ToolTab1_6CN0231RadioButton3.Checked -eq $true) {"Praktikant"} ElseIf ($UA_ToolTab1_6CN0231RadioButton4.Checked -eq $true) {"Werkstudent"} ElseIf ($UA_ToolTab1_6CN0231RadioButton5.Checked -eq $true) {"Extern"}

$NrExt =  $UA_ToolTab1_6CN0231TextBoxTelefon.text
$adminDescription = $UA_ToolTab1_6CN0231TextBoxadminDescription.Text
$adminDisplayName = $UA_ToolTab1_6CN0231TextBoxadminDisplayname.Text
$employeeID = $UA_ToolTab1_6CN0231TextBoxemployeeID.Text

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
$Attr14 = "internalemployee"

switch ($Affiliate)
{
"CN0231" {$n=11; $SipDomain = "beiersdorf.cn"}
"CN0216" {$n=11; $SipDomain = "beiersdorf.cn"}
"CN0029" {$n=6; $SipDomain = "beiersdorf.com"}
}

If ($UserID -eq "") {$UserID = Create-Username -LastName $SurName -FirstName $GivenName -lncounter $n}

If ($Affiliate -eq "CN0029")
    {
    If ($Mailbox -eq "1")
    {
    If ($AccountType -eq "Extern") {$UserPrincipal = $GivenName2 + "." + $SurName2 + ".external@Beiersdorf.com"}
    Else {$UserPrincipal = $GivenName2 + "." + $SurName2 + "@Beiersdorf.com"}
    }
    Else {$UserPrincipal = $UserID + '@Global.BDFGroup.net'}
    }
Else
    {
    If ($Mailbox -eq "1")
    {
    If ($AccountType -eq "Extern") {$UserPrincipal = $GivenName2 + "." + $SurName2 + ".external@Beiersdorf.cn"}
    Else {$UserPrincipal = $GivenName2 + "." + $SurName2 + "@Beiersdorf.cn"}
    }
    Else {$UserPrincipal = $UserID + '@Global.BDFGroup.net'}
    }

If ($Affiliate -eq "CN0231") {
    $OU = "ou=Users,ou=CN0216,ou=Consumer,dc=global,dc=bdfgroup,dc=net"
    If ($AccountType -eq "Extern") {$DisplayName = $DisplayName2 + " ext. /BDF WUH"} Else {$DisplayName = $DisplayName2 + " /BDF WUH"}
    $Company = "Beiersdorf Hair Care"
    $Attr3 = "CN0231"
    $Template = "templatewh"
    $Attr3Database = "*" + $Attr3 + "*"
    $Database = (Get-MailboxDatabase $Attr3Database -Status | Select Name | Sort Name -Descending | Select -First 1).Name
    $pool = "WUHA0088.global.bdfgroup.net"
    $ClientPolicy ="Global_SkypeEnabled"
    $SMTP = $GivenName2 + "." + $SurName2 + "@Beiersdorf.cn"
    [String]$Psswrd = "bdf@1234"
 }

If ($Affiliate -eq "CN0216") {
    $OU = "ou=Users,ou=CN0216,ou=Consumer,dc=global,dc=bdfgroup,dc=net"
    If ($AccountType -eq "Extern") {$DisplayName = $DisplayName2 + " ext. /BDF WUH"} Else {$DisplayName = $DisplayName2 + " /BDF WUH"}
    $Company = "Beiersdorf Hair Care"
    $Attr3 = "CN0216"
    $Template = "templatewh2"
    $Attr3Database = "*" + $Attr3 + "*"
    $Database = (Get-MailboxDatabase $Attr3Database -Status | Select Name | Sort Name -Descending | Select -First 1).Name
    $pool = "WUHA0088.global.bdfgroup.net"
    $ClientPolicy ="Global_SkypeEnabled"
    $SMTP = $GivenName2 + "." + $SurName2 + "@Beiersdorf.cn"
    [String]$Psswrd = "bdf@1234"
 }

If ($Affiliate -eq "CN0029") {
    $OU = "ou=CN0029,ou=Consumer,dc=global,dc=bdfgroup,dc=net"
    switch($extra_OU)
    {
    
                                            # Die OU wurde umbenannt von CN in SHA daher die Anpassung
    
    "CN0029: CN_Blue_Dragon" {$OU = "ou=Users, ou=CN_Blue_Dragon,ou=CN0029,ou=Consumer,dc=global,dc=bdfgroup,dc=net"}
    "CN0029: CN_DC_Office" {$OU = "ou=Users, ou=SHA_DC_Office,ou=CN0029,ou=Consumer,dc=global,dc=bdfgroup,dc=net"}
    "CN0029: CN_PC_Factory" {$OU = "ou=Users, ou=SHA_PC_Factory,ou=CN0029,ou=Consumer,dc=global,dc=bdfgroup,dc=net"}
    }
    If ($AccountType -eq "Extern") {$DisplayName = $DisplayName2 + " ext. /BDF SHA"} Else {$DisplayName = $DisplayName2 + " /BDF SHA"}
    $Company = "Beiersdorf China"
    $Attr3 = "CN0029"
    $Template = ""
    $Attr3Database = "*" + $Attr3 + "*"
    $Database = (Get-MailboxDatabase $Attr3Database -Status | Select Name | Sort Name -Descending | Select -First 1).Name
#    $pool = "SHAA0089.global.bdfgroup.net"
    $pool = "SHAA010088.global.bdfgroup.net"
    $SMTP = $GivenName2 + "." + $SurName2 + "@Beiersdorf.com"
    [String]$Psswrd = "AAaa1111"
 }
  
If ($Manager) {$Manager2 = Get-ADUser -Filter {Name -eq $Manager}}
If ($Ablauf) {$Ablauf2 = (Get-Date $Ablauf -displayhint date).AddDays(1)}

If ($AccountType -eq "Praktikant") {$Description = "bis " + $Ablauf + " - Praktikant"}
If ($AccountType -eq "Werkstudent") {$Description = "bis " + $Ablauf + " - Werkstudent"}
If ($AccountType -eq "Extern") {$Description = "bis " + $Ablauf; $Attr14 = "externalemployee"; If ($Affiliate -eq "CN0231" -or $Affiliate -eq "CN0216") {$SMTP = $GivenName2 + "." + $SurName2 + ".external@Beiersdorf.cn"} Else {$SMTP = $GivenName2 + "." + $SurName2 + ".external@Beiersdorf.com"}}
If ($AccountType -eq "Intern" -and $Ablauf) {$Description = "bis " + $Ablauf}
If ($AccountType -eq "Trainee" -and $Ablauf) {$Description = "bis " + $Ablauf + " - Trainee"} ElseIf ($AccountType -eq "Trainee") {$Description = "Trainee"}

#endregion WinAcc Variablen

#region WinAcc AD-Account
$WinAccCreateProgressBar.Value = 5
$WinAccCreateProgressBarLabel.Text = "Der AD-Account wird erstellt..."
$WinAccCreateProgressBarTextBox.Text += "Der AD-Account wird erstellt.........."
[void]$WinAccCreateProgressBarForm.Refresh()

If ($Affiliate -ne "CN0029") {
$template_user = Get-ADUser -Identity $Template -Properties * -Server $DomainCotroller
$StreetAddress = $template_user.StreetAddress
$CountryAddress = $template_user.Country
$CityAddress = $template_user.City
$PostalCodeAdr = $template_user.PostalCode
}

New-ADUser -Name ($DisplayName) -Displayname ($DisplayName) –SamAccountName ($UserID) -GivenName ($GivenName) -Surname ($Surname) -UserPrincipalName ($UserPrincipal) –Enabled $true –ChangePasswordAtLogon $true -AccountPassword (ConvertTo-SecureString $Psswrd -AsPlainText -force) -Path ($OU) -Server $DomainCotroller
Set-ADUser ($UserID) -Description ($Description)  -StreetAddress $StreetAddress -City $CityAddress -PostalCode $PostalCodeAdr -Country $CountryAddress -Company ($Company) -AccountExpirationDate $Ablauf2 -replace @{"extensionattribute3" = $Attr3; "extensionattribute14" = $Attr14; msnpallowdialin=$true}  -Server $DomainCotroller

If ($adminDisplayName) {Set-ADUser ($UserID) -replace @{"adminDisplayName" = $adminDisplayName; msnpallowdialin=$true}  -Server $DomainCotroller}
If ($adminDescription) {Set-ADUser ($UserID) -replace @{"adminDescription" = $adminDescription; msnpallowdialin=$true}  -Server $DomainCotroller}
If ($employeeID) {Set-ADUser ($UserID) -replace @{"employeeID" = $employeeID; msnpallowdialin=$true}  -Server $DomainCotroller}

    If ($Department) {Set-ADUser ($UserID) -Department ($Department) -Server $DomainCotroller}
    If ($Manager2) {Set-ADUser ($UserID) -Manager ($Manager2) -Server $DomainCotroller}
    If ($Office) {Set-ADUser ($UserID) -Office ($Office) -Server $DomainCotroller}
    If ($JobTitle) {Set-ADUser ($UserID) -Title ($JobTitle) -Server $DomainCotroller}

If ($Affiliate -eq "CN0231" -or $Affiliate -eq "CN0216")
{
    If ($Template) {Get-ADUser -Identity $Template -Properties memberof -Server $DomainCotroller | Select-Object -ExpandProperty memberof | Add-ADGroupMember -Members $UserID -Server $DomainCotroller} 
}
Else
{
$Department2 = $Department.split("(")

if ("Sales Department"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-Sales-All" -Members $UserID -Server $DomainCotroller}
if ("E-Commerce Department"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-eCommerce" -Members $UserID -Server $DomainCotroller}
if ("Eucerin Department"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-Eucerin" -Members $UserID -Server $DomainCotroller}
if ("Finance"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-FIN" -Members $UserID -Server $DomainCotroller}
if ("HR Department"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-HR-All" -Members $UserID -Server $DomainCotroller}
if ("Hair Care Marketing"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-Marketing_HC" -Members $UserID -Server $DomainCotroller}
if ("Skin Care Marketing"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-Marketing_SC" -Members $UserID -Server $DomainCotroller}
if ("Supply Chain Department"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-SupplyChain" -Members $UserID -Server $DomainCotroller}
if ("PC Shanghai"-match $Department2[0]) {Add-ADGroupMember "SHA-GG-PCMembers" -Members $UserID -Server $DomainCotroller}
if ("PC Wuhan"-match $Department2[0]) {Add-ADGroupMember "WUH-GG-PCMembers" -Members $UserID -Server $DomainCotroller}
if ("PC HR"-match $Department2[0]) {Add-ADGroupMember "CHN-GG-HR_PC&SC" -Members $UserID -Server $DomainCotroller}
if ("Regional Supply Chain Far East"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionSupplyChain" -Members $UserID -Server $DomainCotroller}
# if ("Regional Marketing Far East"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionMarketing" -Members $UserID -Server $DomainCotroller}
if ("Regional Finance Far East"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionFinance" -Members $UserID -Server $DomainCotroller}
#if ("Regional Media Far East"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionMedia" -Members $UserID -Server $DomainCotroller}
if ("Regional HR Far East"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionHR" -Members $UserID -Server $DomainCotroller}
if ("Skin Care R&D"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionInnovationHub-ALL" -Members $UserID -Server $DomainCotroller}
if ("Hair Care R&D"-match $Department2[0]) {Add-ADGroupMember "ASIA-GG-RegionInnovationHub-ALL" -Members $UserID -Server $DomainCotroller}

if ($Office -match "Ganghui Based DC") {Add-ADGroupMember "SHA-GG-GGW-DC" -Members $UserID -Server $DomainCotroller}
if ($Office -match "Ganghui Based DCSC") {Add-ADGroupMember "SHA-GG-GGW-DCSC" -Members $UserID -Server $DomainCotroller}
if ($Office -match "Ganghui Based FarEast") {Add-ADGroupMember "SHA-GG-GGW-FE" -Members $UserID -Server $DomainCotroller}
if ($Office -match "Shanghai PC Qingpu") {Add-ADGroupMember "SHA-GG-PCMembers" -Members $UserID -Server $DomainCotroller}
if ($Office -match "Wanda Based") {Add-ADGroupMember "WUH-GG-Wanda-ALL" -Members $UserID -Server $DomainCotroller}
if ($Office -match "Wuhan PC Zhuankou") {Add-ADGroupMember "WUH-GG-PCMembers" -Members $UserID -Server $DomainCotroller}
if ($Office -match "R&D Zhuankou") {Add-ADGroupMember "ASIA-GG-RegionInnovationHub-ALL" -Members $UserID -Server $DomainCotroller}
}

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
        Enable-Mailbox $CreatedAcc.SamAccountName -Database $Database -Alias $UserID -PrimarySmtpAddress $SMTP -DomainController $DomainCotroller -ErrorAction Stop
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
        if ($Affiliate -eq "CN0231" -and $AccountType -ne "Extern") {Set-Mailbox $UserID -EmailAddressPolicyEnabled $true -DomainController $DomainCotroller} else {}
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

    $Homedirectory = $Homepath + $UserID
   
    Set-ADUser $UserID –HomeDrive $Homeletter –HomeDirectory $Homedirectory -Server $DomainCotroller
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
        if ($ClientPolicy){Enable-CsUser $CreatedLync.SamAccountName -RegistrarPool $pool –SipAddressType EmailAddress –SipDomain $SipDomain -DomainController $DomainCotroller
        Grant-CsClientPolicy $CreatedLync.SamAccountName -PolicyName $ClientPolicy -DomainController $DomainCotroller}
        else
        {Enable-CsUser $CreatedLync.SamAccountName -RegistrarPool $pool –SipAddressType EmailAddress –SipDomain $SipDomain -DomainController $DomainCotroller
        }
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
#endregion WinAcc Lync

#region Lync
$NrExt = $NrExt.TRIM()
if ($NrExt) 
{

#region Variable gem Affiliate
switch ($Affiliate)
{
   "CN0231" {
            $TelNrStamm = "+86278473"
            $NrExt = $NrExt.remove(0,$NrExt.length - 4)
            $EUM = "eum:" + "*" + $NrExt + "*" + "SiWuh*"
            $dial = "SIPWUH.BDFGroup.net"
            $voice = "WUH EV national"
            $policy = "Global_Skype Enabled"
            }

   "CN0216" {
            $TelNrStamm = "+86278473"
            $NrExt = $NrExt.remove(0,$NrExt.length - 4)
            $EUM = "eum:" + "*" + $NrExt + "*" + "SiWuh*"
            $dial = "SIPWUH.BDFGroup.net"
            $voice = "WUH EV national"
            $policy = "Global_Skype Enabled"
            }

   "CN0029" {
            $TelNrStamm = "+86216700"
            $NrExt = $NrExt.remove(0,$NrExt.length - 4)
            $EUM = "eum:" + "*" + $NrExt + "*" + "SipSha*"
            $dial = "SIPSHA.BDFGroup.net"
            $voice = "SHA EV National"
            $policy = "Global_Skype Enabled"
            }
}

#bei allen gleich:
$TelNr = $TelNrStamm +" " + $NrExt
$LineURI = "Tel:" + $TelNrStamm + $NrExt + ";ext=" + $NrExt
$LineURI2 = "tel:" + $TelNrStamm + $NrExt + "*"
$TelNr2 = "*" + $NrExt + "*"

#endregion Variable gem Affiliate

$CheckUser = Get-ADUser $UserID -Properties proxyAddresses,extensionAttribute3,telephoneNumber,comOnC3kExtension -Server $DomainCotroller

If ($CheckUser.proxyAddresses -like "SIP:*") {$CheckUserLineURI = Get-CSUser $UserID -DomainController $DomainCotroller}
ElseIf ($CheckUser.proxyAddresses -like "SMTP:*") {$CheckUserLineURI = "1"}
Else {$CheckUserLineURI = "2"}

$CheckUserLyncNr = $CheckUserLineURI | where {$_.LineURI -like "tel:*"}

$WinAccCreateProgressBar.Value = 10
$WinAccCreateProgressBarLabel.Text = "Die Nummer wird überprüft..."
$WinAccCreateProgressBarTextBox.Text += [System.Environment]::NewLine + "Die Nummer $NrExt wird überprüft.........."
[void]$WinAccCreateProgressBarForm.Refresh()
       
$CheckLync = Get-CsUser -Filter {LineURI -like $LineURI2} -DomainController $DomainCotroller
$CheckArea = Get-CsCommonAreaPhone -Filter {LineURI -like $LineURI2} -DomainController $DomainCotroller

$WinAccCreateProgressBar.Value = 75
[void]$WinAccCreateProgressBarForm.Refresh()

$EUMCheck = Get-Mailbox -Filter "Emailaddresses -like '$TelNr2'"
$EUMCheck = $EUMCheck | where {$_.Emailaddresses -like $EUM}

If ($CheckUserLyncNr)
    {
    $UA_ToolTab1_6IN0213ClosureTextBox.Text = "Der User hat bereits eine Nummer im Lync! Abbruch...!"
    $WinAccCreateProgressBar.Value = 100
    $WinAccCreateProgressBarLabel.Text = "Fehler!"
    $WinAccCreateProgressBarTextBox.Text += "Fehler" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Der User hat bereits eine Nummer im Lync! Abbruch...!"
    [void]$WinAccCreateProgressBarForm.Refresh()
    $WinAccCreateProgressBarForm.Add_Shown({$WinAccCreateProgressBarForm.Activate()})
    $WinAccCreateProgressBarButtonOk.Enabled =$true
    $WinAccCreateProgressBarForm.Visible = $false
    [void]$WinAccCreateProgressBarForm.ShowDialog()
    $Error.Clear()
    }
ElseIf ($CheckLync)
    {
    $UA_ToolTab1_6IN0213ClosureTextBox.Text = "Die Nummer $NrExt ist bereits im Lync vergeben! Abbruch...!" + [System.Environment]::NewLine + [System.Environment]::NewLine + "User: " + $CheckLync.Name
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
    $UA_ToolTab1_6IN0213ClosureTextBox.Text = "Der User hat keine Mailbox! Abbruch...!"
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

If ($CheckUserLineURI -eq "1")
    {
    $WinAccCreateProgressBar.Value = 50
    $WinAccCreateProgressBarLabel.Text = "Lync aktivieren..."
    $WinAccCreateProgressBarTextBox.Text += "Fehler" + [System.Environment]::NewLine + "Der User muss erst im Lync aktiviert werden...Aktivierung läuft.........."
    [void]$WinAccCreateProgressBarForm.Refresh()

    Enable-CsUser $UserID -RegistrarPool $pool –SipAddressType EmailAddress –SipDomain $SipDomain -DomainController $DomainCotroller
    }

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
        Grant-CsVoicePolicy $UserID -PolicyName $voice -DomainController $DomainCotroller
        Grant-CsDialPlan $UserID -PolicyName $dial -DomainController $DomainCotroller
        Grant-CsConferencingPolicy $CreatedLync2.SamAccountName –PolicyName "Conf_AllModalities_NoRec_Size50_Default" -DomainController $DomainCotroller
        Grant-CsExternalAccessPolicy $CreatedLync2.SamAccountName –PolicyName "Allow Federation+Public+Outside Access" -DomainController $DomainCotroller
        Grant-CsClientPolicy $CreatedLync2.SamAccountName -PolicyName $policy -DomainController $DomainCotroller

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


function UserUMCheck
{
$UserUMCheck = Get-Mailbox $UserID -DomainController $DomainCotroller

If ($UserUMCheck.UmEnabled -eq $true)
    {
    Disable-UMMailbox $UserID -Confirm:$false -DomainController $DomainCotroller | Out-Null
    Start-Sleep -Seconds 5
    UserUMCheck
    }
Else
    {
    If ($UserUMCheck.EmailAddresses -like "EUM:*")
        {
        $DelEUM = $UserUMCheck | % emailaddresses | where {$_ -like "EUM:*"}
        Set-Mailbox $UserID -EmailAddresses @{remove = $DelEUM} -DomainController $DomainCotroller
        Start-Sleep 3
        UserUMCheck
        }
    Else
        {
        Enable-UMMailbox $UserID -UMMailboxPolicy "SipSHAExchange2010 Default Policy" -DomainController $DomainCotroller
        }
    }
}

UserUMCheck
}
}

#endregion Lync

$WinAccCreateProgressBar.Value = 100
$WinAccCreateProgressBarLabel.Text = "Der Account wurde erstellt."
$WinAccCreateProgressBarTextBox.Text += "Fertig" + [System.Environment]::NewLine + [System.Environment]::NewLine + "Der Account wurde erfolgreich erstellt und konfiguriert!"
[void]$WinAccCreateProgressBarForm.Refresh()
$WinAccCreateProgressBarForm.Add_Shown({$WinAccCreateProgressBarForm.Activate()})
$WinAccCreateProgressBarButtonOk.Enabled =$true
$WinAccCreateProgressBarForm.Visible = $false
$WinAccCreateProgressBarForm.TopMost = $true
[void]$WinAccCreateProgressBarForm.ShowDialog()
$UA_ToolTab1_6CN0231ClosureTextBox.Text = "Account created. User-ID: $UserID"
$DateLogging = Get-Date -Format dd.MM.yyyy
$TimeLogging = (Get-Date).ToShortTimeString()
$UAToolLogging = $TimeLogging + ";" + $env:USERNAME + ";Windows-Account CN0231;OK"
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
$MailMessage.From = "UA-Tool_WinAccCN0231_ERROR@Beiersdorf.com"
$MailMessage.To.Add("UserAdministrationHAM@Beiersdorf.com")
$MailMessage.BCC.Add("Cornelia.Duering.external@Beiersdorf.com")
$MailMessage.Subject = "$Affiliate Script hat einen Fehler gefunden"
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
$UAToolLogging = $TimeLogging + ";" + $env:USERNAME + ";Windows-Account $Affiliate;FEHLER"
$LoggingFile = "E:\Scripts\Fertig\UA-Tool\Log\" + $DateLogging + ".txt"
Add-Content $LoggingFile ($UAToolLogging)
$Error.Clear()
$UA_ToolForm.Focus()
}