Function Get-CWLLastLogEvent
{
    Param(
        [String]
        $LogGroupNamePrefix
    )

    $logStreams = Get-CWLLogGroup -LogGroupNamePrefix $LogGroupNamePrefix | 
        Get-CWLLogStream | 
        Sort-Object -desc -Property CreationTime | 
        Select-Object -First 1
    
    Get-CWLLogEvent -LogGroupName $LogGroupNamePrefix -LogStreamName $logStreams.LogStreamName | 
        Select-Object -ExpandProperty Events
}