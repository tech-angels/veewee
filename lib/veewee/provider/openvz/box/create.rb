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

        def openvz_template(type_id)
          env.logger.info "Translating #{type_id} into openvz template"
          openvz_template=env.ostypes[type_id][:openvz]
          env.logger.info "Found Openvz template #{openvz_template}"
          return openvz_template
        end

        def get_free_veid
          veid=`vzlist -aHoveid`.split.sort.last || 1000).to_i + 1
          env.logger.info "Using new VEID #{veid}"
          return veid
        end

        def create_vm
          openvz_definition=definition.dup
          template=openvz_template(definition.os_type_id)

          # Create the vm
          self.veid=get_free_veid()
          command="vzctl create #{self.veid} --ostemplate #{template}"
          shell_exec("#{command}")

          command="vzctl set #{self.veid} --name '#{self.name}' --cpus #{definition.cpu_count} --save"
          shell_exec("#{command}")

          command="vzctl set #{self.name} --name '#{self.name}' --memsize #{definition.memory_size}M --save"
          shell_exec("#{command}")

          command="vzctl set #{self.name} --netif_add eth0 --save"
          shell_exec("#{command}")
        end

      end
    end
  end
end
