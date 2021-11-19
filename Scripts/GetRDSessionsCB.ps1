$cb = Get-RDConnectionBrokerHighAvailability -ConnectionBroker HAMS1798.global.bdfgroup.net | Select -ExpandProperty ActiveManagementServer
$datetime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")

$rdlog = @()
$rdusersessions = @()

$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=hamq-virtualdesktop-prod,3737;Initial Catalog=VirtualDesktop;Integrated Security=SSPI;"
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn


$rdusersessions = Get-RDUserSession -ConnectionBroker $cb | Select-Object -Property UserName, CollectionName


foreach ($rduser in $rdusersessions)
{
    $rduserSAN = ($rduser).Username
    $rduserColl = ($rduser).CollectionName
    $rdlog += "$rduserSAN;$rduserColl;$datetime;" 

    
    $query =  "Insert INTO [VirtualDesktop].[dbo].[terminalservices_activeusers] ([Date], [Username], [Collection]) VALUES ( '$datetime', '$rduserSAN', '$RDuserColl');"
        $cmd.commandtext = $query
        $cmd.ExecuteNonQuery()

        
      }

Write-Host $rdlog
$rdlog | Out-File C:\Users\adm1kohlerh\Desktop\KohlerH\RDUsers.csv -Append

$conn.close()