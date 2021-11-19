$ADgrp = "BSS_TS_ExternalPublished_UsergroupsForSessionhosts"
$GWuserGrps = Get-ADGroupMember -Identity $ADgrp | Select -ExpandProperty SamAccountName



foreach ($GWUserGrp in $GWuserGrps)

    { 

        $GWusers =Get-ADGroupMember -Identity $GWUserGrp -Recursive | Select-Object -ExpandProperty SamAccountName

    }

        foreach ($user in $GWusers)
            {

            $DialInPrp = Get-ADUser $user -Properties * | Select-Object -ExpandProperty msnpallowdialin

            if($DialInPrp -eq $false)
                {
       
                        set-aduser $user -clear msnpallowdialin    
    
                }

            }
