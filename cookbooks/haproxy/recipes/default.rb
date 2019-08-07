
haproxy_install 'install' do
  haproxy_user 'haproxy'
  haproxy_group 'haproxy'
  install_type 'source'
  source_version '2.0.3'
  source_url 'http://www.haproxy.org/download/2.0/src/haproxy-2.0.3.tar.gz'
  source_checksum 'aac1ff3e5079997985b6560f46bf265447d0cd841f11c4d77f15942c9fe4b770'
  use_libcrypt '1'
  use_pcre '1'
  use_openssl '1'
  use_zlib '1'
  action :create
end

haproxy_config_global 'global' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  debug_option 'quiet'
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5s',
          client: '50s',
          server: '50s'
  log 'global'
  config_dir '/etc/haproxy'
  config_file '/etc/haproxy/haproxy.cfg'
  retries 3
end

#haproxy_acl 'acl_haproxynode' do
#  section 'frontend'
#  section_name 'haproxynode'
#  acl ['path -i -m end  /test.html']
#end

haproxy_frontend 'haproxynode' do
  bind '0.0.0.0:443 ssl crt /etc/ssl/private/haproxy.pem'
  use_backend ['backendnodes']
  default_backend 'go_google'
end

haproxy_backend 'backendnodes' do
  mode 'http'
  acl ['path -i -m end  /test.html']
  server ['nginx1 192.168.0.4:8080 check weight 1 maxconn 100',
          'nginx2 192.168.0.5:8080 check weight 1 maxconn 100']
end

haproxy_listen 'listen' do
  bind '0.0.0.0:443 ssl crt /etc/ssl/private/haproxy.pem'
end

haproxy_backend 'go_google' do
  server ['www.google.com']
end

# haproxy_listen 'admin' do
#  bind '0.0.0.0:1337'
#  mode 'http'
#  stats uri: '/',
#        realm: 'Haproxy-Statistics',
#        auth: 'user:pwd'
#  http_request 'add-header X-Proto http'
#  http_response 'set-header Expires %[date(3600),http_date]'
#  extra_options('bind-process' => 'odd')
# end

haproxy_service 'haproxy' do
  subscribes :reload, ['template[/etc/haproxy/haproxy.cfg]', 'file[/etc/haproxy/ssl/haproxy.pem]'], :delayed
end

