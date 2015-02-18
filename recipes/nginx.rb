certificate_manage node[:redmine][:ssl_data_bag_name].to_s do
  cert_path node[:redmine][:ssl_cert_dir]
  owner node[:nginx][:user]
  group node[:nginx][:user]
  nginx_cert true
  create_subfolders true
  not_if { node[:redmine][:ssl_data_bag_name].nil? }
end

include_recipe 'nginx'

template "#{node[:nginx][:dir]}/sites-available/redmine" do
  source 'nginx-redmine.erb'
  mode 0777
  owner node[:nginx][:user]
  group node[:nginx][:user]
  variables(
    app_path:        "#{node[:redmine][:home]}/redmine",
    server_name:     node[:redmine][:host],
    listen_port:     node[:redmine][:listen_port],
    ssl_listen_port: node[:redmine][:ssl_listen_port],
    ssl_cert:        "#{node[:redmine][:ssl_cert_dir]}/certs/#{node[:fqdn]}.pem",
    ssl_key:         "#{node[:redmine][:ssl_cert_dir]}/private/#{node[:fqdn]}.key"
  )
end

nginx_site 'redmine' do
  enable true
end
