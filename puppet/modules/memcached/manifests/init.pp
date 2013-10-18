class memcached::install {
  package { [ "memcached" ] :
    ensure => present,
  }
}

class memcached::configure {
  file { '/etc/sysconfig/memcached':
    content => template('memcached/memcached.erb'),
    require => Package [ 'memcached' ],
    notify => Service [ 'memcached' ],
  }
}

class memcached::service {
  service { "memcached":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["memcached::install"],
  }
}

class memcached ($memory_share = 1.0) {
  class { 'memcached::install': }
  class { 'memcached::configure': }
  class { 'memcached::service': }
}
