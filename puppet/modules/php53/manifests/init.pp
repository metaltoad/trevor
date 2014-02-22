class php53::install {
  package { [
      'php53u',
      'php53u-cli',
      'php53u-common',
      'php53u-fpm',
      'php53u-pecl-apc',
      'php53u-pecl-imagick',
      'php53u-pecl-memcached',
      'php53u-pdo',
      'php53u-mysql',
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

  file { '/etc/php-fpm.d/www.conf':
    ensure => present,
    content => template('php53/www.conf.erb'),
    require => Package['php53u-fpm'],
    notify => Service['php-fpm'],
  }

  augeas { 'php.ini':
    context => "/files/etc/php.ini/PHP",
    require => Package['php53u'],
    notify => Service['php-fpm'],
    changes => [
      "set expose_php Off",
      "set allow_url_fopen On",
      "set display_errors On",
      "set error_reporting 'E_ALL | E_STRICT'",
      "set date.timezone 'America/Los_Angeles'",
    ],
  }
}

class php53::service {
  service { 'php-fpm':
    enable => true,
    ensure => running,
    require => Package['php53u-fpm'],
  }
}

class php53 ($memory_share = 1.0, $worker_average_memory = 64) {
  class { 'php53::install': }
  class { 'php53::configure': }
  class { 'php53::service': }
}