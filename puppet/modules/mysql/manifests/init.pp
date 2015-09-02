class mysql::install {
  package { "mysql${mysql::package}" :
    ensure => present,
    require => Yumrepo['ius'],
  }

  if mysql::package {
    # Package resource doesn't support "yum replace", need to do this the hard way
    # This is because a few core CentOS packages depend on the MySQL client
    exec { "mysql replace" :
      user => 'root',
      path => "/bin:/sbin:/usr/bin:/usr/sbin",
      command => "yum -y install mysql && yum -y replace mysql --replace-with mysql${mysql::package}",
      unless => "yum list installed mysql${mysql::package}",
      before => Package["mysql${mysql::package}"],
    }
  }
}

class mysql::configure (
  $memory_share,
  $server_id,
) {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class [ 'mysql::install' ]
  }
  file { '/etc/my.cnf':
    ensure    => file,
    content   => template("mysql/my.cnf.erb"),
  }
}

class mysql ($memory_share = 1.0, $server_id = '01', $version = '5.5') {
  $package = $version ? {
    '5.1' => '', # native CentOS packages
    '5.5' => '55', # IUS
  }
  class { 'mysql::install': }
  class { 'mysql::configure':
    memory_share  => $memory_share,
    server_id     => $server_id,
  }
}
