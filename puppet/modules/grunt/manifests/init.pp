class grunt {
  exec { 'grunt-cli-install':
    command => 'npm install -g grunt-cli',
    path    => ["/usr/bin", "/usr/sbin"],
    creates => '/usr/bin/grunt',
    require => Class['nodejs'],
  }
}