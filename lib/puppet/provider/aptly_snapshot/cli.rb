require 'puppet/provider'

module_lib = Pathname.new(__FILE__).parent.parent.parent.parent
require File.join module_lib, 'puppet_x/aptly/cli'

Puppet::Type.type(:aptly_snapshot).provide(:cli) do

  mk_resource_methods

  def create
    Puppet.info("Creating Aptly Snapshot #{name} from a #{resource[:source_type]}")

    from = case resource[:source_type]
    when :mirror
      'from mirror'
    when :repository
      'from repo'
    when :empty
      'empty'
    else
      raise Puppet::Error, "#{resource[:source_type]} is not supported"
    end

    Puppet_X::Aptly::Cli.execute(
      object: :snapshot,
      action: 'create',
      arguments: [ name, from, resource[:source_name] ],
    )
  end

  def destroy
    Puppet.info("Destroying Aptly Snapshot #{name}")

    Puppet_X::Aptly::Cli.execute(
      object: :snapshot,
      action: 'drop',
      arguments: [ name ],
    )
  end

  def exists?
    Puppet.debug("Check if #{name} exists")

    Puppet_X::Aptly::Cli.execute(
      object: :snapshot,
      action: 'show',
      arguments: [ name ],
      exceptions: false,
    ) !~ /^ERROR/
  end

end
