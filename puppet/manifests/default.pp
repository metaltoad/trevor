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
    memory_share => 0.65, # Percentage of RAM used for PHP
    worker_average_memory => 100, # estimate average PHP memory, in MB
  }
  class { 'memcached':
    memory_share => 0.05, # Percentage of RAM used for memcached
  }

  include java
  include tomcat
  solr4::core { 'trevor':
    conf_source => '/var/www/sites/default/solr', # a directory containing schema.xml, plus any other Solr files
  }
  include solr4
}