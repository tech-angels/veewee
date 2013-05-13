module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def validate_openvz(options)
          validate_tags([ 'openvz','puppet','chef'],options)
        end
      end #Module

    end #Module
  end #Module
end #Module
