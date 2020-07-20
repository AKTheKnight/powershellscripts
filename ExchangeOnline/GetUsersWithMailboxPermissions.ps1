# Get users with permissions to another mailbox where the user is in the form *@*
$mailboxes = Get-Mailbox -resultsize unlimited
$mailboxes | 
    Get-MailboxPermission | 
    Select Identity, User, Deny, AccessRights, IsInherited | 
    Where {($_.user -like '*@*')} |
    ForEach-Object {
        $user = Get-User -Identity $_.user

        $values = [ordered]@{
            Identity = $_.identity
            DisplayName = $user.DisplayName
            User = $_.user
            Deny = $_.Deny
            AccessRights = $_.AccessRights
            IsInherited = $_.IsInherited
        }

        New-Object psobject -Property $values
        #$_ | Add-Member -MemberType NoteProperty -Name DisplayName -Value $user.DisplayName
        #Select $_.identity, $user.DisplayName, $_.User, $_.Deny, $_.AccessRights, $_.IsInherited 
    } |
    Export-Csv -Path "c:\temp\NonOwnerPermissions.csv" -NoTypeInformation

    #https://www.netwrix.com/how_to_get_exchange_online_mailbox_permissions_report.html