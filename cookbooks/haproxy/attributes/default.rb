override['haproxy']['incoming_address'] = '0.0.0.0'
override['haproxy']['incoming_port'] = '443'
override['haproxy']['members'] = [{
    'hostname' => 'wNginx1',
    'ipaddress' => '192.168.0.181',
    'port' => 8080,
  }, {
    'hostname' => 'wNginx2',
    'ipaddress' => '192.168.0.182',
    'port' => 8080,
  }]
override['haproxy']['balance_algorithm'] = 'roundrobin'
override['haproxy']['enable_ssl'] = false
override['haproxy']['enable_admin'] = true
override['haproxy']['install_method'] = 'source'
override['haproxy']['source']['version'] = '2.0.3'
override['haproxy']['source']['url'] = 'http://www.haproxy.org/download/2.0/src/haproxy-2.0.3.tar.gz'
override['haproxy']['source']['checksum'] = 'aac1ff3e5079997985b6560f46bf265447d0cd841f11c4d77f15942c9fe4b770'
override['haproxy']['source']['use_pcre'] = '1'
override['haproxy']['source']['use_libcrypt'] = '1'
override['haproxy']['source']['use_openssl'] = '1'
override['haproxy']['source']['use_zlib'] = '1'
override['haproxy']['source']['use_linux_tproxy'] = '1'
override['haproxy']['source']['use_linux_splice'] = '1'
override['haproxy']['balance_algorithm'] = 'roundrobin'
override['haproxy']['ssl_incoming_port'] = '443'
override['haproxy']['enable_ssl'] = true
override['haproxy']['ssl_incoming_address'] = '0.0.0.0'
override['haproxy']['user'] = 'haproxy'
override['haproxy']['group'] = 'haproxy'

