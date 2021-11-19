$src = "C:\temp\test"
$dest = "C:\temp\test\previous"

get-childitem -Path $src  | where-object {$_.LastWriteTime -lt (get-date).AddDays(-1)} | move-item -destination $dest
