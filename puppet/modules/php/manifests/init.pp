class php::install {
  package { [
      "php${php::package}",
      "php${php::package}-cli",
      "php${php::package}-common",
      "php${php::package}-fpm",
      "php${php::package}-pecl-imagick",
      "php${php::package}-pecl-memcache",
      "php${php::package}-pdo",
      "php${php::package}-xml",
      "php${php::package}-mbstring",
      "php${php::package}-gd",
      "php${php::package}-pear",
      "php${php::package}-mcrypt",
    ]:
    ensure => present,
    require => Yumrepo['ius'],
  }
  case $php::package {
    53u, 54: {
      package { [
          "php${php::package}-pecl-memcached",
          "php${php::package}-pecl-apc",
          "php${php::package}-mysql",
        ]:
        ensure => present,
        require => Yumrepo['ius'],
      }
    }
    55u: {
      package { [
          "php${php::package}-pecl-jsonc",
          "php${php::package}-mysqlnd",
          "php${php::package}-opcache",
        ]:
        ensure => present,
        require => Yumrepo['ius'],
      }
    }
  }
}

class php::configure {
  file { '/etc/httpd/conf.d/php.conf':
    source => 'puppet:///modules/php/php.conf',
    owner => 'root',
    group => 'root',
    require => [Package['httpd'], Package["php${php::package}"]],
    notify => Service['httpd'],
  }

  file { '/etc/php.d':
    ensure => directory,
    recurse => true,
    owner => 'root',
    group => 'root',
    source => 'puppet:///modules/php/php.d',
    require => Package["php${php::package}-common"],
    notify => Service['php-fpm'],
  }

  file { '/etc/php-fpm.d/www.conf':
    ensure => present,
    content => template('php/www.conf.erb'),
    require => Package["php${php::package}-fpm"],
    notify => Service['php-fpm'],
  }

  augeas { 'php.ini':
    context => "/files/etc/php.ini/PHP",
    require => Package["php${php::package}"],
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

class php::service {
  service { 'php-fpm':
    enable => true,
    ensure => running,
    require => Package["php${php::package}-fpm"],
  }
}

class php ($version = '54', $memory_share = 1.0, $worker_average_memory = 64) {
  $package = $version ? {
    '5.3' => '53u',
    '5.4' => '54',
    '5.5' => '55u',
  }

  class { 'php::install': }
  class { 'php::configure': }
  class { 'php::service': }
}