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