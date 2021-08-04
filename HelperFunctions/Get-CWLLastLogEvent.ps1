Function Get-CWLLastLogEvent
{
    Param(
        [String]
        $LogGroupNamePrefix
    )

    $logStream = Get-CWLLogGroup -LogGroupNamePrefix $LogGroupNamePrefix | 
        Get-CWLLogStream | 
        Sort-Object -desc -Property CreationTime | 
        Select-Object -First 1
    
    $events = Get-CWLLogEvent -LogGroupName $LogGroupNamePrefix -LogStreamName $logStream.LogStreamName
    $events.Events
}

