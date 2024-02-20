# EC2 AutoStop Solution

This repository contains the Terraform configuration for an EC2 AutoStop solution. The solution automatically stops EC2 instances when they are not in use, based on CPU utilization metrics.

## Prerequisites

- An AWS account with the necessary permissions to create and manage AWS resources.
- Terraform installed on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).

## Deployment Steps

1. **Clone the Repository**

   Clone this repository to your local machine:

   `git clone https://github.com/yourusername/ec2-autostop.git cd ec2-autostop`


2. **Set Up AWS Credentials**

   Configure your AWS credentials. You can do this by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables, or by using the AWS CLI's `aws configure` command.


3. **Initialize Terraform**

   Initialize the Terraform working directory:

   `terraform init`


   This command downloads the necessary provider plugins.

4. **Configure Variables**

   Set the required variables in the `variables.tf` file. The required variables are:

   - `instance_id`: The ID of the EC2 instance to monitor.
   - `cpu_utilization_period`: The period in seconds over which the specified statistic is applied.
   - `cpu_utilization_threshold`: The value against which the specified statistic is compared.
   - `cpu_utilization_evaluation_periods`: The number of periods over which data is compared to the specified threshold.

   Example of setting variables through the command line:

5. **Deploy the Solution**

   Apply the Terraform configuration to create the resources:

   `terraform apply`

   Review the changes and type `yes` when prompted to confirm the deployment.

6. **Verify the Deployment**

   After the deployment is complete, verify that the resources have been created in the AWS Management Console.

7. **Deploy while overriding metrics**

   To override the variables defined in `terraform.tfvars`, specify them as follows:

   `terraform apply -var 'instance_id=i-1234567890abcdef0' -var 'cpu_utilization_period=500' -var 'cpu_utilization_threshold=0.4' -var 'cpu_utilization_evaluation_periods=5'`


## Cleaning Up

To remove the resources created by Terraform, run:

`terraform destroy`


Review the changes and type `yes` when prompted to confirm the destruction of the resources.