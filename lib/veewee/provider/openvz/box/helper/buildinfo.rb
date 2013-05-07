module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def build_info
          info=super
          command="vzctl --version"
          output=IO.popen("#{command}").readlines
          info << {:filename => ".vzctl_version",:content => output[0].split(/ /)[2]}
        end

      end
    end
  end
end
