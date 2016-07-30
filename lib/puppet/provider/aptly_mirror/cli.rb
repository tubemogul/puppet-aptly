require 'puppet/provider'

module_lib = Pathname.new(__FILE__).parent.parent.parent.parent
require File.join module_lib, 'puppet_x/aptly/cli'

Puppet::Type.type(:aptly_mirror).provide(:cli) do

  mk_resource_methods

  def create

      Puppet.info("Creating Aptly Mirror #{name}")
      Puppet_X::Aptly::Cli.execute(
        object: :mirror,
        action: 'create',
        arguments: [ name, resource[:location], resource[:distribution], [resource[:components]].join(' ')],
        flags: {
          'architectures' => [resource[:architectures]].join(','),
          'with-sources'  => resource[:with_sources],
          'with-udebs'    => resource[:with_udebs],
        }
      )

    if resource[:update]
      Puppet.info("Updating Aptly Mirror #{name}")
      Puppet_X::Aptly::Cli.execute(
        object: :mirror,
        action: 'update',
        arguments: [ name ],
      )
    end

  end

  def destroy
    Puppet.info("Destroying Aptly Mirror #{name}")

    optsforce = resource[:force] ? 'force' : ''

    Puppet_X::Aptly::Cli.execute(
      object: :mirror,
      action: 'drop',
      arguments: [ name ],
      flags: { optsforce => '' }
    )
  end

  def exists?
    Puppet.debug("Check if #{name} exists")

    Puppet_X::Aptly::Cli.execute(
      object: :mirror,
      action: 'show',
      arguments: [ name ],
      exceptions: false,
    ) !~ /^ERROR/
  end

end
