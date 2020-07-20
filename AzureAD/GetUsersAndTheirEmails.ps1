#Install-Module -Name AzureAD
#Connect-AzureAD


$users = Get-AzureADUser -All $true | 
    Select DisplayName, UserPrincipalName, ProxyAddresses

$usersAndEmails = @()

Foreach ($user in $users) {
    $ProxyAddress = $user | Select -ExpandProperty ProxyAddresses

    if ($ProxyAddress) {
        $ProxyAddresses = $ProxyAddress.Split(",") |
            Where {($_ -notlike '*onmicrosoft.com')} |
            ForEach-Object {
                $_ = $_.Replace("smtp:", "")
                $_ = $_.Replace("SMTP:", "")
                $_
            }
    }
    

    $values = [ordered]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            ProxyAddresses = $ProxyAddresses -join ', '
        }

    $usersAndEmails += ,(New-Object psobject -Property $values)
}

$usersAndEmails | Export-Csv -Path "c:\temp\UsersAndEmails.csv" -NoTypeInformation