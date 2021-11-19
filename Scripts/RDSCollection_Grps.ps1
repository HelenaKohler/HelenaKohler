$cols = Get-RDSessionCollection -ConnectionBroker HAMS1799.global.bdfgroup.net

 foreach ($c in $cols) 

 {

 

 $c = $c.CollectionName

 Get-RDSessionCollectionConfiguration -UserGroup -ConnectionBroker HAMS1799.global.bdfgroup.net -CollectionName $c | fl

 }