param (
    [string] $UPNSuffix,
    [bool] $RemoveSuffix = $false
)

Get-AzureADUser |
    select -Property UserPrincipalName |
    Where-Object {$_.UserPrincipalName -Like "*$UPNSuffix"} |
    ForEach-Object {
        if ($RemoveSuffix) {
            $pos = $_.UserPrincipalName.IndexOf("@")
            $_.UserPrincipalName = $_.UserPrincipalName.SubString(0, $pos)
            $_
        }
        else {
            $_
        }
    }