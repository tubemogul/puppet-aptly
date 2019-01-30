require 'puppet/provider'

module_lib = Pathname.new(__FILE__).parent.parent.parent.parent
require File.join module_lib, 'puppet_x/aptly/cli'

Puppet::Type.type(:aptly_publish).provide(:cli) do
  mk_resource_methods

  def create
    Puppet.info("Publishing Aptly #{resource[:source_type]} #{name}")

    arguments = resource[:endpoint] ? [name, "#{resource[:endpoint]}:#{name}"] : [name]

    Puppet_X::Aptly::Cli.execute(
      uid: resource[:uid],
      gid: resource[:gid],
      object: :publish,
      action: resource[:source_type],
      arguments: arguments,
      flags: { 'distribution' => resource[:distribution], 'config' => resource[:config_filepath] }
    )
  end

  def destroy
    Puppet.info("Destroying Aptly Publish #{name}")

    publish_name = resource[:endpoint] ? "#{resource[:endpoint]}:#{name}" : [name]

    Puppet_X::Aptly::Cli.execute(
      uid: resource[:uid],
      gid: resource[:gid],
      object: :publish,
      action: 'drop',
      arguments: [resource[:distribution], publish_name],
      flags: { 'force-drop' => resource[:force] ? 'true' : 'false', 'config' => resource[:config_filepath] }
    )
  end

  def exists?
    Puppet.debug("Check if #{name} exists")

    publish_name = resource[:endpoint] ? "#{resource[:endpoint]}:#{name}" : [name]

    Puppet_X::Aptly::Cli.execute(
      uid: resource[:uid],
      gid: resource[:gid],
      object: :publish,
      action: 'list',
      flags: { 'raw' => 'true', 'config' => resource[:config_filepath] },
      exceptions: false
    ).lines.map(&:chomp).include? "#{publish_name} #{resource[:distribution]}"
  end
end
