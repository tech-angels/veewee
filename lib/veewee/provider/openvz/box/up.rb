module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def up(options={})
          command="vzctl start '#{self.name}'"
          shell_exec("#{command}")
        end

      end
    end
  end
end
