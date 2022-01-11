MASTER1      = "172.16.8.4"
MASTER2      = "172.16.8.6"
WORKER1      = "172.16.8.9"
WORKER2      = "172.16.8.13"
WORKER3      = "172.16.8.15"
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.

  config.vm.box = "centos/8"
  boxes = [
    { :name => "master1",  :ip => MASTER1, :cpus => 2, :memory => 2048 },
    { :name => "master2", :ip => MASTER2, :cpus => 2, :memory => 2048 },
    { :name => "worker1",  :ip => WORKER1, :cpus => 2, :memory => 2048 },
    { :name => "worker2", :ip => WORKER2, :cpus => 2, :memory => 2048 },
    { :name => "worker3", :ip => WORKER3, :cpus => 2, :memory => 2048 },
  ]
  boxes.each do |opts|
    config.vm.define opts[:name] do |box|
      box.vm.hostname = opts[:name]
      box.vm.network :private_network, ip: opts[:ip]
 
      box.vm.provider "virtualbox" do |vb|
        vb.cpus = opts[:cpus]
        vb.memory = opts[:memory]
      end
    end
  end
end

