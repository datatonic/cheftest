include Chef::Haproxy::Helpers

property :install_type, String, name_property: true, equal_to: %w(package source)
property :conf_template_source, String, default: 'haproxy.cfg.erb'
property :conf_cookbook, String, default: 'haproxy'
property :conf_file_mode, String, default: '0644'
property :bin_prefix, String, default: '/usr'
property :config_dir,  String, default: '/etc/haproxy'
property :config_file, String, default: lazy { ::File.join(config_dir, 'haproxy.cfg') }
property :haproxy_user, String, default: 'haproxy'
property :haproxy_group, String, default: 'haproxy'
property :sensitive, [true, false], default: true

# Package
property :package_name, String, default: 'haproxy'
property :package_version, [String, nil], default: nil
property :enable_ius_repo, [true, false], default: false

# Source
property :source_version,     String, default: '2.0.0'
property :source_url,         String, default: lazy { "https://www.haproxy.org/download/#{source_version.to_f}/src/haproxy-#{source_version}.tar.gz" }
property :source_checksum,    [String, nil], default: 'fe0a0d69e1091066a91b8d39199c19af8748e0e872961c6fc43c91ec7a28ff20'
property :source_target_cpu,  [String, nil], default: lazy { node['kernel']['machine'] }
property :source_target_arch, [String, nil], default: nil
property :source_target_os,   String, default: lazy { target_os(source_version) }
property :use_libcrypt,       String, equal_to: %w(0 1), default: '1'
property :use_pcre,           String, equal_to: %w(0 1), default: '1'
property :use_openssl,        String, equal_to: %w(0 1), default: '1'
property :use_zlib,           String, equal_to: %w(0 1), default: '1'
property :use_linux_tproxy,   String, equal_to: %w(0 1), default: '1'
property :use_linux_splice,   String, equal_to: %w(0 1), default: '1'
property :use_systemd,        String, equal_to: %w(0 1), default: lazy { source_version.to_f >= 1.8 ? '1' : '0' }

action :create do
  node.run_state['haproxy'] ||= { 'conf_template_source' => {}, 'conf_cookbook' => {} }
  node.run_state['haproxy']['conf_template_source'][new_resource.config_file] = new_resource.conf_template_source
  node.run_state['haproxy']['conf_cookbook'][new_resource.config_file] = new_resource.conf_cookbook

  case new_resource.install_type
  when 'package'
    case node['platform_family']
    when 'amazon'
      include_recipe 'yum-epel'
    when 'rhel'
      include_recipe 'yum-epel'
      puts ius_package[:url]

      remote_file ::File.join(Chef::Config[:file_cache_path], ius_package[:name]) do
        source ius_package[:url]
        only_if { new_resource.enable_ius_repo }
      end

      package ius_package[:name] do
        source ::File.join(Chef::Config[:file_cache_path], ius_package[:name])
        only_if { new_resource.enable_ius_repo }
      end
    end

    package new_resource.package_name do
      version new_resource.package_version if new_resource.package_version
    end

  when 'source'
    build_essential 'compilation tools'
    package source_package_list

    remote_file 'haproxy source file' do
      path ::File.join(Chef::Config[:file_cache_path], "haproxy-#{new_resource.source_version}.tar.gz")
      source new_resource.source_url
      checksum new_resource.source_checksum if new_resource.source_checksum
      action :create
    end

    make_cmd = "make TARGET=#{new_resource.source_target_os}"
    make_cmd << " CPU=#{new_resource.source_target_cpu}" unless new_resource.source_target_cpu.nil?
    make_cmd << " ARCH=#{new_resource.source_target_arch}" unless new_resource.source_target_arch.nil?
    make_cmd << " USE_LIBCRYPT=#{new_resource.use_libcrypt}"
    make_cmd << " USE_PCRE=#{new_resource.use_pcre}"
    make_cmd << " USE_OPENSSL=#{new_resource.use_openssl}"
    make_cmd << " USE_ZLIB=#{new_resource.use_zlib}"
    make_cmd << " USE_LINUX_TPROXY=#{new_resource.use_linux_tproxy}"
    make_cmd << " USE_LINUX_SPLICE=#{new_resource.use_linux_splice}"
    make_cmd << " USE_SYSTEMD=#{new_resource.use_systemd}"
    extra_cmd = ' EXTRA=haproxy-systemd-wrapper' if new_resource.source_version.to_f < 1.8

    bash 'compile_haproxy' do
      cwd Chef::Config[:file_cache_path]
      code <<-EOH
        tar xzf haproxy-#{new_resource.source_version}.tar.gz
        cd haproxy-#{new_resource.source_version}
        #{make_cmd} && make install PREFIX=#{new_resource.bin_prefix} #{extra_cmd}
      EOH
      not_if "#{::File.join(new_resource.bin_prefix, 'sbin', 'haproxy')} -v | grep #{new_resource.source_version}"
    end
  end

  with_run_context :root do
    group new_resource.haproxy_group

    user new_resource.haproxy_user do
      home "/home/#{new_resource.haproxy_user}"
      group new_resource.haproxy_group
    end

    directory new_resource.config_dir do
      owner new_resource.haproxy_user
      group new_resource.haproxy_group
      mode '0755'
      recursive true
    end

    template new_resource.config_file do
      owner new_resource.haproxy_user
      group new_resource.haproxy_group
      mode new_resource.conf_file_mode
      sensitive new_resource.sensitive
      source lazy { node.run_state['haproxy']['conf_template_source'][config_file] }
      cookbook lazy { node.run_state['haproxy']['conf_cookbook'][config_file] }
      variables()
      action :nothing
      delayed_action :nothing
    end
  end
end

action_class do
  include Chef::Haproxy::Helpers
end
