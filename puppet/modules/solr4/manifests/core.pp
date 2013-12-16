define solr4::core ($conf_source = '') {
  $version = $solr4::version

  if ($conf_source == '') {
    $sources = ["/usr/src/solr/solr-${$version}/example/solr/collection1/conf"]
  }
  else {
    $sources = [
      $conf_source,
      "/usr/src/solr/solr-${$version}/example/solr/collection1/conf"
    ]
  }

  file { "/var/lib/solr/${name}":
    ensure => directory,
    owner => 'tomcat',
    group => 'tomcat',
  }

  file { "/var/lib/solr/${name}/core.properties":
    content => "name=${name}",
    owner => 'tomcat',
    group => 'tomcat',
  }

  file { "/var/lib/solr/${name}/conf":
    ensure => directory,
    recurse => true,
    sourceselect => all,
    source => $sources,
    owner => 'tomcat',
    group => 'tomcat',
  }
}