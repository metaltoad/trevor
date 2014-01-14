class nodejs {
  package { ['nodejs', 'npm']:
    ensure => present,
  }
}