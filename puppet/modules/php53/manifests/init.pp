class php53::install {
  package { [
      'php53u',
      'php53u-common',
      'php53u-fpm',
      'php53u-pecl-apc',
      'php53u-pdo',
      'php53u-xml',
      'php53u-mbstring',
      'php53u-gd',
      'php53u-pear',
      'php53u-mcrypt',
    ]:
    ensure => present,
    require => Yumrepo['ius'],
  }
}

class php53::configure {
  file { '/etc/httpd/conf.d/php.conf':
    source => 'puppet:///modules/php53/php.conf',
    owner => 'root',
    group => 'root',
    require => Package['httpd'],
    notify => Service['httpd'],
  }

  file { '/etc/php.d':
    ensure => directory,
    recurse => true,
    owner => 'root',
    group => 'root',
    source => 'puppet:///modules/php53/php.d',
    require => Package['php53u-common'],
    notify => Service['php-fpm'],
  }
}

class php53::service {
  service { 'php-fpm':
    enable => true,
    ensure => running,
    require => Package['php53u-fpm'],
  }
}

class php53 {
  class { 'php53::install': }
  class { 'php53::configure': }
  class { 'php53::service': }
}