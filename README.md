<h1>PowerShell Script</h1>

<h2>Description</h2>

This PowerShell script was written to create a new organizational unit within Active Directory and create and add new users into Active Directory pulled from names in a name list text file.  In a folder on my Windows Server 2019 domain controller, I have a .txt file with a list of first and last names of users to be added to Active Directory, as well as the script itself to automate the task of creating a new organizational unit and creating the users themselves.
<br />
<br />
A rundown of the script and steps to run the script via PowerShell ISE to follow.
<br />
<br />
<p align="center">


```
$USER_PASSWORDS = "P@ssw0rd"
$USER_NAMELIST = Get-Content ./names.txt

## 01 Set a variable, $USER_PASSWORDS, and assign the string "P@ssw0rd" to assign a default password to
      newly created users
## 02 Set a variable, $USER_NAMELIST, and assign the first and last names pulled from the "names.txt"
      file

$password = ConvertTo-SecureString $USER_PASSWORDS -AsPlainText -Force
New-ADOrganizationalUnit -Name Employees -ProtectedFromAccidentalDeletion $false

## 03 Set a variable, $password, and converts the plaintext $USER_PASSWORDS into a secure string in
      PowerShell
## 04 Create a new Organizational Unit in Active Directory, called "Employees", and disable protection
      from accidental deletion

foreach ($n in $USER_NAMELIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()

## 05 A for loop is initiated to iterate through the names stored in the variable $USER_NAMELIST
## 06 A variable, $first, stores the 0th indexed name and converts it to a lowercase string
## 07 A variable, $last, stores the 1st indexed name and converts it to a lowercase string
## 08 A variable, $username, takes the first letter of the $first name, concatenates the $last name,
   and converts $username to a lowercase string

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

## 09 Write-Host prints a string "User created:" and prints $username to the console
## 10 New-ADUser creates a new Active Directory User using parameters to set a default $password,
   fills in lowercase names as per the syntax of the script, sets the $password to never expire,
   points out the path in which the Active Directory user is created, and enables the user

```

</p>

<p align="center">
<b>[Running the Script from PowerShell ISE]</b>
<br />
<br />
<img src="https://i.imgur.com/a8VjTtA.png" width="50%" height="50%">
<br />
<sub>From the Start menu, search PowerShell ISE
<br />
Right-click "PowerShell ISE"
<br />
Select "Run as Administrator"</sub>
<br />
<br />
<img src="https://i.imgur.com/WvEg0R1.png" width="50%" height="50%">
<br />
<sub>Click "Open Script" on the toolbar at top of PowerShell ISE</sub>
<br />
<br />
<img src="https://i.imgur.com/yVjyhD1.png" width="50%" height="50%">
<br />
<sub>Search for the directory in which your PowerShell script is stored
<br />
Select "addusers.ps1"
<br />
Click "Open"</sub>
<br />
<br />
<img src="https://i.imgur.com/yD5fPYT.png" width="50%" height="50%">
<br />
<sub>Review script</sub>
<br />
<br />
<img src="https://i.imgur.com/eSgdTcx.png" width="50%" height="50%">
<br />
<sub>In order to run the script, change directory to where the script is stored via console</sub>
<br />
<br />
<img src="https://i.imgur.com/qXC8Oxp.png" width="50%" height="50%">
<br />
<sub>Click "Run Script" on toolbar at top of PowerShell ISE
<br />
Alternatively, press F5 to run script</sub>
<br />
<br />
<img src="https://i.imgur.com/y7lT792.png" width="50%" height="50%">
<br />
<sub>Verify script has run successfully
<br />
** Note: ensure there are no additional spaces or lines after the very last name in the "names.txt" file,
<br />
or the script will encounter null-valued expression errors</sub>
<br />
<br />
<img src="https://i.imgur.com/K3CvKh3.png" width="50%" height="50%">
<br />
<sub>Verifying script has worked by accessing Active Directory Users and Computers
<br />
New organizational unit, "Employees," and users added from "names.txt" file</sub>
<br />
<br />

  
</p>
