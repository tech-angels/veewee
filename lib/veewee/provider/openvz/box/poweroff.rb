module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def poweroff(options={})
          self.halt
        end

      end
    end
  end
end
