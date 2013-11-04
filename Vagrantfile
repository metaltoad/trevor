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




module OpenCommand
  class SshOpenCommand < Vagrant.plugin("2", "command")
    # If you need to use initialize, call super afterwards and pass in the
    # same arguments.
    # This is generally used for Actions rather than Commands. Actions act like
    # middleware so you need to store the second arg to pass control to the next
    # action in the chain.
    def initialize(*args)
      super(*args)
    end

    def execute
      # Not needed here unless you want to control which network interface to use?
      # @address ||= (network_parameters && network_parameters.first)
      # puts @vm.inspect
      # opts = OptionParser.new do |opts|
      #   opts.banner = "Usage: vagrant open [vm-name]"
      #   opts.separator ""
      # end

      # parse_options doesn't need to take anything to work. If you do have opts
      # from OptionParser, pass them in here.
      argv = parse_options()

      # Pass the parsed args into with_target_vms
      with_target_vms(argv) do |vm|
        # We can abuse backticks, but we still have two ips so not sure what to do there.
        ips = `vagrant ssh -c 'ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk -F " " "{print \\\$1,\\\$2}" | awk -F "inet addr:" "{print \\\$2}"'`
        `open http://#{ips.split("\n")[0]}`
        `open http://#{ips.split("\n")[1]}`

        # This works, but vm.action outputs to stdout and returns the env, not the status. :(
        # env = vm.action(:ssh_run, :ssh_run_command => 'ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk -F " " "{print \$1,\$2}" | awk -F "inet addr:" "{print \$2}"')
        # require 'pp'
        # pp env.sort
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





