# Get the log group
Get-CWLLogGroup -LogGroupNamePrefix '/aws/lambda/ResizeS3Photos' | 
    Select-Object *

# Find the log streams
Get-CWLLogGroup -LogGroupNamePrefix '/aws/lambda/ResizeS3Photos' | 
    Get-CWLLogStream

# Looking at the events
Get-CWLLogEvent -LogGroupName '/aws/lambda/ResizeS3Photos' -LogStreamName '2021/08/02/[$LATEST]effe97aece154f6a866db8d2b0621e92'

Get-CWLLogEvent -LogGroupName '/aws/lambda/ResizeS3Photos' -LogStreamName '2021/08/02/[$LATEST]effe97aece154f6a866db8d2b0621e92' | 
    Select-Object -ExpandProperty Events

# A better log function
. .\helperFunctions\Get-CWLLastLogEvent.ps1

Get-CWLLastLogEvent -LogGroupNamePrefix '/aws/lambda/ResizeS3Photos'
