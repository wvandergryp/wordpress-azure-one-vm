# wordpress-azure-one-vm
Deploy a WordPress site on a single Azure Virtual Machine using Terraform, free for the first 12 months with Azure Free Tier.

Steps to Deploy
Clone the repository and navigate to the project directory.
Authenticate with Azure using the CLI.
Update the terraform.tfvars file with your Azure credentials, environment, and VM configuration.
Initialize Terraform to download the required providers.
Preview the infrastructure changes using terraform plan.
Apply the configuration to create the resources.
Wait a few minutes for the deployment to complete.
Retrieve the public IP of the VM.
Open your browser and navigate to http://<public-ip> to access the WordPress site.
Complete the WordPress setup by configuring the database and creating the admin user.
Change the default WordPress admin password for security.
Enable automatic updates for WordPress core and plugins.
Restrict SSH access to your IP only by modifying the NSG rules.
Add an SSL certificate for HTTPS using Let’s Encrypt.
Set up automated backups using Azure Backup.
Monitor and manage costs with Azure Cost Management.
Use Azure Advisor to optimize performance and security.
When done, destroy the infrastructure to avoid unnecessary costs.
Verify that all resources are removed from the Azure portal.
Enjoy your WordPress site running on Azure!







