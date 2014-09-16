class base {

  group { 'vagrant':
    ensure => present,
  }
  user { 'vagrant':
    ensure => present,
    gid => 'vagrant',
    groups => ['wheel', 'apache'],
    require => Package['httpd'],
  }

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

  service { 'iptables':
    enable => true,
    ensure => running,
  }

  file { '/etc/sysconfig/iptables':
    source => 'puppet:///modules/base/iptables',
    notify => Service['iptables'],
  }

  # basic useful stuff.
  package { [
    'yum-cron',
    'screen',
    'ImageMagick',
    'git',
    'subversion',
    'mercurial',
    'bzr',
    'graphviz',
    'ruby-devel',
  ]:
    ensure => present,
  }
}