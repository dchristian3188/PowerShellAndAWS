# Create a keypair

$keyName = 'SoCalPoshdemo'
New-EC2KeyPair -KeyName $keyName -Verbose -OutVariable keyPair

$keyPairPath = 'C:\aws\SoCalPoshdemo.pem'

$keyPair.KeyMaterial |
    Out-File -Path $keyPairPath

# Setup security groups

# Find our default VPC
$vpc = Get-EC2Vpc | 
    Where-Object {$PSitem.IsDefault -eq $true}

#Create the Group
$groupID = New-EC2SecurityGroup -VpcID $vpc.VpcID -GroupName "SoCalPoshDemo" -GroupDescription "Admin access for demo"

Get-EC2SecurityGroup -GroupId $groupID

# Adding Permission
$publicIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

$IpPermissionRDP = [Amazon.Ec2.Model.IpPermission]::new()
$IpPermissionRDP.IpProtocol = 'tcp'
$IpPermissionRDP.FromPort = 3389
$IpPermissionRDP.ToPort = 3389
$IpPermissionRDP.IpRanges.Add("$publicIP/32")

$IpPermissionWinRM = [Amazon.Ec2.Model.IpPermission]::new()
$IpPermissionWinRM.IpProtocol = 'tcp'
$IpPermissionWinRM.FromPort = 5985
$IpPermissionWinRM.ToPort = 5985
$IpPermissionWinRM.IpRanges.Add("$publicIP/32")

Grant-EC2SecurityGroupIngress -GroupId $groupID -IpPermission @($IpPermissionRDP, $IpPermissionWinRM)
Get-EC2SecurityGroup -GroupId $groupID | 
    Select-Object -ExpandProperty IpPermissions

Remove-EC2SecurityGroup -GroupId $groupID -Verbose -Force

# Looking for EC2 Images - 124,002 Images as of 8/1/21

Get-EC2Image | 
    Select -first 10

# Better Searching
Get-SSMLatestEC2Image -Path ami-windows-latest | 
    Sort Name


Get-SSMLatestEC2Image -ImageName *Windows*2019*English*Base* -Path ami-windows-latest


Get-SSMLatestEC2Image -ImageName 'Windows_Server-2019-English-Full-Base' -Path 'ami-windows-latest'
Get-SSMLatestEC2Image -ImageName 'Windows_Server-2019-English-Full-Base' -Path 'ami-windows-latest' -region us-east-2
Get-SSMLatestEC2Image -ImageName 'Windows_Server-2019-English-Full-Base' -Path 'ami-windows-latest' -region us-east-1


# Creating an EC2Instance

## Finding the right instance size
New-EC2Instance -InstanceType


# Passing UserData
$userData = @'
<powershell>
Get-NetFirewallProfile | 
    Set-NetFirewallProfile -Enabled False -Verbose
</powershell>
'@


# Launching an instance
Get-SSMLatestEC2Image -ImageName 'Windows_Server-2019-English-Full-Base' -Path 'ami-windows-latest' | 
    New-EC2Instance -InstanceType t2.large -SecurityGroupId $groupID -KeyName $keyName -UserData $userData -EncodeUserData -ov instance -Verbose

# So Many parameters
(Get-Command New-EC2Instance).Parameters.Count

# Create Multiple Instances
1..5 | % {
    Get-SSMLatestEC2Image -ImageName 'Windows_Server-2019-English-Full-Base' -Path 'ami-windows-latest' | 
        New-EC2Instance -InstanceType t2.large -SecurityGroupId $groupID -KeyName $keyName -UserData $userData -EncodeUserData -Verbose }


# Getting the password
$instance | 
    Select-Object -ExpandProperty Instances | 
    Get-EC2PasswordData -PemFile $keyPairPath


# A better credential function
. .\HelperFunctions\Get-EC2Credential.ps1

Get-EC2Instance -InstanceId $instance.instances.InstanceId | 
    Get-EC2Credential -PemFile $keyPairPath -OutVariable credential

# Connect over RDP
. .\HelperFunctions\Connect-EC2Mstsc.ps1

Get-EC2Instance -InstanceId $instance.instances.InstanceId | 
    Connect-EC2Mstsc -PemFile $keyPairPath

# Connecting Over PSsession
. .\HelperFunctions\New-EC2PsSession.ps1

$sessions =  Get-EC2Instance -Filter @{Name="instance-state-name";Values="running"}  | 
    New-EC2PSSession -PemFile $keyPairPath -Verbose


Invoke-Command -Session $sessions {
    HOSTNAME.EXE
}


Get-EC2Instance -Filter @{Name="instance-state-name";Values="running"}  | 
    Remove-EC2Instance -Verbose -Force