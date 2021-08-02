# Finding the PowerShell Modules
Find-Module -Name AWS.Tools*

# Install Common Tools Module
Install-Module -Name AWS.Tools.Common -Verbose -Force

# Whats in Common Package
Get-Command -Module AWS.Tools.Common

# Installer Module
Install-Module -Name AWS.Tools.Installer -Verbose -Force

# Whats in Installer Package
Get-Command -Module AWS.Tools.Installer

# Installing multiple modules
Install-AWSToolsModule -Verbose -Name Ec2, S3, Lambda, SimpleSystemsManagement, Cloudwatch, CloudWatchLogs -Force

# Double Check our modules
Get-Module -ListAvailable AWS.Tools*

# Always Update your modules
Update-AWSToolsModule -Verbose -Force

# Setting up your session
Set-AWSCredential -AccessKey "" -SecretKey "" -Verbose

# Presisting Credentials
$awsCreds = @{
    AccessKey = ''
    SecretKey = ''
    StoreAs   = 'default'
    Verbose   =  $true
}

Set-AWSCredential @awsCreds

# Working With the Default Region
Get-AWSRegion


Set-DefaultAWSRegion -Region us-west-2 -Verbose
Get-DefaultAWSRegion -Verbose