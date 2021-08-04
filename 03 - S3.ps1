# Get Buckets
Get-S3Bucket 



# New Bucket
$bucketName = "chradavi-s3-imagebucket-test"
New-S3Bucket -BucketName $bucketName -Verbose

# Check Encryption
Get-S3Bucket -BucketName $bucketName | 
    Get-S3BucketEncryption

# Setup Encryption
$Encryptionconfig = @{
    ServerSideEncryptionByDefault = 
        @{ServerSideEncryptionAlgorithm = "AES256"
    }}

Set-S3BucketEncryption -BucketName $bucketName -ServerSideEncryptionConfiguration_ServerSideEncryptionRule $Encryptionconfig


Get-S3Bucket -BucketName $bucketName | 
    Get-S3BucketEncryption


# Delete All Objects in a bucket
Get-S3Object -BucketName $bucketName | 
    Remove-S3Object -Verbose -Force

# Upload Objects to a bucket
Get-Item -Path C:\github\PowerShellAndAWS\Pics\* | 
    ForEach-Object {
        $key = [io.path]::Combine("input",$PSItem.Name)
        Write-S3Object -BucketName $bucketName -File $PSItem.FullName  -Verbose -Key $key
    }

# Delete a bucket
Get-S3Bucket $bucketName | 
    Remove-S3Bucket -Verbose -Force 