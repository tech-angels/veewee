require 'open-uri'

module Veewee
  module Provider
    module Openvz
      module BoxCommand

        # When we create a new box
        # We assume the box is not running
        def create(options)
          create_vm
          create_disk
          #self.create_floppy("virtualfloppy.img")
        end


        def create_disk
        end

        def debian_distribution?
          env.ostypes[definition.os_type_id][:openvz] =~ /^(debian|ubuntu)/
        end

        def openvz_template(type_id)
          env.logger.info "Translating #{type_id} into openvz template"
          openvz_template=env.ostypes[type_id][:openvz]
          env.logger.info "Found Openvz template #{openvz_template}"
          return openvz_template
        end

        def get_free_veid
          veid=(`vzlist -aHoveid`.split.sort.last || 1000).to_i + 1
          env.logger.info "Using new VEID #{veid}"
          return veid
        end

        def create_vm
          if exists? then
            halt
            destroy
          end

          openvz_definition=definition.dup
          template=openvz_template(definition.os_type_id)

          # Create the vm
          new_veid=get_free_veid()
          command="vzctl create #{new_veid} --ostemplate #{template}"
          shell_exec("#{command}")

          command="vzctl set #{new_veid} --name '#{self.name}' --cpus #{definition.cpu_count} --save"
          shell_exec("#{command}")

          # Compute number of 4kb pages needed. definition.memory_size is in Megabytes
          nbpages = definition.memory_size.to_i * 256 #  1024 * 1024 / 4096
          command="vzctl set '#{self.name}' --vmguarpages #{nbpages} --oomguarpages #{nbpages} --privvmpages #{nbpages}:#{(nbpages*1.1).to_i} --save"
          shell_exec("#{command}")

          # Start the VM
          up

          # Install vagrant user
          command="vzctl exec '#{self.name}' 'groupadd vagrant && useradd vagrant -g vagrant && echo vagrant:vagrant|chpasswd && mkdir -p /home/vagrant/.ssh && chown vagrant.vagrant -R /home/vagrant && echo \"vagrant ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers'"
          shell_exec("#{command}")

          # Install vagrant public SSH key
          vagrant_key = open('https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub').read
          File.open("/var/lib/vz/private/#{new_veid}/home/vagrant/.ssh/authorized_keys", 'w') { |f| f.write(vagrant_key) }

          command="vzctl set '#{self.name}' --netif_add eth0,,,,br0 --save"
          shell_exec("#{command}")

          # Set up networking
          networking_interfaces = <<"END"
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
END
          File.open("/var/lib/vz/private/#{new_veid}/etc/network/interfaces", 'w') { |f| f.write(networking_interfaces) }

          # Restart the VM to be sure networking starts correctly
          halt
          up
          sleep(10)

          if debian_distribution? then
            # Upgrade packages
            shell_exec("vzctl exec '#{self.name}' 'apt-get update'")
            shell_exec("vzctl exec '#{self.name}' 'export DEBIAN_FRONTEND=noninteractive && yes | apt-get dist-upgrade'")

            # Configure locale
            command="vzctl exec '#{self.name}' 'locale-gen --purge en_US.UTF-8'"
            shell_exec("#{command}")
            File.open("/var/lib/vz/private/#{new_veid}/etc/default/locale", "w") { |f| f.write("LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"\n") }
          
            # Install NTP
            command="vzctl exec '#{self.name}' 'export DEBIAN_FRONTEND=noninteractive && yes | apt-get install ntp'"
            shell_exec("#{command}")
          end 

          halt
        end

      end
    end
  end
end