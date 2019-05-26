#
# Cookbook:: install_node
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# include_recipe 'firewall'
firewall 'default' do
  action :install
end
node.default['firewall']['allow_ssh'] = true
node.default['firewall']['firewalld']['permanent'] = true

puts("You can log node info #{node['foo']} from a recipe using 'Chef::Log'")

selinux_state 'SELinux Disabled' do
  action :disabled
end

firewall_rule 'inbound FW Rules' do
  port     [22,6443,2379,2380,10250,10251,10252,10255]
  protocol :tcp
  command  :allow
end

kernel_module 'br_netfilter' do
  action :install
end

sysctl 'net.bridge.bridge-nf-call-iptables' do
  value 1
end

sysctl 'net.bridge.bridge-nf-call-ip6tables' do
    value 1
  end

  ['yum-utils','device-mapper-persistent-data','lvm2'].each do |p|
    package p do
      action :install
    end
  end