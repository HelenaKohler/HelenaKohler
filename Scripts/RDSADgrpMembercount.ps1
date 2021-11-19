cls

$pathCount = "C:\Users\adm1kohlerh\Desktop\KohlerH\UsergrpsOutput1.txt"

Clear-Content $pathCount


$ADgrps = get-adobject -Filter 'ObjectClass -eq "group"' -SearchBase 'OU=Terminal_Server_Groups,OU=Groups,OU=DE0156,OU=Consumer,DC=Global,DC=BDFGroup,DC=net' | Select-object -ExpandProperty ObjectGUID

#$ADgrps > C:\Users\adm1kohlerh\Desktop\KohlerH\Usergrps.csv

#$ADgrps = Get-Content C:\Users\adm1kohlerh\Desktop\KohlerH\Usergrps.csv

foreach ($ADgrp in $ADgrps)
{

$countUser = ""
$countUser = ((Get-ADGroup -Identity $ADgrp -Properties Members).Members).Count
$Adgrpname = (Get-ADGroup -Identity $ADgrp -Properties Name).Name


"$ADgrp;$ADgrpname;$countUser;" | Out-File $pathCount -Append

}