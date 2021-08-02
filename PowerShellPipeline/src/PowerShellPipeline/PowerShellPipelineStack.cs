using Amazon.CDK;
using Amazon.CDK.AWS.CodeCommit;
using Amazon.CDK.AWS.CodeBuild;
using Amazon.CDK.AWS.CodePipeline;


namespace PowerShellPipeline
{
    public class PowerShellPipelineStack : Stack
    {
        internal PowerShellPipelineStack(Construct scope, string id, IStackProps props = null) : base(scope, id, props)
        {
            var repo = new Repository(this,"PowerShellRepo",new RepositoryProps{
                RepositoryName = "PowerShell-Repository",
                Description = "Source Repo for PowerShell Lambda"
            });
        }
    }
}
