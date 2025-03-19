# wordpress-azure-one-vm
Running WorkdPress on a single Azure VM almost free.


This will display a preview of the resources Terraform will create, including:

Resource group

Virtual network and subnet

Public IP and network interface

Security group rules

Linux VM

✅ Verify the plan output carefully before applying.



🚀 Step 6: Apply the Configuration
Run the following command to create the infrastructure:

terraform apply
Confirm the changes by typing yes when prompted.

The deployment process takes a few minutes.

Minimize image
Edit image
Delete image


🌐 Step 7: Access the WordPress Site
Get the public IP of the VM: After the deployment, Terraform will output the public IP address of the VM.

terraform output linux_vm_ip_address
Access the WordPress site: Open your web browser and navigate to:

http://<public-ip>



Minimize image
Edit image
Delete image


Click on Continue



Minimize image
Edit image
Delete image


WordPress Installation Wizard:

Choose your language.

Enter the database details configured in the cloud-init script.

Create your admin user and set the password.



Minimize image
Edit image
Delete image


You can access the OS by using the password specified in the terraform.tfvars file.



Minimize image
Edit image
Delete image


🔒 Step 8: Secure the Installation
Once WordPress is running:

Change the default admin password on WordPress for security.

Enable automatic updates for WordPress core and plugins.

Consider adding a firewall rule to restrict SSH access to your IP only.



🎉 Step 9: Enjoy Your WordPress Site
Congratulations! 🎊 You now have a fully functional WordPress site running on Azure, deployed with Terraform, and free for the first 12 months if you use the Standard_B2pts_v2 VM size.



✅ Next steps:

Automate backups for your WordPress site.

Enable SSL encryption with Let’s Encrypt for HTTPS access.

Scale the environment by adding a load balancer or using Azure Database for MySQL.

Run the following command to destroy the infrastructure:

terraform destroy
Conclusion
With Terraform, you can automate the entire infrastructure setup for a WordPress site on Azure. This includes the creation of resources like VMs, network interfaces, subnets, and network security groups. By using infrastructure-as-code, we achieve consistency, scalability, and the ability to quickly replicate environments.

Happy Terraforming!
