require 'optparse'

module Veewee
  module Command
    module Openvz
      class Validate < ::Openvz::Command::Base
        def execute
          options = {
            'tags' => %w{openvz puppet chef openvz}
          }

          opts = OptionParser.new do |opts|
            opts.banner = "Validates a box against openvz compliancy rules"
            opts.separator ""
            opts.separator "Usage: openvz basebox validate <boxname>"

            opts.on("-d", "--debug", "enable debugging") do |d|
              options['debug'] = d
            end

            opts.on("-t", "--tags openvz,puppet,chef", Array, "tags to validate") do |t|
              options['tags'] = t
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
            venv.providers["openvz"].get_box(box_name).validate_openvz(options)
          rescue Veewee::Error => ex
            venv.ui.error(ex,:prefix => false)
            exit -1
          end

        end
      end
    end
  end
end
