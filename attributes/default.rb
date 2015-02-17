default["aws_ipsec_monitor"]["cli_extract_dir"] = "/usr/local/ec2"
default["aws_ipsec_monitor"]["dir"] = "/usr/local/bin"
default["aws_ipsec_monitor"]["ipsec_tag"] = "ipsec_tunnel"

# EC2 (VPC) specific attributes that must be defined via role
default["aws_ipsec_monitor"]["route_ids"] = []
default["aws_ipsec_monitor"]["eip_id"] = nil
default["aws_ipsec_monitor"]["remote_eip"] = nil
default["aws_ipsec_monitor"]["remote_ip"] = nil
default["aws_ipsec_monitor"]["remote_subnets"] = []

default["aws_ipsec_monitor"]["num_pings"] = 20
default["aws_ipsec_monitor"]["ping_timeout"] = 3
default["aws_ipsec_monitor"]["wait_between_pings"] = 30
default["aws_ipsec_monitor"]["wait_for_instance_stop"] = 60
default["aws_ipsec_monitor"]["wait_for_instance_start"] = 300 

