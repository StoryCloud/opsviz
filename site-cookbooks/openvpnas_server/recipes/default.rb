node.normal[:openvpnas][:url] = "http://swupdate.openvpn.org/as/openvpn-as-#{node[:openvpnas_server][:version]}-Ubuntu14.amd_64.deb"

include_recipe "openvpnas::default"

Chef::Application.fatal!("OpenVPN admin password must be set") unless node[:openvpnas_server][:admin_password].is_a?(String)

chef_gem "ruby-shadow"

user "openvpn" do
  action :modify
  password node[:openvpnas_server][:admin_password]
end
