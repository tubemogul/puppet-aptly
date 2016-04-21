require 'puppet/provider'

Puppet::Type.type(:aptly_mirror).provide(:cli) do

  mk_resource_methods

  def create
    Puppet.info("Creating Aptly Mirror #{name}")

    opts = "--architectures #{resource[:architectures].join(',')}"

    cmd = "aptly #{opts} mirror create #{name} #{resource[:archive_url]}"
    cmd += " #{resource[:distribution]} #{resource[:components].join(' ')}"
    run_cmd cmd
  end

  def destroy
    Puppet.info("Destroying Aptly Mirror #{name}")

    optsforce = resource[:force] ? '--force' : ''

    run_cmd "aptly mirror drop #{optsforce} #{name}"
  end

  def exists?
    Puppet.debug("Check if #{name} exists")
    run_cmd_no_exception(
      "aptly mirror show #{name}"
    ) =~ /^ERROR/
  end

  private
  def run_cmd_no_exception(cmd)
    #TODO: find a better way to handle command with errors
    begin
      result = Puppet::Util::Execution.execute([cmd])
    rescue
      result
    end
  end

  def run_cmd(cmd)
    begin
      Puppet::Util::Execution.execute([cmd])
    rescue => e
      raise Puppet::Error,
        e.message
    end
  end

end
