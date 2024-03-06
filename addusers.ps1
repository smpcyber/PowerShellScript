$USER_PASSWORDS = "P@ssw0rd"
$USER_NAMELIST = Get-Content ./names.txt

$password = ConvertTo-SecureString $USER_PASSWORDS -AsPlainText -Force
New-ADOrganizationalUnit -Name Employees -ProtectedFromAccidentalDeletion $false

foreach ($n in $USER_NAMELIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()

    Write-Host "User created: $($username)"
    New-ADUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "OU=Employees,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true
}