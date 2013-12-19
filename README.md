# An experimental Vagrant box for Drupal.

A work in progress, many items listed below are unimplemented.

### Main Packages ###

* LAMP
* php-fpm, apc
* popular PHP extensions: xml, GD, mcrypt, mbstring, php-imagemagick
* imagemagick
* memcached
* compass
* drush
* capistrano
* vim,nano
* https
* git,svn,bzr,mercurial
* yum-cron
* iptables

### Production / local options ###
* fail2ban
* postfix
* iptables
* XDebug / webgrind

### Other options ###
* Extra Apache virtualhosts (maybe not desirable, since each project or repo can have its own Vagrant box)
* configurable system RAM
* configurable PHP version
* Solr

### Convenionce goals ###

These things should be easy:

* bridge host tools like Drush / SequelPro to VM guest
* drush sql-sync / cap db:pull should work on host or guest
* Possibly sync the host user's SSH keys? (Or maybe vagrant will take care of ssh agent forwarding for us)

### Sticky problems to solve ###

* How can we make it easy to go from command line to browser? (not ssh -> ifconfig -> copy+paste to browser)
* How can we support multisites that need multiple host file alises?
