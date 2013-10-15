node default {
  include base
  include epel
  include ius
  include php53
  include apache
  class { 'mysql':
    memory_share => 0.3,
  }
  class { 'mysqld':
    password => 'root',
  }
}