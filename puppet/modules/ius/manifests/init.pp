class ius {
  yumrepo { 'ius':
    baseurl => 'http://dl.iuscommunity.org/pub/ius/stable/CentOS/6/x86_64/',
    descr => "IUS Community repository",
    enabled => 1,
    gpgkey => 'http://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY',
    gpgcheck => 1,
    require => Yumrepo['epel'],
  }

  package { 'yum-plugin-replace':
    ensure => present,
  }
}