using module './config.psm1'
using module AWSPowerShell.NetCore

param
(
    [string] $configPath = 'config.json',
    [switch] $dryRun = $false
)

if ($dryRun)
{
    Write-Host 'RUNNING IN DRY-RUN MODE. NO ACTUAL CHANGES WILL BE DONE.'
}

$config = [Config] (Get-Content $configPath | ConvertFrom-JSON)

$base64Token = [System.Convert]::ToBase64String([char[]]$config.Token)
$headers = 
@{
    Authorization = 'Basic {0}' -f $base64Token
};

Set-Location -Path $config.BackupDirectory

$page = 1
$perPage = 30

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

do
{
    Write-Host "Getting page: $page"
    $response = Invoke-RestMethod -Headers $headers -Uri "https://api.github.com/user/repos?page=$page&per_page=$perPage"
    
    foreach ($repo in $response)
    {
        $repoName = $repo.name
        $repoPath = "$($config.BackupDirectory)/$repoName"

        Write-Host "Processing repo at path: $repoPath"

        if ($dryRun)
        {
            # Just to test SSH key. If it doesn't have access we should see permission errors in the output
            Write-Host "Fetching with dry run parameter"
            git fetch --dry-run
        }
        else
        {
            if ((Test-Path $repoPath) -eq 0)
            {
                # Repo doesn't exist, clone it
                Write-Host "Repo doesn't exist, clone it"
                git clone $repo.ssh_url
            }
            else 
            {
                # Repo exists
                Write-Host "Repo exists, update"
                
                # Change to repo directory to fetch updates
                Set-Location -Path $repoPath
    
                git fetch --all
                git reset --hard origin/master
    
                # Change back to root backup directory
                Set-Location -Path $config.BackupDirectory
            }
        }
    }
    
    $page = $page + 1
}
while ($response.Count -gt 0)

Write-Host "Backup completed"

# Send notifications
if ($config.Notification.Sns.Enabled)
{
    Write-Host "Publishing to SNS topic $($config.Notification.Sns.TopicArn)"

    if (-not $dryRun)
    {
        $result = @{}
        $result.MessageId = [guid]::NewGuid()
        $result.ResultCode = "OK"
        $result.Message = "Success"
        $result.Timestamp = [System.DateTime]::UtcNow
        
        $messageJson = "{ ""MessageId"": ""$([guid]::NewGuid())"", ""ApplicationId"": ""$applicationId"", ""ResultCode"": ""OK"", ""Message"": ""Success"", ""Timestamp"": ""$([System.DateTime]::UtcNow)"" }"
        
        Write-Host $messageJson
        Publish-SNSMessage  -TopicArn $config.Notification.Sns.TopicArn `
             -Message $messageJson `
             -Subject $config.Notification.Subject `
             -AccessKey $config.Notification.Sns.AccessKey `
             -SecretKey $config.Notification.Sns.secretKey `
             -Region $config.Notification.Sns.Region
    }
}

if ($config.Notification.Email.Enabled)
{
    Write-Host "Sending email to $($config.Notification.Email.ToEmailAddress)"

    if (-not $dryRun)
    {
        Send-MailMessage `
            -From $config.Notification.Email.FromEmailAddress `
            -To $config.Notification.Email.ToEmailAddress `
            -Subject $config.Notification.Subject `
            -Body $config.Notification.MessageBody `
            -SmtpServer $config.Notification.Email.SmtpHost `
            -UseSsl `
            -Port $config.Notification.Email.SmtpPort `
            -Credential $( `
                New-Object System.Management.Automation.PSCredential `
                    -argumentlist $config.Notification.Email.SmtpUsername, `
                    $(ConvertTo-SecureString -AsPlainText -String $config.Notification.Email.SmtpPassword -Force) `
                )
    }
}
