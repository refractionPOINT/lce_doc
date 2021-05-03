# User Access

To control who has access to an organization, and what they have access to, go
to the "Users" section of the web UI.

Adding users is done by email address and requires the user to already have
a limacharlie.io account.

The first user of an organization is added with Owner permissions at creation time.
Owner permissions give full access to everything.

New users added after the creation of an orgnization are added with Unset privileges,
which means the user is only able to get the most basic information on the organization.

Therefore the first step after adding a new user should always be to change their
permissions by clicking the Edit icon beside their name.

Permissions can be controlled individually, or you can apply pre-set permission
schemes by selecting it at the top of the dialog box, clicking Apply and then
clicking the Save button at the bottom.

The following permissions are available:

| Permission        | Description                                                          
| ----------------- | ---------------------------------------------------------------------
| apikey.ctrl       | Create, delete and modify API keys.                                  
| user.ctrl         | Create, delete and change permissions for users.                     
| billing.ctrl      | Change billing information, subscribe to additional services.        
| org.get           | Get information about the organization.                              
| sensor.list       | List all sensors.                                                    
| sensor.get        | Get information about a sensor.                                      
| sensor.task       | Send commands to a sensor.                                           
| sensor.del        | Delete a sensor and remove its access.                               
| sensor.tag        | Add and remove tags.                                                 
| dr.list           | List all Detection & Response rules in the 'general' namespace.      
| dr.set            | Add and update Detection & Response rules in the 'general' namespace.
| dr.del            | Delete Detection & Response rules in the 'general' namespace.        
| dr.list.managed   | List all Detection & Response rules in the 'managed' namespace.      
| dr.set.managed    | Add and update Detection & Response rules in the 'managed' namespace.
| dr.del.managed    | Delete Detection & Response rules in the 'managed' namespace.        
| fp.ctrl           | Manage False Positives from detections.                              
| module.update     | Update and revert sensor version.                                    
| ikey.list         | List all installation keys.                                          
| ikey.set          | Create and update installation keys.                                 
| ikey.del          | Delete installation keys.                                            
| output.list       | List all data Outputs.                                               
| output.set        | Create and update Output rules.                                      
| output.del        | Delete Output rules.                                                 
| audit.get         | Get audit and error messages.                                        
| org.conf.get      | Get organization configurations.                                     
| org.conf.set      | Update organization configurations.                                  
| insight.evt.get   | Get event history from Insight.                                      
| insight.det.get   | Get detection history from Insight.                                  
| insight.det.del   | Delete detections from Insight.                                      
| insight.list      | List the status of Insight.                                          
| insight.stat      | Get various statistics from Insight.                                 
| incident.get      | Get incidents data.                                                  
| incident.set      | Set the incidents status.                                            
| job.get           | Get jobs data.                                                       
| job.set           | Modify the jobs status.                                              
| replicant.task    | Issue requests to Services.                                          
| replicant.get     | Get the list of active Services.                                     
| ingestkey.ctrl    | Change ingestion keys.                                               
| payload.ctrl      | Add/Remove/Get Payloads.                                             
| payload.use       | Deploy a payload to a sensor.                                        
| comms.room.list   | List and view rooms.                                                 
| comms.room.create | Create rooms.                                                        
| comms.status      | Change room status.                                                  
| comms.assign      | Assign users to rooms.                                               
| comms.msg.view    | View messages in rooms.                                              
| comms.msg.post    | Post messages in rooms.                                              
| comms.link        | Add and remove links in rooms.                                       
| comms.bucket      | Modify room bucketing rules.                                         
| net.provision     | Provision new net endpoints.                                         
| net.policy.get    | Get the policies applied to net endpoints.                           
| net.policy.set    | Set a policy applied to net endpoints.                               


# Access Management via Organization Groups
Organization Groups allow you to grant permissions to a set of users on a group of organizations.

Permissions granted through the group are applied on top of permissions granted at the organization level. The permissions are additive, and a group cannot be used to subtract permissions granted at the organization level.

Organization Group Owners are allowed to manage the Organization Group, but are not affected by the permissions. Members are affected by the permissions but do not have the ability to modify the Organization Group.