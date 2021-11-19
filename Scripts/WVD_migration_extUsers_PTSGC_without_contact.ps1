<#
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=hamq-virtualdesktop-prod,3737;Initial Catalog=VirtualDesktop;Integrated Security=SSPI;"
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn



$Mig_state = "in Migration"
$Mig_wave = "Wave 3"
$WVD_Grp_consumer = "HAM-GG-WEU_Consumer_Europe_1"
$WVD_Grp_BSS = "HAM-GG-WEU_BSS_PRD_1"
$temptsGrp = "HAM-GG-WVD_Mig_GC_NO_BILLING"
$path_1 = "C:\temp\Wave3_AlreadyWVD.txt"
$path_2 = "C:\temp\Wave3_NewWVD.txt"
$tsgroup = "HAM-GG-BSS_TS_HAMS0687_BILLING"

#>

$OutputFile = "E:\RDS_Scripts\KohlerH\wave4.csv"

$member = Get-ADGroupMember -Identity HAM-GG-BSS_TS_HAMS0687_BILLING


foreach($extuser in $member)

{ 
    #Write-Host $extuser -BackgroundColor Red
    $p = get-aduser $extuser -Properties extensionattribute14,UserPrincipalName
    $p14 = $p.extensionattribute14

    
    #$p9 = get-aduser $extuser -Properties extensionattribute9,UserPrincipalName
    #$ext9 = $p9.extensionattribute9
    #$extUPN = $p9.UserPrincipalName

    #if($ext9 -eq $NULL){    
    #$intusermail = Get-ADUser -Filter {extensionattribute1 -eq $ext9} |Select-Object -ExpandProperty UserPrincipalName

    Write-Host $p.userprincipalname -ForegroundColor Green 
    Add-Content $OutputFile ($extuser.SamAccountName + ";" + $p.UserPrincipalName + ";" + $p14)

    #Write-Host $intusermail
    #$extusername = $extuser.SamAccountName

    #$query =  "UPDATE [VirtualDesktop].[dbo].[terminalservices_ADGrpMembers] SET [Migration] = '$Mig_state' WHERE SamAccountName = '$extusername'"
    #$cmd.commandtext = $query
    #$cmd.ExecuteNonQuery()
       
    #$query =  "UPDATE [VirtualDesktop].[dbo].[terminalservices_ADGrpMembers] SET [MigrationWave] = '$Mig_wave' WHERE SamAccountName = '$extusername'"
    #$cmd.commandtext = $query
    #$cmd.ExecuteNonQuery()

    #$line = $extuser.name + ";" + $extuser.SamAccountName + ";" + $intusermail
    #$line |Add-Content -Path C:\temp\extusers.csv
    

    <#

    $ext3 = get-aduser $extuser -Properties * | Select-object -ExpandProperty extensionattribute3
    if($ext3 -eq "DE0156")
    {
    #berechtigung auf BSS hostpool
    #Temp WVD Migration Add
    #Remove from BILLING
    $user = $extuser
    Write-Host -ForegroundColor DarkGreen "Adding User to WVD Group" $user
    Add-ADGroupMember -Identity $WVD_Grp_BSS -Members $user -Verbose 
    Add-ADGroupMember -Identity $temptsGrp -Members $user -Verbose
    Remove-ADGroupMember -Identity $tsgroup -Members $user 
    }
    else
    {
    #berechtigung consumer
    Write-Host -ForegroundColor DarkGreen "Adding User to WVD Group" $user
    Add-ADGroupMember -Identity $WVD_Grp_consumer -Members $user -Verbose 
    Add-ADGroupMember -Identity $temptsGrp -Members $user -Verbose
    Remove-ADGroupMember -Identity $tsgroup -Members $user -Confirm:$false 
    }
    #>
    }

    

   
    

    
    else
    {Write-Host -ForegroundColor Cyan $extuser.SamAccountName }
    
   # Add-Content $OutputFile ($extuser.SamAccountName + ";" + $extuser.UserPrincipalName)
#}

#}
#$conn.close()         