class tomcat::install {
  package { ['tomcat6']:
    ensure => present,
    require => Class['java'],
  }
}

class tomcat::configure {
}

class tomcat::service {
  service { 'tomcat6':
    ensure => running,
    enable => true,
    require => Class[tomcat::configure],
  }
}

class tomcat {
  class { 'tomcat::install' : }
  class { 'tomcat::configure' : }
  class { 'tomcat::service' : }
}