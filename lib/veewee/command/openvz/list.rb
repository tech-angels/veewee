require 'optparse'

module Veewee
  module Command
    module Openvz
      class List < ::Openvz::Command::Base
        def execute
          options = {}

          opts = OptionParser.new do |opts|
            opts.banner = "List all defined boxes"
            opts.separator ""
            opts.separator "Usage: openvz basebox list"
            opts.on("-d", "--debug", "enable debugging") do |d|
              options['debug'] = d
            end
          end

          # Parse the options
          argv = parse_options(opts)

          return if !argv

          begin
            venv=Veewee::Environment.new(options)
            venv.ui = @env.ui
            venv.definitions.each do |name,definition|
              venv.ui.info("- #{name}", :prefix => false)
            end
          rescue Veewee::Error => ex
            venv.ui.error(ex,:prefix => false)
            exit -1
          end
        end
      end
    end
  end
end
