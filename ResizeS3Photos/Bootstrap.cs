using Amazon.Lambda.PowerShellHost;

namespace ResizeS3Photos
{
    public class Bootstrap : PowerShellFunctionHost
    {
        public Bootstrap() : base("S3Event.ps1")
        {
        }
    }
}
