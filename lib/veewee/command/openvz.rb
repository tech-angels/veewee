module Veewee
  module Command
    class Openvz< Veewee::Command::GroupBase

      register :command => "openvz",
               :description => "Subcommand for Openvz",
               :provider => "openvz"

      desc "build [BOX_NAME]", "Build box"
      # TODO move common build options into array
      method_option :force,:type => :boolean , :default => false, :aliases => "-f", :desc => "force the build"
      method_option :auto,:type => :boolean , :default => false, :aliases => "-a", :desc => "auto answers"
      method_option :checksum , :type => :boolean , :default => false, :desc => "verify checksum"
      method_option :postinstall_include, :type => :array, :default => [], :aliases => "-i", :desc => "ruby regexp of postinstall filenames to additionally include"
      method_option :postinstall_exclude, :type => :array, :default => [], :aliases => "-e", :desc => "ruby regexp of postinstall filenames to exclude"
      def build(box_name)
        box(box_name).build(options)
      end

      desc "export [BOX_NAME]", "Exports the basebox to the Openvz template format"
      method_option :debug,:type => :boolean , :default => false, :aliases => "-d", :desc => "enable debugging"
      method_option :force,:type => :boolean , :default => false, :aliases => "-f", :desc => "overwrite existing file"
      def export(box_name)
       box(box_name).export_openvz(options)
      end


      desc "validate [BOX_NAME]", "Validates a box against openvz compliancy rules"
      method_option :tags,:type => :array, :default => %w{openvz puppet chef}, :aliases => "-t", :desc => "tags to validate"
      def validate(box_name)
        box(box_name).validate_openvz(options)
      end
    end
  end
end
