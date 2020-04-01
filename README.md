# AWS-infrastructure-with-Terraform

### Project Overview

| IAC |
| AWS | 
| VPC |
| SUBNETS | 
| ROUTE TABLES |
| SECURITY GROUP |
| NAT GATEWAY |
| TERRAFORM |

Using terraform the below AWS infrastructure has been created as code allowing for easy configuration consistency wherever this structure is implemented. 
![structure]

The above infrastructure is commonly used for two-tier applications such as Word-Press. In such cases the public subnet is used for the webserver and for security purposes the private subnet is used for the database instance. 
Instances in the private subnet are configured such that they can only be accessed through ssh from an instance in the public subnet. 
The NAT gateway ensures that although the instance in the private subnet cannot be accessed from outside the public subnet, it still has access to the internet allowing for all relevant modules (eg mysql) to be downloaded. 

[structure]: https://i.imgur.com/sYsW0Oj.png
