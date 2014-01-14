VAGRANTFILE_API_VERSION = "2"
Vagrant.require_version ">= 1.4.0"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos64-nrel-v20131103"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20131103.box"

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
  end

  config.ssh.forward_agent = true

  config.vm.network :public_network

  config.vm.synced_folder "", "/var/www/sites/default", owner: 48, group: 48, :mount_options => ["dmode=775","fmode=664"]

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
  end

end


# Simple plugin to provide the "vagrant open" command, which launches a web browser.
# Plugins don't noramally belong here, but this one is included to make things a little
# easier for first-time users.
module OpenCommand
  class SshOpenCommand < Vagrant.plugin("2", "command")
    def execute
      opts = OptionParser.new do |o|
        o.banner = "Usage: vagrant open [vm-name]"
        o.separator ""
      end
      argv = parse_options(opts)
      with_target_vms(argv) do |machine|
        uuid = machine.provider.driver.uuid
        machine.config.vm.networks.to_enum.with_index(0).each do |network, i|
          if network[0] == :public_network
            output = machine.provider.driver.execute("guestproperty", "get", uuid, "/VirtualBox/GuestInfo/Net/#{i}/V4/IP")
            if value = output[/^Value: (.+?)$/, 1]
             `open http://#{value}`
            end
          end
        end
      end
      0
    end
  end

  class Plugin < Vagrant.plugin("2")
    name 'Open command'
    command 'open' do
      SshOpenCommand
    end
  end
end
