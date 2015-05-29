class capistrano {
  
package { [
  'highline',
  'net-ssh',
  'net-sftp',
  'net-scp',
  'net-ssh-gateway'
  ]:
    provider => 'gem',
    install_options => ["-f"],
    notify => Package['capistrano'],
  }

  package { 'capistrano':
    ensure => '2.15.5',
    provider => 'gem',
    install_options => ["-f"],    
  }
 
  package { 'capistrano-ext':
    ensure => '1.2.1',
    provider => 'gem',
    require => Package['capistrano'],
    install_options => ["-f"],
  }
}