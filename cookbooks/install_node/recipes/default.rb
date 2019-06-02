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

execute 'disable_swap' do
  command 'swapoff -av'
end

yum_repository 'docker-ce-stable' do
  baseurl "https://download.docker.com/linux/centos/7/x86_64/stable/"
  gpgcheck true
  gpgkey "https://download.docker.com/linux/centos/gpg"
  action :create
end

package 'docker-ce' do
  action :install
end

directory '/etc/docker' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template '/etc/docker/daemon.json' do
  source 'daemon.json.erb'
  mode '0755'
  owner 'root'
  group 'root'
end

directory '/etc/systemd/system/docker.service.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'daemon-reload' do
  command 'systemctl daemon-reload'
end


yum_repository 'kubernetes' do
  baseurl "https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64"
  gpgcheck true
  gpgkey [
    'https://packages.cloud.google.com/yum/doc/yum-key.gpg',
    'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg'
  ]
  repo_gpgcheck true
  action :create
end

['kubelet', 'kubeadm', 'kubectl'].each do |p|
  package p do
    action :install
  end
end

service 'docker' do
  action [ :enable, :start ]
end

service 'kubelet.service' do
  action :enable
end