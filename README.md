# A Vagrant box for Drupal (and other LAMP projects).

This is a Vagrant box built on CentOS 6 and the Puppet provisioner.

### Quick start ###

* Install Vagrant and VirtualBox
* run `vagrant up`
* Place your PHP code in a new directory called `webroot`
* run `vagrant open` to launch a web browser (currently, the `open` command only implemented on OS X)

By default, the virtual machine will use bridged networking, so your VM will need to be able to obtain an IP address via DHCP.  Bridged networking has the advantage of being able to run multiple vagrant boxes simutaneousy, without TCP port conflicts.
See `Vagrantfile` and `puppet/manifests/default.pp` for customization options.

### Main Packages ###

* LAMP
* Choice of PHP version: 5.3, 5.4, 5.5, HHVM
* Choice of MySQL version: 5.1, 5.5
* popular PHP extensions: xml, mcrypt, mbstring, GD, php-imagemagick, etc
* HTTPS support
* postfix
* _TODO: Solr_

### Performance Ready ###

* mod_fastcgi + php-fpm
* Apache Worker MPM
* Zend OPcache (5.5 only)
* APC (<= 5.4 only)
* memcached
* _TODO: Varnish_

### Debugging / developer tools ###

* compass
* drush
* capistrano
* git, svn, bzr, mercurial
* XDebug
* XHProf

### Security features ###

* yum-cron
* iptables
* _TODO: fail2ban_
* _TODO: iptables_

### Using the debug tools ###
XHProf is installed in `/usr/share/pear`.  The web interface is available at `http://example.com/xhprof`.

XDebug has debug, profile, and trace triggers enabled.  To use these triggers, add one of the following queries to your URL:

  * `/?XDEBUG_SESSION_START=idekey` (connects to your debugger on port 9000)
  * `/?XDEBUG_PROFILE` (stores a cachegrind file in /tmp)
  * `/?XDEBUG_TRACE` (stores a trace file in /tmp)

### Future goals ###

* A development / production switch.  This will be important when e.g. XDebug is added in the future.
* Optional support for Apache virtualhosts (the choice to omit this currently is intentional, since the intent is a dedicated vagrant box per project, but vhosts may be needed someday).
* Automatic updates to host OS's /etc/hosts file, so that sites don't have to be accessed via IP.

### Adding Trevor as a Git submodule ###

We have found Trevor works well as a Git submodule.  To add the submodule and some symbolic links to the top of your repository, follow these steps:

    git submodule add git@github.com:metaltoad/trevor.git
    ln -s trevor/Vagrantfile .
    ln -s trevor/puppet .
    git add Vagrantfile puppet
    git commit

Note that symlinks won't work if you have collaborators using Windows.