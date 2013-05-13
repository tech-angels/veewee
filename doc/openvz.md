# Openvz VM Provider

## Notes

This Openvz provider has been tested with Ubuntu 10.04 only. Other linux distributions that have an official
Openvz template available have been added, but might not work.

Openvz cannot install an OS from an ISO image, and this means that there are a few caveats when using it:
* Templates are used, you can find them on http://openvz.org/Download/template/precreated . EOL and contributed ones are not used.
* The preseed files in Veewee templates are ignored ; this probably leads to some differences between an Openvz installed VM and one installed with another provider.

## Prerequistes

You will need an Openvz host with a bridge interface br0 with basic networking available through it:
* IP forwarding
* A DHCP server

## Typical workflow to build an Openvz VM template

A simple workflow to build a VM for Openvz would be:

    $ bundle exec veewee openvz templates | grep -i ubuntu
    $ bundle exec veewee openvz define 'mybuntubox' 'ubuntu-12.04-server-amd64'
    $ bundle exec veewee openvz build 'mybuntubox'

For additional box building instructions, see the [Veewee Basics](basics.md) and [Definition Customization](customize.md) docs.


## Export the VM to an Openvz template file

In order to distribute the box, we have to turn it into an Openvz template:

    $ bundle exec veewee openvz export 'myubuntubox'

This is actually calling `vzdump 'myubuntubox' --dumpdir '.'`.

The machine gets shut down, dumped and will be packed in a tar file inside the current directory.


## Add the exported .box to Openvz

To import it into Openvz's templates simply type:

    $ mv myubuntubox.tar /var/lib/vz/template/cache/


## Use the added template in Openvz

To use your newly generated box in a fresh project execute these commands:

    $ vzctl create 100 --ostemplate 'myubuntubox'

