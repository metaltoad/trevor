class java {
  package { [
      'java-1.7.0-openjdk',
      'java-1.7.0-openjdk-devel',
      'ant',
      'slf4j',
    ]:
    ensure => present,
  }

  file { '/etc/profile.d/java.sh':
    ensure => present,
    content => 'export JAVA_HOME=/etc/alternatives/java_sdk',
    owner => root,
    group => root,
    mode => 644,
  }
}