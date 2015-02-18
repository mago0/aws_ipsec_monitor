aws_ipsec_monitor Cookbook
==========================
Creates an IPSec monitoring server specific to AWS VPC

Monitors one active and one failover IPSec node with a remote tunnel endpoint.

Requirements
------------
- VPC with at least one subnet to be routed 
- EIP for pair of IPSec instances
- Two IPSec instances, built via Chef with some defined IPSec Chef role assigned
  to each
- Monitor server will require IAM role with permissions necessary to stop/start
  instances, modify routing tables, and move an EIP
- Must define a region attribute via recipe or on the node itself.

Attributes
----------
```ruby
default["aws_ipsec_monitor"]["cli_extract_dir"] = "/usr/local/ec2"
default["aws_ipsec_monitor"]["dir"] = "/usr/local/bin"

#The tag assigned to the two local IPSec servers
default["aws_ipsec_monitor"]["ipsec_tag"] = "ipsec_tunnel"

#EC2 (VPC) specific attributes that must be defined via role. 
#  The ID of the route tables for which VPC will direct remote subnet traffic
default["aws_ipsec_monitor"]["route_ids"] = []

#The local Elastic IP to be managed for the pair of IPSec servers
default["aws_ipsec_monitor"]["eip_id"] = nil

#The remote Elastic IP to which the local IPSec instances are connecting
default["aws_ipsec_monitor"]["remote_eip"] = nil

#A remote internal IP to ping for health checking the tunnel. 
#  If you have a failover pair on the remote end, DON'T use one of the instance 
#  IPs as a failure on the remote will cause a local failure
default["aws_ipsec_monitor"]["remote_ip"] = nil

#Remote subnets that we have VPC routing entries. These need to line up exactly.
default["aws_ipsec_monitor"]["remote_subnets"] = []

#How many time to ping the remote endpoint
default["aws_ipsec_monitor"]["num_pings"] = 20

default["aws_ipsec_monitor"]["ping_timeout"] = 3

#How long between each iteration of pings
default["aws_ipsec_monitor"]["wait_between_pings"] = 30

#How long to wait for a failed instance to be stopped
default["aws_ipsec_monitor"]["wait_for_instance_stop"] = 60

#How long to wait for a failed instance to be started
default["aws_ipsec_monitor"]["wait_for_instance_start"] = 300 
```

Usage
-----
#### aws_ipsec_monitor::default
Create a role with the following attributes. Do yourself a favor and have IPSec, Elastic IPs, routing tables all set up before defining the role.

Requires exactly two nodes to be tagged with the value of node["aws_ipsec_monitor"]["ipsec_tag"] attribute

```ruby
name "ipsec_monitor"
description "The IPSec tunnel monitor for our VPC"

run_list(
  "recipe[aws_ipsec_monitor]"
)
default_attributes({
  "aws_ipsec_monitor" => {
    "route_ids" => [ "rtb-xxxxxxxx", "rtb-xxxxxxxx" ],
    "eip_id" => "eipalloc-xxxxxxxx",
    "remote_eip" => "xx.xx.xx.xx",
    "remote_ip" => "10.0.5.5",
    "remote_subnets" => [ "10.0.0.0/16" ]
  }
})
```

License and Authors
-------------------
Authors: Matt Williams

