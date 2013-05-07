module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def running?
          command="vzlist -HN #{self.name} -ostatus"
          shell_results=shell_exec("#{command}",{:mute => true})
          running=shell_results.stdout.split(/\n/).grep(/^running/).size!=0

          env.logger.info("Vm running? #{running}")
          return running
        end

        # Check if box is running
        def exists?

          command="vzctl -aHN #{self.name} -ostatus|wc -l"
          shell_results=shell_exec("#{command}",{:mute => true})
          exists=shell_results.stdout.split(/\n/).grep(/1/).size!=0

          env.logger.info("Vm exists? #{exists}")
          return exists
        end
      end
    end
  end
end
