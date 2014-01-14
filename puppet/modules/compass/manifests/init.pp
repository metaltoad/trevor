class compass {
  package { 'compass':
    ensure => present,
    provider => 'gem',
  }
}