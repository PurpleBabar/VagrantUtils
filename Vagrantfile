Vagrant.configure("2") do |config|
	config.vm.box = "chef/debian-7.4"
	config.vm.provider "virtualbox" do |v|
		v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
		v.memory = 4096
		v.cpus = 2
	end
    config.vm.provision :shell, path: "bootstrap.sh"
	config.vm.synced_folder "./projects/", "/home/vagrant/share/", type: "nfs", mount_options: ['rw', 'vers=3', 'tcp', 'fsc']
	config.vm.synced_folder "./vhosts/", "/etc/apache2/sites-available/", type: "nfs"
	config.vm.network "private_network", ip: "192.168.42.42"
	config.vm.network :forwarded_port, guest: 5672, host: 5672
end
