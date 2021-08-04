# Get the log group
Get-CWLLogGroup -LogGroupNamePrefix '/aws/lambda/ResizeS3Photos' | 
    Select-Object *

# Find the log streams
Get-CWLLogGroup -LogGroupNamePrefix '/aws/lambda/ResizeS3Photos' | 
    Get-CWLLogStream | 
    Sort-Object -Descending CreationTime

# Looking at the events
Get-CWLLogEvent -LogGroupName '/aws/lambda/ResizeS3Photos' -LogStreamName '2021/08/03/[$LATEST]348c1e96f50748299ffc361ca8ffbeb4'

Get-CWLLogEvent -LogGroupName '/aws/lambda/ResizeS3Photos' -LogStreamName '2021/08/03/[$LATEST]348c1e96f50748299ffc361ca8ffbeb4' | 
    Select-Object -ExpandProperty Events

# A better log function
. .\helperFunctions\Get-CWLLastLogEvent.ps1

Get-CWLLastLogEvent -LogGroupNamePrefix '/aws/lambda/ResizeS3Photos'
