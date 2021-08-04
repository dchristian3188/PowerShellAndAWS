# CDK Intro

# Cloning a new Repo

git clone https://git-codecommit.us-west-2.amazonaws.com/v1/repos/PowerShell-Repository

# Generating the lambda package

Set-Location -Path C:\github\PowerShell-Repository

New-AWSPowerShellLambda -Template basic -Verbose
Copy-Item -Path C:\github\PowerShellAndAws\LambdaTemplateExample\buildspec.yaml -Destination . -Verbose
Code C:\github\PowerShell-Repository

# Check In Our Code, Review the pipeline


# Invoke Our Function
Invoke-LMFunction -FunctionName 'PowerShellCICD-Sample' -LogType Tail  
Get-CWLLastLogEvent -LogGroupNamePrefix '/aws/lambda/PowerShellCICD-Sample'


## Make a change and watch the build

While($true)
{
    Start-Sleep -Seconds 5
    Invoke-LMFunction -FunctionName 'PowerShellCICD-Sample' -LogType Tail  -Verbose
    Get-CWLLastLogEvent -LogGroupNamePrefix '/aws/lambda/PowerShellCICD-Sample' 
}

