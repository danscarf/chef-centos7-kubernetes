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

firewall_rule 'ssh port 22' do
  port     22
  protocol :tcp
  command  :allow
end

firewall_rule 'inbound 6443' do
  port     6443
  protocol :tcp
  command  :allow
end
