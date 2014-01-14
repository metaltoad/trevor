class capistrano {
  package { 'capistrano':
    ensure => '2.15.5',
    provider => 'gem',
  }
  package { 'capistrano-ext':
    ensure => '1.2.1',
    provider => 'gem',
    require => Package['capistrano'],
  }
}