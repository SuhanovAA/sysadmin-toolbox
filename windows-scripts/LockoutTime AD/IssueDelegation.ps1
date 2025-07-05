$OU = "OU=FOLDER,DC=DOMAIN,DC=DOMAIN"
$GroupName = "DOMAIN\GROUP"
$OUObject = [ADSI]"LDAP://$OU"
$acl = $OUObject.ObjectSecurity

$NTAccount = New-Object System.Security.Principal.NTAccount($GroupName)
$SID = $NTAccount.Translate([System.Security.Principal.SecurityIdentifier])

$LockoutTimeGuid = [Guid]"28630ebf-41d5-11d1-a9c1-0000f80367c1"
$UserObjectGuid = [Guid]"bf967aba-0de6-11d0-a285-00aa003049e2"

$Descendents = [System.DirectoryServices.ActiveDirectorySecurityInheritance]::Descendents
$Allow = [System.Security.AccessControl.AccessControlType]::Allow

# Удалим старые записи для этой группы и lockoutTime (если были)
$acl.Access | Where-Object {
    $_.IdentityReference -eq $GroupName -and
    $_.ObjectType -eq $LockoutTimeGuid
} | ForEach-Object { $acl.RemoveAccessRule($_) }

# Добавим новые ACE
$ReadACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $SID, "ReadProperty", $Allow, $LockoutTimeGuid, $Descendents, $UserObjectGuid
)
$WriteACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $SID, "WriteProperty", $Allow, $LockoutTimeGuid, $Descendents, $UserObjectGuid
)

$acl.AddAccessRule($ReadACE)
$acl.AddAccessRule($WriteACE)

# Применяем ACL
$OUObject.ObjectSecurity = $acl
$OUObject.CommitChanges()

Write-Host "Права чтения и записи lockoutTime выданы повторно. Проверяем..."

# Проверка
$OUObject.RefreshCache()
$OUObject.ObjectSecurity.Access | Where-Object {
    $_.IdentityReference -eq $GroupName -and
    $_.ObjectType -eq $LockoutTimeGuid
} | Format-Table IdentityReference, ActiveDirectoryRights, InheritanceType
