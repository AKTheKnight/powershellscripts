﻿# Install DHCP and setup

Install-WindowsFeature DHCP -IncludeManagementTools

netsh dhcp add securitygroups
Restart-Service dhcpserver

Add-DhcpServerInDC -DnsName DHCP1.corp.contoso.com -IPAddress 10.0.0.3
Get-DhcpServerInDC

Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

Set-DhcpServerv4DnsSetting -ComputerName "DHCP1.corp.contoso.com" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True

$Credential = Get-Credential
Set-DhcpServerDnsCredential -Credential $Credential -ComputerName "DHCP1.corp.contoso.com"

rem At prompt, supply credential in form DOMAIN\user, password

rem Configure scope Corpnet
Add-DhcpServerv4Scope -name "Corpnet" -StartRange 10.0.0.1 -EndRange 10.0.0.254 -SubnetMask 255.255.255.0 -State Active
Add-DhcpServerv4ExclusionRange -ScopeID 10.0.0.0 -StartRange 10.0.0.1 -EndRange 10.0.0.15
Set-DhcpServerv4OptionValue -OptionID 3 -Value 10.0.0.1 -ScopeID 10.0.0.0 -ComputerName DHCP1.corp.contoso.com
Set-DhcpServerv4OptionValue -DnsDomain corp.contoso.com -DnsServer 10.0.0.2