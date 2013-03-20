class openresty {
  Exec { path => "/usr/bin:/usr/sbin/:/bin:/sbin" }

  class { 'openresty::package': }
}