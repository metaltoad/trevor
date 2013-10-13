class apache::install {
  package { 'httpd':
    ensure => present,
  }
}

class apache::config {

}

class apache::service {
  service { 'httpd':
    ensure => running,
    require => Package['httpd'],
  }
}

class apache {
  class { 'apache::install': }
  class { 'apache::config': }
  class { 'apache::service': }
}