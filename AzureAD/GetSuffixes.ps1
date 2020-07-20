param (
    [bool] $UPNOnly = $true,
    [bool] $SuffixOnly = $false
)

if ($UPNOnly){

Get-AzureADUser |
    select -Property UserPrincipalName | ForEach-Object {
        $pos = $_.UserPrincipalName.IndexOf("@")
        $_ = $_.UserPrincipalName.SubString($pos+1)
        $_
    } |
    Group-Object |
    Select-Object @{Name="Suffix";Expression={$_.Name}}, Count |
    ForEach-Object {
        if ($SuffixOnly) {
            $_ | Select -Property Suffix
        }
        else {
            $_
        }
    }

}
else {

$ProxyAddress = Get-AzureADUser |
    select -ExpandProperty ProxyAddresses

$ProxyAddress.Split(",") |
    ForEach-Object {
        $pos = $_.IndexOf("@")
        $_ = $_.SubString($pos+1)
        $_
    } |
    Group-Object |
    Select-Object @{Name="Suffix";Expression={$_.Name}}, Count |
    ForEach-Object {
        if ($SuffixOnly) {
            $_ | Select -Property Suffix
        }
        else {
            $_
        }
    }

}

    