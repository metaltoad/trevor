node default {
  ### Base ###
  include base
  include epel
  include ius

  ### LAMP ###
  include apache
  class { 'mysql':
    memory_share => 0.30, # Percentage of RAM used for MySQL
  }
  class { 'mysqld':
    password => 'root',
  }
  mysqld::db::create { 'trevor':
    user => 'trevor',
    password => 'trevor',
  }
  class { 'php53':
    memory_share => 0.65, # Percentage of RAM used for PHP
    worker_average_memory => 100, # estimate average PHP memory, in MB
  }
  class { 'memcached':
    memory_share => 0.05, # Percentage of RAM used for memcached
  }

  ### Developer utilities ###
  include drush
  include capistrano
  include compass
  include nodejs
  include grunt
}