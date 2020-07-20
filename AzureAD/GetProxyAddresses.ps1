param (
    [Parameter(Mandatory = $true)]
    [string] $ObjectId,
    [bool] $SuffixOnly = $false
)

$ProxyAddress = Get-AzureADUser -ObjectId $ObjectId |
    select -ExpandProperty ProxyAddresses

"ProxyAddresses"
"--------------"

$ProxyAddresses = $ProxyAddress.Split(",") |
    ForEach-Object {
        $_ = $_.Replace("smtp:", "")
        $_ = $_.Replace("SMTP:", "")
        $_
    }

if ($SuffixOnly) {

$ProxyAddresses = $ProxyAddresses |
    ForEach-Object {
        if ($SuffixOnly) {
            $pos = $_.IndexOf("@")
            $_ = $_.SubString($pos+1)
            $_
        }
        else {
            $_
        }
    } |
    Group-Object |
    Select-Object @{Name="Suffix";Expression={$_.Name}}, Count
}


$ProxyAddresses | Format-Table
