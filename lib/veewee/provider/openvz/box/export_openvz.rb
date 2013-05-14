require 'pathname'
module Veewee
  module Provider
    module Openvz
      module BoxCommand

        def export_openvz(options)

          # Check if box already exists
          unless self.exists?
            ui.info "#{name} is not found, maybe you need to build it first?"
            exit
          end

          if File.exists?("#{name}.tar")
            if options["force"]
              env.logger.debug("#{name}.tar exists, but --force was provided")
              env.logger.debug("removing #{name}.tar first")
              FileUtils.rm("#{name}.tar")
              env.logger.debug("#{name}.tar removed")
            else
              raise Veewee::Error, "export file #{name}.tar already exists. Use --force option to overwrite."
            end
          end


          # We need to shutdown first
          if self.running?
            ui.info "Shutting down the box now."

            self.halt

            ui.info "Machine #{name} is powered off cleanly"
          end

          #4.0.x. not using boxes as a subdir
          openvz_template_dir=Pathname.new(Dir.pwd)

          full_path=File.join(openvz_template_dir,name+".tar")
          path1=Pathname.new(full_path)
          path2=Pathname.new(Dir.pwd)
          box_path=File.expand_path(path1.relative_path_from(path2).to_s)

          if File.exists?("#{box_path}")
            raise Veewee::Error, "box #{name}.tar already exists"
          end

          # Create temp directory
          current_dir = FileUtils.pwd
          ui.info "Creating a temporary directory for export"

          begin

            ui.info "Exporting the box"
            command = "vzdump --dumpdir #{Dir.getwd} #{self.veid}"
            env.logger.debug("Command: #{command}")
            shell_exec(command, {:mute => false})

          rescue Errno::ENOENT => ex
            raise Veewee::Error, "#{ex}"
          rescue Error => ex
            raise Veewee::Error, "Packaging of the box failed:\n+#{ex}"
          ensure
            FileUtils.cd(current_dir)
          end
          ui.info ""

          ui.info "To import it into openvz type:"
          ui.info "mv #{name}.tar /var/lib/vz/template/cache/"
          ui.info ""
          ui.info "To use it:"
          ui.info "vzctl create #{veid} --ostemplate '#{name}'"
          ui.info "vzctl set '#{veid}' --name '#{name}' --save"
          ui.info "vzctl start '#{name}'"
          ui.info "vzctl enter '#{name}'"
        end

      end #Module
    end #Module
  end #Module
end #Module

