define mysqld::db::create (
  $user,
  $password,
  $grant = 'all',
  $host = 'localhost',
) {
  if ($::mysql_is_slave != undef) {
    if (str2bool($::mysql_is_slave)  == true) {
        $mysql_is_slave = true
    } else {
        $mysql_is_slave = false
    }
  } else {
        $mysql_is_slave = false
  }
  if $mysql_is_slave == false {
    exec { "create-${name}-db" :
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -p${mysqld::configure::password} -e \"create database \\`${name}\\`; grant ${grant} on \\`${name}\\`.* to '${user}'@'${host}' identified by '${password}'; grant ${grant} on \\`${name}\\`.* to '${user}'@'localhost' identified by '${password}';\"",
      unless  => "mysql -u${user} -p${password} ${name}",
      require => Class [ 'mysqld::configure' ],
    }
    if $host != 'localhost' {
      exec { "add-network-access-${name}-db-${host}" :
        path    => '/bin:/usr/bin',
        command => "mysql -uroot -p${mysqld::configure::password} -e \"grant ${grant} on \\`${name}\\`.* to '${user}'@'${host}' identified by '${password}';\"",
        unless  => "mysql -uroot -p${mysqld::configure::password} -e \"select user,host from mysql.user;\" | grep ${name} | grep ${host}",
        require => Exec [ "create-${name}-db" ],
      }
    }
  }
}

define mysqld::db::create_schema (
  $user,
  $password,
  $addl_commands = '',
  $grant = 'select',
  $all = false,
  $restrictions = '',
  $host = 'localhost',
) {
  if ($::mysql_is_slave != undef) {
    if (str2bool($::mysql_is_slave)  == true) {
        $mysql_is_slave = true
    } else {
        $mysql_is_slave = false
    }
  } else {
    $mysql_is_slave = false
  }
  if $mysql_is_slave == false {
    exec { "create-${name}-schema" :
      path    => '/bin:/usr/bin',
      command => "mysql -uroot -p${mysqld::configure::password} -e \"create schema \\`${name}\\`; use \\`${name}\\`; ${$addl_commands} grant ${grant} on \\`${name}\\`.* to '${user}'@'${host}' identified by '${password}' ${restrictions};\"",
      unless  => "mysql -u${user} -p${password} ${name}",
      require => Class [ 'mysqld::service' ],
    }
  }
}

define mysqld::db::grant_special (
  $user,
  $password,
  $grant = 'select',
  $tables = '*',
  $restrictions = '',
  $host = 'localhost',
) {
  exec { "grant-special-${name}" :
    path    => '/bin:/usr/bin',
    command => "mysql -uroot -p${mysqld::configure::password} -e \"grant ${grant} on ${tables}.* to '${user}'@'${host}' identified by '${password}' ${restrictions};\"",
    unless  => "mysqladmin -u${user} -p${password} status",
    require => Class [ 'mysqld::service' ],
  }
}

class mysqld::db {}
