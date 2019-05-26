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

firewall_rule 'inbound 6443' do
  port     [22,6443,2379,2380,10250,10251,10252,10255]
  protocol :tcp
  command  :allow
end

kernel_module 'br_netfilter' do
  action :install
end

# execute 'set_bridge-nf-call-iptables' do
#   command "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
# end

sysctl 'net.bridge.bridge-nf-call-iptables' do
#  conf_dir          String # default value: "/etc/sysctl.d"
#  ignore_error      true, false # default value: false
#  key               String # default value: 'name' unless specified
  value 1
#  action            Symbol # defaults to :apply if not specified
end

sysctl 'net.bridge.bridge-nf-call-ip6tables' do
  #  conf_dir          String # default value: "/etc/sysctl.d"
  #  ignore_error      true, false # default value: false
  #  key               String # default value: 'name' unless specified
    value 1
  #  action            Symbol # defaults to :apply if not specified
  end
