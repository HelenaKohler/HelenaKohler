$ADgrp = "HAM-GG-BSS_com.bdf.0000srm_s_producer_appl_bid_ext_RDP_QUAL"
Get-ADGroupMember $ADgrp | ForEach-Object {Remove-ADGroupMember $ADgrp $_ -Confirm:$false}