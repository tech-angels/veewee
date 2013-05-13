module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def build(options)
          if definition.nil?
            raise Veewee::Error,"Could not find the definition. Make sure you are one level above the definitions directory when you execute the build command."
          end

          # Remove iso related methods
          def definition.verify_iso(options) end
          # Remove kickstart
          def handle_kickstart(optiond) end
          
          super(options)
        end

      end
    end
  end
end
