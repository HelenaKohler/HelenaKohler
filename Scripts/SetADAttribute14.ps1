$Attribute14 = "adminaccountazure"
$users = gc "C:\Temp\OMP.csv"

foreach ($user in $users)
    {
        Set-ADUser -Identity $user -replace @{"extensionAttribute14" = $Attribute14} 
        $user

       }