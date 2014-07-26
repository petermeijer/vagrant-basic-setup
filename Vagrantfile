Vagrant.configure("2") do |config|
	
	# Specify the base box
	config.vm.box = "ubuntu/trusty64"
	
	# Setup port forwarding
	config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true

    # Setup synced folder
    config.vm.synced_folder "site", "/var/www", create: true, group: "www-data", owner: "www-data"

    # VM specific configs
    config.vm.provider "virtualbox" do |v|
    	v.name = "Ubuntu 14.04 x64"
    	v.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2", "--ioapic", "on"]
    end

    # Shell provisioning
    config.vm.provision "shell" do |s|
    	s.path = "provision/setup.sh"
    end
end