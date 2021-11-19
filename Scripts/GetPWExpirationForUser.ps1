
Import-Module MSOnline
Connect-MsolService

Get-MsolUser -userprincipalname monica.barreiro.external@beiersdorf.com | select DisplayName, LastPasswordChangeTimeStamp,@{Name=”PasswordAge”;Expression={(Get-Date)-$_.LastPasswordChangeTimeStamp}}
