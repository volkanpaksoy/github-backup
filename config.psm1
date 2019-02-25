class Config
{
    [string] $Token
    [string] $BackupDirectory

    [Notification] $Notification
}

class Notification
{
    [string] $Subject
    [string] $MessageBody

    [Sns] $Sns
    [Email] $Email
}

class Sns
{
    [bool] $Enabled    
    [string] $TopicArn
    [string] $Region 
    [string] $AccessKey
    [string] $SecretKey
}

class Email
{
    [bool] $Enabled
    [string] $FromEmailAddress
    [string] $ToEmailAddress
    [string] $SmtpHost
    [string] $SmtpUsername
    [string] $SmtpPassword 
    [string] $SmtpPort
}
