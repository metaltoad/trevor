node default {
  include base
  include epel
  include ius
  include drush
  include apache
  class { 'mysql':
    memory_share => 0.30, # Percentage of RAM used for MySQL
  }
  class { 'mysqld':
    password => 'root',
  }
  class { 'php53':
    memory_share => 0.70, # Percentage of RAM used for PHP
    worker_average_memory => 64, # estimate average PHP memory, in MB
  }
}