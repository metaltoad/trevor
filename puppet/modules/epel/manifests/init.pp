class epel {
  yumrepo { 'epel':
    mirrorlist     => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=x86_64",
    failovermethod => 'priority',
    enabled        => '1',
    gpgcheck       => '1',
    gpgkey         => "http://fedoraproject.org/static/0608B895.txt",
    descr          => "Extra Packages for Enterprise Linux 6"
  }
}