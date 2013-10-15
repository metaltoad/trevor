VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The inital package update can take a long time,
  # increase vagrant's patience for long builds.
  config.ssh.max_tries = 100
  config.ssh.timeout   = 2400

  config.vm.box = "centos6"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.network :public_network

  config.vm.synced_folder "", "/var/www/sites/default", owner: "apache", group: "apache"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
  end

end