class compass {
  package { 'compass':
    ensure => present,
    provider => 'gem',
    require => Package['ruby-devel'],
  }
}