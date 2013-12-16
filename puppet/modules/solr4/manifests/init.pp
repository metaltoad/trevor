class solr4::install {
  $version = $solr4::version
  $catalina_home = '/usr/share/tomcat6'

  file { '/var/lib/solr':
    ensure => directory,
    owner => 'tomcat',
    group => 'tomcat',
  }

  file { '/usr/src/solr':
    ensure => directory,
  }

  exec { 'solr-download':
    command => "/usr/bin/curl https://archive.apache.org/dist/lucene/solr/${version}/solr-${version}.tgz | tar -xzf -",
    cwd => '/usr/src/solr',
    require => File['/usr/src/solr'],
    creates => "/usr/src/solr/solr-${version}",
  }

  file { '/var/lib/solr/solr.war':
    source => "/usr/src/solr/solr-${version}/dist/solr-${version}.war",
    notify => Service['tomcat6'],
    owner => 'tomcat',
    group => 'tomcat',
    require => Exec['solr-download'],
  }

  file { '/etc/tomcat6/Catalina/localhost/solr.xml':
    source => 'puppet:///modules/solr4/context.xml',
    mode => 0644,
    notify => Service['tomcat6'],
  }

  file { '/var/lib/solr/solr.xml':
    content => template('solr4/solr.xml.erb'),
  }

  file { "$catalina_home/lib/log4j-over-slf4j.jar":
    ensure => link,
    target => '/usr/share/java/slf4j/log4j-over-slf4j.jar',
  }
  file { "$catalina_home/lib/slf4j-api.jar":
    ensure => link,
    target => '/usr/share/java/slf4j/api.jar',
  }
  file { "$catalina_home/lib/slf4j-log4j12.jar":
    ensure => link,
    target => '/usr/share/java/slf4j/log4j12.jar',
  }
  file { "$catalina_home/lib/commons-logging.jar":
    ensure => link,
    target => '/usr/share/java/commons-logging.jar',
  }

  file { "$catalina_home/lib/log4j.properties":
    source => 'puppet:///modules/solr4/log4j.properties',
    owner => 'tomcat',
    group => 'tomcat',
  }

  file { '/var/log/solr':
    ensure => directory,
    owner => 'tomcat',
    group => 'tomcat',
    before => Service['tomcat6'],
  }

}

class solr4 {
  $version = '4.4.0'
  class { 'solr4::install':
    require => Package['tomcat6'],
  }
}

Solr4::Core <| |> -> Class['solr4']
