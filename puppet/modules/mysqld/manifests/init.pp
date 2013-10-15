class mysqld::install {
  package { 'mysql-server' :
    ensure  => present,
    require => Class[ 'mysql::configure' ], # make sure my.cnf file exists so ib_logfile0 is the right size
  }
}

class mysqld::service {
  service { 'mysqld':
    enable => true,
    ensure => running,
    require => Class['mysql', 'mysqld::install'],
    subscribe => File['/etc/my.cnf'],
  }
}

class mysqld::configure ($password = 'root') {
  exec { 'Set MySQL server root password':
    unless  => "mysqladmin -uroot -p${password} status",
    path    => '/bin:/usr/bin',
    command => "mysqladmin -uroot password ${password}",
    require => Class [ 'mysqld::service' ],
  }
}

class mysqld ($password = 'root') {
  class { 'mysqld::install': }
  class { 'mysqld::service': }
  class { 'mysqld::configure':
    password => $password,
  }
}
