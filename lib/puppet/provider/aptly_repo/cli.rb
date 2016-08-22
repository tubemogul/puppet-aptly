require 'puppet/provider'

module_lib = Pathname.new(__FILE__).parent.parent.parent.parent
require File.join module_lib, 'puppet_x/aptly/cli'

Puppet::Type.type(:aptly_repo).provide(:cli) do

  mk_resource_methods

  def create
    Puppet.info("Creating Aptly Repository #{name}}")

    Puppet_X::Aptly::Cli.execute(
      object: :repo,
      action: 'create',
      arguments: [ name ],
      flags: {
        'component'    => resource[:default_component],
        'distribution' => resource[:default_distribution],
      }
    )
  end

  def destroy
    Puppet.info("Destroying Aptly Repository #{name}")

    Puppet_X::Aptly::Cli.execute(
      object: :repo,
      action: 'drop',
      arguments: [ name ],
      flags: { 'force' => resource[:force] ? 'true' : 'false' },
    )
  end

  def exists?
    Puppet.debug("Check if Repository #{name} exists")

    Puppet_X::Aptly::Cli.execute(
      object: :repo,
      action: 'list',
      flags: { 'raw' => 'true' },
      exceptions: false,
    ).lines.map(&:chomp).include? name
  end

end
