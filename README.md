# EC2 AutoStop Solution

This repository contains the Terraform configuration for an EC2 AutoStop solution. The solution automatically stops EC2 instances when they are not in use, using intelligent multi-metric monitoring including CPU utilization, network activity, and packet counts.

## Prerequisites

- An AWS account with the necessary permissions to create and manage AWS resources.
- Terraform installed on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).

## Deployment Steps

1. **Clone the Repository**

   Clone this repository to your local machine:

   `git clone https://github.com/itoyjakra/ec2_autostop.git`


3. **Set Up AWS Credentials**

   Configure your AWS credentials. You can do this by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables, or by using the AWS CLI's `aws configure` command.


4. **Initialize Terraform**

   Initialize the Terraform working directory:

   `terraform init`


   This command downloads the necessary provider plugins.

5. **Configure Variables**

   Set the required variables in the `terraform.tfvars` file. The available variables are:

   - `instance_id`: The ID of the EC2 instance to monitor.
   - `cpu_utilization_period`: The period in seconds over which the specified statistic is applied (default: 300 seconds).
   - `cpu_utilization_threshold`: CPU threshold as decimal (e.g., 0.1 = 10%).
   - `cpu_utilization_evaluation_periods`: The number of periods over which data is compared to the specified threshold.
   - `network_in_threshold`: NetworkIn threshold in bytes per period (default: 1000 bytes).
   - `network_packets_threshold`: NetworkPacketsIn threshold per period (default: 15 packets).

   Example of setting variables through the command line:

6. **Deploy the Solution**

   Apply the Terraform configuration to create the resources:

   `terraform apply`

   Review the changes and type `yes` when prompted to confirm the deployment.

7. **Verify the Deployment**

   After the deployment is complete, verify that the resources have been created in the AWS Management Console.

8. **Deploy with custom variables**

   To override the variables defined in `terraform.tfvars`, specify them as follows:

   `terraform apply -var 'instance_id=i-1234567890abcdef0' -var 'cpu_utilization_period=500' -var 'cpu_utilization_threshold=0.4' -var 'cpu_utilization_evaluation_periods=5' -var 'network_in_threshold=2000' -var 'network_packets_threshold=30'`

## How It Works

The solution uses a composite alarm that monitors multiple metrics simultaneously:

- **CPU Utilization**: Monitors average CPU usage over 5-minute periods
- **Network Activity**: Tracks NetworkIn bytes to detect active connections (e.g., SSH sessions)  
- **Network Packets**: Monitors NetworkPacketsIn to catch low-bandwidth activity like SSH keepalives

The EC2 instance is only stopped when **ALL** metrics show sustained low activity for the configured evaluation periods (default: 3 periods of 5 minutes = 15 minutes total). This intelligent approach prevents false stops during research/reading sessions while ensuring truly abandoned instances are stopped.


## Cleaning Up

To remove the resources created by Terraform, run:

`terraform destroy`


Review the changes and type `yes` when prompted to confirm the destruction of the resources.
