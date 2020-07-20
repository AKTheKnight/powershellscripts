# Install Active directory and setup AD with either a new or an existing domain

# Admin password
$password = "Password123!"

# Domain info
$domain = "testad.aktheknight.co.uk"
$net_bios = "testad"

# Are you joining this to an existing domain (DNS value must be set manually to primary domain controller if existin_domain is True!)
$existing_domain = $false

#############################################

# Meet the DC pre-reqs for admin user
net user Administrator /passwordreq:yes
net user Administrator $password

# Install the AD role
install-windowsfeature AD-Domain-Services -IncludeManagementTools

# Promote to DC
Import-Module ADDSDeployment

if ($existing_domain){
    Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName $domain -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SiteName 'Default-First-Site-Name' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString $password -AsPlainText -Force)
} else {
    Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath “C:\Windows\NTDS” -DomainName $domain -DomainNetbiosName $net_bios -InstallDns:$true -LogPath “C:\Windows\NTDS” -NoRebootOnCompletion:$false -SysvolPath “C:\Windows\SYSVOL” -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString $password -AsPlainText -Force)
}