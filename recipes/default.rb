#
# Cookbook Name:: aws_ipsec_monitor
# Recipe:: default
#

package "openjdk-7-jre"

settings = node["aws_ipsec_monitor"]

remote_file "ec2-api-tools" do
  source "http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip"
  path "#{Chef::Config["file_cache_path"]}/ec2-api-tools.zip"
  only_if { Dir.glob("#{settings["cli_extract_dir"]}/ec2*").empty? }
end

bash "unzip-ec2-tools" do
  code "unzip -o #{Chef::Config["file_cache_path"]}/ec2-api-tools.zip -d #{settings["cli_extract_dir"]}"
  only_if { Dir.glob("#{settings["cli_extract_dir"]}/ec2*").empty? }
end

node.set["aws_ipsec_monitor"]["ec2_home"] = "#{settings["cli_extract_dir"]}/" + `ls #{settings["cli_extract_dir"]}`.tr("\n","")

servers = search(:node, "tags:#{settings["ipsec_tag"]} AND chef_environment:#{node.chef_environment} AND region:#{node["region"]}").sort!
if servers.length != 2
  fail "You must tag exactly two instances with '#{settings["ipsec_tag"]}'"
end

log servers.inspect

template "#{settings["dir"]}/ipsec_monitor.rb" do
  source "ipsec_monitor.rb.erb"
  variables({ 
    settings: settings,
    servers: servers 
  })
  notifies :restart, "service[ipsec_monitor]"
end

template "/etc/init/ipsec_monitor.conf" do
  source "ipsec_monitor.conf.erb"
  variables({
    ec2_home: node["aws_ipsec_monitor"]["ec2_home"],
    region: node["region"],
    settings: settings
  })
  notifies :restart, "service[ipsec_monitor]"
end
    
# Register service
service "ipsec_monitor" do
  action [ :enable, :start ]
  supports :restart => true, :status => true
  provider Chef::Provider::Service::Upstart
end

