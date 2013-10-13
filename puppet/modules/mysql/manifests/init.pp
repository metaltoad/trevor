class mysql::install {
  package { 'mysql':
    ensure => present,
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

class mysql ($memory_share = 1.0, $server_id = '01') {
  class { 'mysql::install': }
  class { 'mysql::configure':
    memory_share  => $memory_share,
    server_id     => $server_id,
  }
}
