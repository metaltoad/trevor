class apache::install {
  file { '/usr/src/redhat/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm':
    ensure => present,
    owner => root,
    group => root,
    source => 'puppet:///modules/apache/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm',
    mode => 664,
  }
  package { ['httpd', 'mod_ssl']:
    ensure => present,
  }
  package { 'mod_fastcgi':
    ensure => present,
    provider => 'rpm',
    source => '/usr/src/redhat/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm',
    require => [File['/usr/src/redhat/RPMS/mod_fastcgi-2.4.6-2.el6.rf.x86_64.rpm'], Package['httpd']],
  }
  file { '/var/www/sites':
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    require => Package['httpd'],
  }
}

class apache::config {
  file { '/etc/httpd/conf.d':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/apache/conf.d',
    owner => 'root',
    group => 'root',
    require => Package['httpd'],
    notify => Service['httpd'],
  }

  augeas { 'apache-worker':
    changes => [
      'set /files/etc/sysconfig/httpd/HTTPD "/usr/sbin/httpd.worker"',
    ],
    lens => 'Shellvars.lns',
    incl => '/etc/sysconfig/httpd',
    require => Package['httpd'],
    notify => Service['httpd'],
  }

  augeas { 'httpd.conf':
    context => '/files/etc/httpd/conf/httpd.conf',
    require => Package['httpd'],
    notify => Service['httpd'],
    changes => [
      "set directive[. = 'ServerTokens'] ServerTokens",
      "set *[self::directive='ServerTokens']/arg 'Prod'",
      "set directive[. = 'ServerSignature'] ServerSignature",
      "set *[self::directive='ServerSignature']/arg 'Off'",
      "set directive[. = 'EnableSendfile'] EnableSendfile",
      "set *[self::directive='EnableSendfile']/arg 'Off'",
    ],
  }

  # Use ciphers reccomended by https://wiki.mozilla.org/Security/Server_Side_TLS
  augeas { 'httpd-ssl':
    context => '/files/etc/httpd/conf.d/ssl.conf/VirtualHost',
    require => Package['httpd'],
    notify => Service['httpd'],
    changes => [
      "set directive[. = 'SSLProtocol'] SSLProtocol",
      "set *[self::directive='SSLProtocol']/arg 'all -SSLv2'",

      "set directive[. = 'SSLHonorCipherOrder'] SSLHonorCipherOrder",
      "set *[self::directive='SSLHonorCipherOrder']/arg 'on'",

      "set directive[. = 'SSLCipherSuite'] SSLCipherSuite",
      "set *[self::directive='SSLCipherSuite']/arg 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-RSA-RC4-SHA:ECDHE-ECDSA-RC4-SHA:AES128:AES256:RC4-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK'",
    ],
  }
}

class apache::service {
  service { 'httpd':
    enable => true,
    ensure => running,
    require => Package['httpd'],
  }
}

class apache {
  class { 'apache::install': }
  class { 'apache::config': }
  class { 'apache::service': }
}