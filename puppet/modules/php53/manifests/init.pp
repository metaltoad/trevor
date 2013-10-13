class php53::install {
  package { [
      'php53u',
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

class php53 {
  class { 'php53::install': }
}