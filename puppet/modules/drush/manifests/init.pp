class drush {
  file { '/usr/local/lib/drush':
    ensure => directory,
    owner => 'root',
    group => 'root',
  }

  exec { 'drush install':
    user => 'root',
    path => "/bin:/sbin:/usr/bin:/usr/sbin",
    cwd => '/usr/local/lib/drush',
    command => 'rm -rf * && curl -L https://api.github.com/repos/drush-ops/drush/tarball/6.0.0 | tar --strip-components 1 -xzf - && ./drush',
    unless => "[ \"`/usr/local/lib/drush/drush --version`\" = ' Drush Version   :  6.0 ' ]",
    require => [File['/usr/local/lib/drush'], Class['php::install']],
  }

  file { '/usr/local/bin/drush':
    ensure => link,
    target => '/usr/local/lib/drush/drush',
    require => Exec['drush install'],
  }
}