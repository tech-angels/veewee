module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def halt(options={})
          unless self.exists?
            raise Veewee::Error, "Error:: You tried to halt a non-existing box '#{name}'"
          end

          command="vzctl stop '#{self.name}'"
          shell_exec("#{command}")
        end

      end
    end
  end
end
