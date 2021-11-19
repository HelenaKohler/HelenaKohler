$users = Get-ADGroupMember -Identity 'tesa-DACH-ALL'  -recursive | Select -ExpandProperty samaccountname > C:\temp\tesa-dach-all.csv

$InputFile = "C:\temp\tesa-dach-all.csv"
$InputList = Get-Content $InputFile

gc = 