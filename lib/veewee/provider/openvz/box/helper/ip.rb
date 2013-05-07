module Veewee
  module Provider
    module Openvz
      module BoxCommand

        # Get the IP address of the box
        def ip_address
          mac=mac_address
          command="vzctl exec #{self.name} ip addr show dev eth0|grep 'inet '|awk '{print $2}'|cut -d/ -f1"
          ip=shell_exec("#{command}").stdout.strip.downcase
          return ip
        end

        def mac_address
          command="vzctl exec #{self.name} ip link show dev eth0|grep "ether "|awk '{print $2}'"
          mac=shell_exec("#{command}").stdout.strip.downcase
          return mac
        end

      end
    end
  end
end
