#Created on Powershell 7.3

#First we prompt for the nsx manager IP/fqdn and credentials. This populates the $Url variable. 
$Cred = Get-Credential
$Url = "https://nsxt-mgr-a.myhomevlab.com/api/v1/transport-nodes/df7ccc66-531b-4cd5-a1db-a0f87f6bfa95"

# invoke-restmethod takes the data from above and gathers the information on the target edge node that will be replaced
$replace_edge = Invoke-RestMethod -Uri $Url -Credential $Cred -SkipCertificateCheck -Authentication Basic


#the original edge node's cli password and root password are not gathered as part of the previous request, 
#and must be configured for the replacement edge
$replace_edge.node_deployment_info.deployment_config.node_user_settings | Add-Member -Type NoteProperty -Name 'root_password' -Value "VMware1!VMware1!"
$replace_edge.node_deployment_info.deployment_config.node_user_settings | Add-Member -Type NoteProperty -Name 'cli_password' -Value "VMware1!VMware1!"


#Now we convert the $replace_edge powershell object to json, so it can be used to create the replacement edge
$json_replace_edge = $replace_edge | ConvertTo-Json -Depth 10

#creating the target url to initiate edge redeployment; it's the original URL with a query parameter appended. 
$PostUrl = $Url +'?action=redeploy'


#This is an array that will be called on in the upcoming invoke-restmethod to inject the command; it places the previously gathered/added data in the body
# of a new POST reqest to the NSX manager. 
$Post_Parameters = @{
    Method = "Post"
    Uri = $PostUrl
    Body = $json_replace_edge
    ContentType = "application/json"
}


# Invoke-Restmethod here is using the data from post_parameters to perform the actual edge redployment request
Invoke-RestMethod @Post_Parameters -Credential $Cred -SkipCertificateCheck -Authentication Basic