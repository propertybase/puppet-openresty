class openresty::package {
  include openresty::params

  if ! defined(Package['libreadline-dev']) { package { 'libreadline-dev': ensure => installed, } }
  if ! defined(Package['libncurses5-dev']) { package { 'libncurses5-dev': ensure => installed, } }
  if ! defined(Package['libpcre3-dev']) { package { 'libpcre3-dev': ensure => installed, } }
  if ! defined(Package['libssl-dev']) { package { 'libssl-dev': ensure => installed, } }
  if ! defined(Package['perl']) { package { 'perl': ensure => installed, } }
  if ! defined(Package['wget']) { package { 'wget': ensure => installed, } }

  exec { 'openresty::package::download_openresty':
    cwd     => '/tmp',
    command => "wget ${openresty::params::openresty_url} -O openresty.tar.gz",
    creates => '/tmp/openresty.tar.gz',
    require  => [
      Package['wget'],
    ]
  }

  exec { 'openresty::package::download_luasocket':
    cwd     => '/tmp',
    command => 'wget ${openresty::params::luasocket_url} -O luasocket.tar.gz',
    creates  => '/tmp/luasocket.tar.gz',
    require  => [
      Package['wget'],
    ]
  }

  exec { 'openresty::package::install_openresty':
    cwd     => '/tmp',
    command => "tar zxf openresty.tar.gz ; cd ngx_* ; ./configure --with-luajit ; make -j2 install",
    creates => '/usr/local/openresty',
    require  => [
      Package['libreadline-dev'],
      Package['libncurses5-dev'],
      Package['libpcre3-dev'],
      Package['libssl-dev'],
      Package['perl'],
      Exec['openresty::package::download_openresty'],
    ],
  }

  exec { 'openresty::package::install_luasocket':
    cwd     => '/tmp',
    command => 'tar zxf openresty.tar.gz ; cd ngx_* ; ./configure --with-luajit ; make -j2 install',
    creates => '/usr/local/share/lua/5.1/socket',
    require  => [
      Exec['openresty::package::download_luasocket'],
      Exec['openresty::package::install_openresty'],
    ],
  }
}