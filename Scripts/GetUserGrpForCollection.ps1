$Collections = Get-Content "C:\Users\adm1kohlerh\Desktop\KohlerH\TSCollNoMigration.txt"

 foreach ($Coll in $Collections)
 {
     $UserGroups += Get-RDSessionCollectionConfiguration -UserGroup -ConnectionBroker HAMS1799.global.bdfgroup.net -CollectionName $Coll | Select-Object -ExpandProperty UserGroup
  }
 
$UserGroups | Out-File "C:\Users\adm1kohlerh\Desktop\KohlerH\TSCollNoMigrationGrps.txt"