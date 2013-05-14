require 'veewee'
require 'optparse'
require 'veewee/command/openvz/ostypes'
require 'veewee/command/openvz/templates'
require 'veewee/command/openvz/list'
require 'veewee/command/openvz/build'
require 'veewee/command/openvz/destroy'
require 'veewee/command/openvz/up'
require 'veewee/command/openvz/halt'
require 'veewee/command/openvz/ssh'
require 'veewee/command/openvz/winrm'
require 'veewee/command/openvz/define'
require 'veewee/command/openvz/undefine'
require 'veewee/command/openvz/validate'
require 'veewee/command/openvz/export'
require 'veewee/command/openvz/screenshot'


module Veewee
  module Command
    module Openvz
      class Basebox < ::Openvz::Command::Base
        def initialize(argv,env)
          super

          @main_args, @sub_command, @sub_args = split_main_and_subcommand(argv)

          @subcommands = ::Openvz::Registry.new
          @subcommands.register(:ostypes)    { Veewee::Command::Openvz::Ostypes }
          @subcommands.register(:templates)    { Veewee::Command::Openvz::Templates }
          @subcommands.register(:list)    { Veewee::Command::Openvz::List }
          @subcommands.register(:build)    { Veewee::Command::Openvz::Build }
          @subcommands.register(:destroy)    { Veewee::Command::Openvz::Destroy }
          @subcommands.register(:up)    { Veewee::Command::Openvz::Up }
          @subcommands.register(:halt)    { Veewee::Command::Openvz::Halt }
          @subcommands.register(:ssh)    { Veewee::Command::Openvz::Ssh }
          @subcommands.register(:define)    { Veewee::Command::Openvz::Define }
          @subcommands.register(:undefine)    { Veewee::Command::Openvz::Undefine }
          @subcommands.register(:export)    { Veewee::Command::Openvz::Export }
          @subcommands.register(:validate)    { Veewee::Command::Openvz::Validate }

          @subcommands.

        end


        def execute
          if @main_args.include?("-h") || @main_args.include?("--help")
            # Print the help for all the box commands.
            return help
          end

          # If we reached this far then we must have a subcommand. If not,
          # then we also just print the help and exit.
          command_class = @subcommands.get(@sub_command.to_sym) if @sub_command
          return help if !command_class || !@sub_command
          @logger.debug("Invoking command class: #{command_class} #{@sub_args.inspect}")

          # Initialize and execute the command class
          command_class.new(@sub_args, @env).execute
        end

        # Prints the help out for this command
        def help
          opts = OptionParser.new do |opts|
            opts.banner = "Usage: openvz basebox <command> [<args>]"
            opts.separator ""
            opts.separator "Available subcommands:"

            # Add the available subcommands as separators in order to print them
            # out as well.
            keys = []
            @subcommands.each { |key, value| keys << key.to_s }

            keys.sort.each do |key|
              opts.separator "     #{key}"
            end

            opts.separator ""
            opts.separator "For help on any individual command run `openvz basebox COMMAND -h`"
          end

          @env.ui.info(opts.help, :prefix => false)
        end
      end
    end
  end
end
