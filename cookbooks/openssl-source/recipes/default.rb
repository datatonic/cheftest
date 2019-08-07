## Cookbook Name:: openssl_source
## Recipe:: default

openssl_version = node['openssl_source']['openssl']['version']
src_dirpath = "#{Chef::Config['file_cache_path']}/openssl-#{openssl_version}"
src_filepath = "#{src_dirpath}.tar.gz"

prefix_dir = node['openssl_source']['openssl']['prefix']

remote_file src_filepath do
  source   node['openssl_source']['openssl']['url']
  checksum node['openssl_source']['openssl']['checksum']
  path     src_filepath
  backup   false
  not_if { ::File.directory?(prefix_dir) && `#{prefix_dir}/bin/openssl version`.match(/#{openssl_version}/) }
end

execute 'unarchive_openssl' do
  cwd     ::File.dirname(src_filepath)
  command "tar zxf #{::File.basename(src_filepath)} -C #{::File.dirname(src_filepath)}"
  not_if  { ::File.directory?(src_dirpath) }
  action :nothing
  subscribes :run, "remote_file[#{src_filepath}]", :immediately
end

configure_flags = node['openssl_source']['openssl']['configure_flags'].dup
configure_flags << "--prefix=#{prefix_dir}"

execute 'compile_openssl_source' do
  cwd  src_dirpath
  command <<-EOH
    ./config #{configure_flags.join(' ')} && make && make install
  EOH
  action :nothing
  subscribes :run, 'execute[unarchive_openssl]', :immediately
end

certs_dir = File.join(prefix_dir, 'ssl', 'certs')

ruby_block 'sync certificates' do
  block do
    FileUtils.mkdir_p(certs_dir)
    FileUtils.cp_r(Dir["/etc/ssl/certs/*.pem"], certs_dir)
  end
  action :nothing
  subscribes :run, 'execute[compile_openssl_source]', :immediately
end

execute 'hash certificates with SHA1' do
  cwd  certs_dir
  command <<-EOH
    #{File.join(prefix_dir, 'bin', 'c_rehash') }
  EOH
  action :nothing
  subscribes :run, 'ruby_block[sync certificates]', :immediately
end
