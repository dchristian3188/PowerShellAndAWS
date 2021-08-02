Set-Location C:\github\PowerShellAndAWS

# Install the Module
Install-Module -Name AWSLambdaPSCore -Verbose -Force

# Listing Templates
Get-AWSPowerShellLambdaTemplate

# Creating A Lambda
New-AWSPowerShellLambda -Template basic -Directory 'C:\github\PowerShellAndAWS\BasicLambda'

Publish-AWSPowerShellLambda -ScriptPath 'C:\github\PowerShellAndAWS\BasicLambda\basic.ps1' -Name 'BasicLambda' -Verbose

Invoke-LMFunction -FunctionName 'BasicLambda' -LogType Tail -OutVariable BasicLmabda 

[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($BasicLmabda.LogResult))



# More Advanced 
New-AWSPowerShellLambda -Template S3Event -ProjectName ResizeS3Photos -WithProject -Verbose

Code .\ResizeS3Photos


Publish-AWSPowerShellLambda -ProjectDirectory .\ResizeS3Photos -Verbose -Name ResizeS3Photos