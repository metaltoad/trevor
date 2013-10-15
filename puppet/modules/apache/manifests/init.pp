class apache::install {
  file { '/usr/src/redhat/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm':
    ensure => present,
    owner => root,
    group => root,
    source => 'puppet:///modules/apache/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm',
    mode => 664,
  }
  package { ['httpd', 'mod_ssl']:
    ensure => present,
  }
  package { 'mod_fastcgi':
    ensure => present,
    provider => 'rpm',
    source => '/usr/src/redhat/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm',
    require => [File['/usr/src/redhat/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm'], Package['httpd']],
  }
  file { '/var/www/sites':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    require => Package['httpd'],
  }
}

class apache::config {
  file { '/etc/httpd/conf.d':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/apache/conf.d',
    owner => 'root',
    group => 'root',
    require => Package['httpd'],
    notify => Service['httpd'],
  }
}

class apache::service {
  service { 'httpd':
    enable => true,
    ensure => running,
    require => Package['httpd'],
  }
}

class apache {
  class { 'apache::install': }
  class { 'apache::config': }
  class { 'apache::service': }
}