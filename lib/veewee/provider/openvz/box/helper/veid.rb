module Veewee
  module Provider
    module Openvz
      module BoxCommand

        # Get the VEID address of the box
        def veid
          command="vzlist -aHN '#{self.name}' -oveid "
          shell_exec("#{command}").stdout.strip
        end

      end
    end
  end
end
