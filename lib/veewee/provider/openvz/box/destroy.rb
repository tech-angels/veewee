module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def destroy(options={})
          unless self.exists?
            raise Veewee::Error, "Error:: You tried to destroy a non-existing box '#{name}'"
          end

          if self.running?
            self.poweroff
            sleep 2
          end

          command="vzctl destroy '#{self.name}'"
          shell_exec("#{command}")

        end
      end
    end
  end
end
