module Veewee
  module Provider
    module Openvz
      module BoxCommand

        # Get the IP address of the box
        def ip_address
	  (1..10).each do |_|
            command="vzctl exec '#{self.name}' ip addr show dev eth0|grep 'inet '|awk '{print $2}'|cut -d/ -f1 "
            ip=shell_exec("#{command}").stdout.strip.downcase
            return ip if ip != ''
            # Wait for IP to become available
            puts "Waiting for VM to get its IP"
            sleep 3
          end
        end

      end
    end
  end
end
