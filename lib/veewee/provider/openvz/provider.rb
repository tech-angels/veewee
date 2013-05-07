require 'veewee/provider/core/provider'

module Veewee
  module Provider
    module Openvz
      class Provider < Veewee::Provider::Core::Provider

        def check_requirements
          unless self.shell_exec("vzctl --version").status == 0
            raise Veewee::Error,"Could not execute vzctl command. Please install Openvz or make sure vzctl is in the Path"
          end
        end


      end #End Class
    end # End Module
  end # End Module
end # End Module
