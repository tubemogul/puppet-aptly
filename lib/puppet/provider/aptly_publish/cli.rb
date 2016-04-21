require 'puppet/provider'

Puppet::Type.type(:aptly_publish).provide(:cli) do

  mk_resource_methods

  def create
    Puppet.info("Publishing Aptly #{resource[:source_type]} #{name}")

    run_cmd "aptly publish #{resource[:source_type]} #{name}"
  end

  def destroy
    Puppet.info("Destroying Aptly Mirror #{name}")

    optsforce = resource[:force] ? '-force-drop=true' : ''

    run_cmd "aptly publish drop #{optsforce} #{name}"
  end

  def exists?
    Puppet.debug("Check if #{name} exists")
    run_cmd("aptly publish list").include? name
  end

  private
  def run_cmd(cmd)
    begin
      Puppet::Util::Execution.execute([cmd], {:combine => true})
    rescue => e
      raise Puppet::Error,
        e.message
    end
  end

end
