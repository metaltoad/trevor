class hop5 {
  yumrepo { 'hop5':
    baseurl => 'http://www.hop5.in/yum/el6/',
    descr => "hop5 repository",
    enabled => 1,
    gpgkey => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-HOP5',
    gpgcheck => 0,
    require => Yumrepo['epel'],
  }
}