# Поиск заблокированных пользователей в лесу AD с выводом логина, имени/фамилии, времени блокировки

Search-ADAccount -LockedOut |
Get-ADUser -Properties lockoutTime, DisplayName |
Select @{Name="sAMAccountName";Expression={$_.sAMAccountName.ToUpper()}},
       @{Name="DisplayName";Expression={$_.DisplayName}},
       @{Name="LockoutTime";Expression={([datetime]::FromFileTime($_.lockoutTime).ToLocalTime())}} |
Sort LockoutTime -Descending