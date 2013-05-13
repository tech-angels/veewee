require 'veewee/provider/core/box'
require 'veewee/provider/core/helper/tcp'

require 'veewee/provider/openvz/box/helper/status'
require 'veewee/provider/openvz/box/helper/ip'
require 'veewee/provider/openvz/box/helper/ssh_options'
require 'veewee/provider/openvz/box/helper/buildinfo'

require 'veewee/provider/openvz/box/build'
require 'veewee/provider/openvz/box/up'
require 'veewee/provider/openvz/box/create'
require 'veewee/provider/openvz/box/poweroff'
require 'veewee/provider/openvz/box/halt'
require 'veewee/provider/openvz/box/destroy'
require 'veewee/provider/openvz/box/ssh'
require 'veewee/provider/openvz/box/validate_openvz'
require 'veewee/provider/openvz/box/export_openvz'


module Veewee
  module Provider
    module Openvz
      class Box < Veewee::Provider::Core::Box

        attr_accessor :veid

        include ::Veewee::Provider::Openvz::BoxCommand
        include ::Veewee::Provider::Core::BoxCommand


        def initialize(name,env)
          super(name,env)
        end

      end # End Class
    end # End Module
  end # End Module
end # End Module
