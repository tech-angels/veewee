require 'optparse'

module Veewee
  module Command
    module Openvz
      class Export < ::Openvz::Command::Base
        def execute
          options = {}

          opts = OptionParser.new do |opts|
            opts.banner = "Exports basebox to the openvz template format"
            opts.separator ""
            opts.separator "Usage: openvz basebox export <boxname>"

            opts.on("-d", "--debug", "enable debugging") do |d|
              options['debug'] = d
            end

            opts.on("-f", "--force", "force overwrite") do |f|
              options['force'] = f
            end

            opts.on("-i", "--include [FILE]", "include") do |f|
                options['include'] << f
            end

          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv
          raise ::Openvz::Errors::CLIInvalidUsage, :help => opts.help.chomp if argv.length < 1

          begin
            venv=Veewee::Environment.new(options)
            venv.ui=@env.ui
            box_name=argv[0]
            venv.providers["openvz"].get_box(box_name).export_openvz(options)
          rescue Veewee::Error => ex
            venv.ui.error(ex,:prefix => false)
            exit -1
          end

        end
      end
    end
  end
end
