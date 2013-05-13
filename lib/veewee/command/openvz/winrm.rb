require 'optparse'

module Veewee
  module Command
    module Openvz
      class Winrm < ::Openvz::Command::Base
        def execute
          options = {}

          opts = OptionParser.new do |opts|
            opts.banner = "Winrm into the basebox"
            opts.separator ""
            opts.separator "Usage: openvz basebox winrm <boxname> <command>"

            opts.on("-d", "--debug", "enable debugging") do |d|
              options['debug'] = d
            end

          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv
          raise ::Openvz::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 1

          begin
            venv=Veewee::Environment.new(options)
            venv.ui=@env.ui
            venv.providers["openvz"].get_box(argv[0]).winrm(argv[1])
          rescue Veewee::Error => ex
            venv.ui.error ex
            exit -1
          end

        end
      end
    end
  end
end
