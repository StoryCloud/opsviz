node.normal[:openvpnas][:url] = "http://swupdate.openvpn.org/as/openvpn-as-#{node[:openvpnas_server][:version]}-Ubuntu14.amd_64.deb"

include_recipe "openvpnas::default"
