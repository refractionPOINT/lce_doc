# Reference: Permissions

The following is a list of all permissions that can be applied via User, API Key, or Group.

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
| cloudsensor.del	  | Delete Cloud Sensor configuration.
| cloudsensor.get	  | Get Cloud Sensor configuration.
| cloudsensor.get.mtd | Get Cloud Sensor Metadata configuration.
| cloudsensor.set	| Set Cloud Sensor configuration.
| cloudsensor.set.mtd	| Set Cloud Sensor Metadata configuration.
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
