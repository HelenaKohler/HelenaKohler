$groups = gc "C:\Users\adm1kohlerh\Desktop\KohlerH\UsergrpsForUniqueCount.txt"
$users = @()
foreach ($row in $groups)
    {
                $users += Get-ADGroupMember -Identity $row | Select -ExpandProperty SamAccountName   
    }
$users | Out-File "C:\Users\adm1kohlerh\Desktop\KohlerH\UsersTSGrpsNotRecursive.txt"