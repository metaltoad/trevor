class php::install {

  if $php::version =~ /5.3|5.4|5.5/ {
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
        "php${php::package}-pecl-xdebug",
        "php${php::package}-devel",
      ]:
      ensure => present,
      require => Yumrepo['ius'],
    }
    file {'/etc/php.d/z_xdebug-settings.ini':
      source => 'puppet:///modules/php/php.d/xdebug.ini',
      owner => 'root',
      group => 'root',
      require => Package["php${php::package}"],
      notify => Service['php-fpm'],
    }
    exec {'xhprof-install':
      command => 'pecl install channel://pecl.php.net/xhprof-0.9.4',
      creates => '/usr/lib64/php/modules/xhprof.so',
      path => "/bin:/sbin:/usr/bin:/usr/sbin",
      require => Package["php${php::package}-devel"],
    }
    exec {'xhprof-install-html':
      # Workaround for bug https://bugs.php.net/bug.php?id=65992
      cwd => '/var/www/sites',
      command => 'git clone https://github.com/phacility/xhprof.git',
      creates => '/var/www/sites/xhprof/xhprof_html/index.php',
      path => "/bin:/sbin:/usr/bin:/usr/sbin",
      require => [File['/var/www/sites'], Package[git]],
    }
    file {'/etc/php.d/xhprof.ini':
      source => 'puppet:///modules/php/php.d/xhprof.ini',
      owner => 'root',
      group => 'root',
      require => Package["php${php::package}"],
      notify => Service['php-fpm'],
    }
    file {'/etc/httpd/conf.d/xhprof.conf':
      source => 'puppet:///modules/php/xhprof.conf',
      owner => 'root',
      group => 'root',
      require => Package["httpd"],
      notify => Service['httpd'],
    }
  }
  if $php::version =~ /5.3|5.4/ {
    package { [
        "php${php::package}-pecl-memcached",
        "php${php::package}-pecl-apc",
        "php${php::package}-mysql",
      ]:
      ensure => present,
      require => Yumrepo['ius'],
    }
    file { '/etc/php.d/apc.ini':
      source => 'puppet:///modules/php/php.d/apc.ini',
      owner => 'root',
      group => 'root',
      require => Package["php${php::package}"],
      notify => Service['php-fpm'],
    }
  }
  if $php::version =~ /5.5/ {
    package { [
        "php${php::package}-pecl-jsonc",
        "php${php::package}-mysqlnd",
        "php${php::package}-opcache",
      ]:
      ensure => present,
      require => Yumrepo['ius'],
    }
  }
  if $php::version =~ /hhvm/ {
    package { [
      "hhvm",
    ]:
    ensure => present,
    require => Yumrepo['hop5'],
    }
    file { '/usr/bin/php':
      ensure => "link",
      target => "/usr/bin/hhvm",
      require => Package["hhvm"],
    }
  }
}

class php::configure {
  file { '/etc/httpd/conf.d/php.conf':
    source => 'puppet:///modules/php/php.conf',
    owner => 'root',
    group => 'root',
    require => Package['httpd'],
    notify => Service['httpd'],
  }

  if 'hhvm' in $php::version {
    file { '/etc/hhvm':
      ensure => directory,
      recurse => true,
      owner => root,
      group => root,
      source => 'puppet:///modules/php/hhvm.d',
      notify => Service['hhvm'],
    }
    file { ['/var/log/hhvm/', '/var/run/hhvm']:
      ensure => directory,
      owner => apache,
      group => apache,
      require => Package['httpd'],
    }
  }
  else {
    file { '/etc/php-fpm.d/www.conf':
      ensure => present,
      content => template('php/www.conf.erb'),
      notify => Service['php-fpm'],
    }

    augeas { 'php.ini':
      context => "/files/etc/php.ini/PHP",
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
}

class php::service {
  $fastcgi_service = $php::version ? {
    /hhvm/ => 'hhvm',
    default => 'php-fpm',
  }

  service { $fastcgi_service:
    enable => true,
    ensure => running,
  }
}

class php ($version = '54', $memory_share = 1.0, $worker_average_memory = 64) {
  $package = $version ? {
    '5.3' => '', # native CentOS packages
    '5.4' => '54',
    '5.5' => '55u',
    'hhvm' => 'hhvm',
  }

  class { 'php::install': }
  class { 'php::configure':
    require => Class['php::install'],
  }
  class { 'php::service':
    require => Class['php::configure'],
  }
}