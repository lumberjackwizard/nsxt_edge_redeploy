nsxt_edge_redeploy v1.0

This is a powershell script (created using Powershell 7.3 and leveraging PowerCLI 12+) intended to ease the burden of redeploying NSX-T Edge VMs. The existing process requires performing a GET of the target Edge data, making modifications, then pushing that back out via a seperate POST injection. This script allows you to not have to worry about using Postman or any other direct method of API interactions; just populate the required data when prompted and everything will be handled. 

For v1.0, this script is intended only to redeploy an existing autodeployed NSX-T Edge VM (i.e., an Edge node created in NSX-T, resulting in the automatic deployment of the NSX-T Edge OVA). In this scenario, you don't need to do anything to the existing NSX-T Edge VM; it will be spun down and replaced automatically. 

Replacing of either an NSX-T Edge VM that was manually deployed or a physical Edge with a new Edge VM has not been tested (although, as long as the Edge VM/physical server is powered off first, this should work as well.)




What you'll need:
1: NSX manager IP or FQDN
2: NSX manager username and password
3: UUID of the target NSX-T Edge VM and 
4: The cli and root password for the NSX-T Edge VM

You can easily get the UUID of the target NSX-T Edge VM in the NSX-T UI by going to System -> Fabric -> Nodes and then selecting Edge Transport Nodes. The 'ID' column contains the UUID for each Edge VM; just copy it from here, and you can paste it into the script when prompted. 

Once you kick the script off (pwsh nsx_edge_redeploy.ps1), you'll be prompted for all of the above. For the cli and root passwords, the passwords are echo'ed back to the screen by intent, as I wanted to remove the possibility of accidental misconfiguration. 

The script and it's prompts should look similar to the below:

$ pwsh edge_vm_redeploy.ps1 
Enter NSX Manager IP or FQDN: 

Enter NSX Manager Username and Password
 
User: 
Password for user admin: 

Enter target Edge node UUID: 
Enter Edge cli password: 
Enter Edge root password: 


Once the above data is entered, if successful, you'll get the output of a PSObject representing the NSX Edge VM configuration. It will look similiar to this (example from my lab):

node_id              : e16713c2-e835-43ed-9598-10df6f522d46
host_switch_spec     : @{host_switches=System.Object[]; 
                       resource_type=StandardHostSwitchSpec}
maintenance_mode     : DISABLED
node_deployment_info : @{deployment_type=VIRTUAL_MACHINE; deployment_config=; 
                       node_settings=; resource_type=EdgeNode; 
                       external_id=e16713c2-e835-43ed-9598-10df6f522d46; 
                       ip_addresses=System.Object[]; 
                       id=e16713c2-e835-43ed-9598-10df6f522d46; 
                       display_name=edge04; tags=System.Object[]; _revision=2}
is_overridden        : False
failure_domain_id    : 4fc1e3b0-1cd4-4339-86c8-f76baddbaafb
resource_type        : TransportNode
id                   : e16713c2-e835-43ed-9598-10df6f522d46
display_name         : edge04
tags                 : {}
_create_time         : 1688669892809
_create_user         : admin
_last_modified_time  : 1688759055886
_last_modified_user  : admin
_system_owned        : False
_protection          : NOT_PROTECTED
_revision            : 2

At this point, the NSX Manager will work in conjuction with vCenter to power off and delete the old NSX Edge VM and deploy a new one with identical configuration. 
