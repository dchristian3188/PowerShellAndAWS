# Get Buckets
Get-S3Bucket 

# New Bucket
New-S3Bucket -BucketName chradavi-s3-imagebucket-test -Verbose


# Delete All Objects in a bucket
Get-S3Object -BucketName chradavi-s3-imagebucket-test | 
    Remove-S3Object -Verbose -Force

# Upload Objects to a bucket
Get-Item -Path .\Pics\* | 
    ForEach-Object {
        $key = [io.path]::Combine("input",$PSItem.Name)
        Write-S3Object -BucketName chradavi-s3-imagebucket-test -File $PSItem.FullName  -Verbose -Key $key
    }
    