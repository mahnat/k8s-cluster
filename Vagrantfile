
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/mantic64"
  config.vm.define "master" do | w |
  w.vm.hostname = "master"
  w.vm.network "private_network", ip: "192.168.33.10"
  w.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.name = "master"
  end
  w.vm.provision "setup-hosts", :type => "shell", :path => "k8s-setup-master.sh" do |s|
  end
  w.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y git wget vim curl
    sudo reboot
   SHELL
  end

  config.vm.box = "ubuntu/mantic64"
  config.vm.define "worker-1" do | w |
      w.vm.hostname = "worker-1"
      w.vm.network "private_network", ip: "192.168.33.11"

      w.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 2
        vb.name = "worker-1"
      end
      w.vm.provision "setup-hosts", :type => "shell", :path => "k8s-setup-master.sh" do |s|
    end
   w.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y git wget vim
     sudo reboot
   SHELL
  end 
  config.vm.box = "ubuntu/mantic64"
  config.vm.define "worker-2" do | w |
      w.vm.hostname = "worker-2"
      w.vm.network "private_network", ip: "192.168.33.12"

      w.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 1
        vb.name = "worker-2"
      end
        w.vm.provision "setup-hosts", :type => "shell", :path => "k8s-setup-master.sh" do |s|
  end
   w.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y git wget vim curl
     sudo reboot
   SHELL
  end  
  config.vm.box = "ubuntu/mantic64"
  config.vm.define "worker-3" do | w |
      w.vm.hostname = "worker-3"
      w.vm.network "private_network", ip: "192.168.33.13"

      w.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.cpus = 1
        vb.name = "worker-3"
      end
        w.vm.provision "setup-hosts", :type => "shell", :path => "k8s-setup-master.sh" do |s|
  end
   w.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y git wget vim curl
     sudo reboot
   SHELL
  end  
end
