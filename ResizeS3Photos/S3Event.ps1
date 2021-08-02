# PowerShell script file to be executed as a AWS Lambda function.
#
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWS.Tools.S3 module, add a "#Requires" statement
# indicating the module and version. If using an AWS.Tools.* module the AWS.Tools.Common module is also required.
#
# The following link contains documentation describing the structure of the S3 event object.
# https://docs.aws.amazon.com/AmazonS3/latest/dev/notification-content-structure.html

#Requires -Modules @{ModuleName='AWS.Tools.Common';ModuleVersion='4.1.14.0'}
#Requires -Modules @{ModuleName='AWS.Tools.S3';ModuleVersion='4.1.14.0'}
#Requires -Modules @{ModuleName='ImageSharp';ModuleVersion='0.0.1'}


# Uncomment to send the input event to CloudWatch Logs
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)

foreach ($record in $LambdaInput.Records) {
    $bucket = $record.s3.bucket.name
    $key = $record.s3.object.key

    Write-Host "Processing event for: bucket = $bucket, key = $key"

    $localPath = [io.path]::Combine("/tmp",$key)
    Write-Host "LocalPath is $localPath, starting copy from S3"
    Copy-S3Object -BucketName $bucket -Key $key -LocalFile $localPath -Verbose
    Set-DCImage -Path $localPath

    $localInfo = Get-Item -Path $localPath -Verbose
    $resizedImage = [io.path]::Combine("/tmp/input","$($localInfo.BaseName)_resized$($localInfo.Extension)")
    Write-S3Object -BucketName $bucket -File $resizedImage -Key "output\$(Split-Path -Path $resizedImage -Leaf)" -Verbose

    Remove-Item $localPath, $resizedImage -Verbose
}

