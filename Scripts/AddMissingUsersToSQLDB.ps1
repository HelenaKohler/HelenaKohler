$users = Import-Csv -Path "C:\Temp\MissingWVDWave3SQL.csv" -Delimiter ';'

$ADGrpTS = "HAM-GG-BSS_TS_HAMS0687_BILLING"
$ObjClass = "user"
$Mig_state = "in Migration"
$Mig_wave = "Wave 3"

$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=hamq-virtualdesktop-prod,3737;Initial Catalog=VirtualDesktop;Integrated Security=SSPI;"
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn

foreach($user in $users)
    {
        $usersan = $user.SamAccountName
        $username = $user.DisplayName
        $usersan
        $username
        
        $query =  "Insert INTO [VirtualDesktop].[dbo].[terminalservices_ADGrpMembers] ([ADGroupName], [SamAccountName], [DisplayName], [ObjectClass], [Migration], [MigrationWave]) VALUES ( '$ADGrpTS', '$usersan', '$username', '$objclass', '$Mig_state', '$Mig_wave');"
        $cmd.commandtext = $query
        $cmd.ExecuteNonQuery()
        
    }

$conn.close()  