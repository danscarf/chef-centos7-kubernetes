#
# Cookbook:: install_node
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

puts("You can log node info #{node['foo']} from a recipe using 'Chef::Log'")

selinux_state "SELinux Permissive" do
    action :disabled
  end