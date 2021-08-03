using Amazon.CDK;
using Amazon.CDK.AWS.CodeCommit;
using Amazon.CDK.AWS.CodeBuild;
using Amazon.CDK.AWS.CodePipeline;
using Amazon.CDK.AWS.CodePipeline.Actions;
using Amazon.CDK.AWS.IAM;
using System.Collections.Generic;

namespace PowerShellPipeline
{
    public class PowerShellPipelineStack : Stack
    {
        internal PowerShellPipelineStack(Construct scope, string id, IStackProps props = null) : base(scope, id, props)
        {
            // Create our CodeCommit Repository
            var repo = new Repository(this,"PowerShellRepo",new RepositoryProps{
                RepositoryName = "PowerShell-Repository",
                Description = "Source Repo for PowerShell Lambda"
            });

            // Create a role to be used by the lambda 
            var lambdaRole = new Role(this,"PowerShell-Lambda-ExecutionRole", new RoleProps{
                RoleName = "PowerShell-Lambda-ExecutionRole",
                AssumedBy =  new ServicePrincipal("lambda.amazonaws.com")
            });

            lambdaRole.AddManagedPolicy(ManagedPolicy.FromManagedPolicyArn(this,"AWSLambdaBasicExecutionRole","arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"));

            // Setup a build project 
            var build = new PipelineProject(this,"PowerShellBuild",new PipelineProjectProps{
                ProjectName = "PowerShell-CodeBuild",
                BuildSpec = BuildSpec.FromSourceFilename("buildspec.yaml"),
                Environment = new BuildEnvironment{
                    BuildImage = LinuxBuildImage.STANDARD_5_0
                }
            });

            // Setup Pipeline 
            var sourceOutput = new Artifact_();
            var pipeline = new Pipeline(this, "PowerShellPipeline", new PipelineProps{
                PipelineName = "PowerShell-Lambda-Pipeline"
            });

            var sourceAction = new CodeCommitSourceAction(new CodeCommitSourceActionProps{
                    ActionName = "PowerShell-Source",
                    Repository = repo,
                    Output = sourceOutput
                });


            var buildAction = new CodeBuildAction(new CodeBuildActionProps{
                ActionName = "PowerShellBuildAndDeploy",
                Project = build, 
                Input = sourceOutput,
            });

            build.Role.AddManagedPolicy(ManagedPolicy.FromManagedPolicyArn(this,"AmazonS3FullAccess","arn:aws:iam::aws:policy/AmazonS3FullAccess"));
            build.Role.AddManagedPolicy(ManagedPolicy.FromManagedPolicyArn(this,"AWSLambda_FullAccess","arn:aws:iam::aws:policy/AWSLambda_FullAccess"));

            pipeline.AddStage(new StageOptions{
                StageName = "Source"
            });
            pipeline.Stages[0].AddAction(sourceAction);

            pipeline.AddStage(new StageOptions{
                StageName = "BuildAndDeploy"
            });
            pipeline.Stages[1].AddAction(buildAction);

        }
    }
}
