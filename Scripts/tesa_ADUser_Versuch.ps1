$users = @{}
$users = gc "C:\Users\adm1kohlerh\OneDrive - BDF Group\Desktop\tesa.csv"
$OutputFile = "C:\Users\adm1kohlerh\OneDrive - BDF Group\Desktop\tesa_result.txt"

foreach ($user in $users)
    {
        #Get-ADUser -Identity $user -Properties Department,extensionattribute3
        $usersan = Get-ADUser -Identity $user | Select-Object SamAccountName
        $userDN = Get-ADUser -Identity $user | Select-Object DistinguishedName
        $userDept = Get-ADUser -Identity $user -Properties Department | Select-Object Department
        $userCC = Get-ADUser -Identity $user -Properties extensionattribute3 | Select-Object extensionattribute3

        Write-Host $usersan, $userDN, $userDept, $userCC 
        #$usersan = Add-Content $OutputFile
       }
      # | Out-File "C:\Users\adm1kohlerh\OneDrive - BDF Group\Desktop\tesa_result.txt"