class base {
  file { ['/usr/src/redhat', '/usr/src/redhat/RPMS']:
    ensure => directory,
    owner => root,
    group => root,
    mode => 0755,
  }

  file { '/etc/localtime':
    ensure => file,
    mode   => '0644',
    source => '/usr/share/zoneinfo/US/Pacific',
  }
}