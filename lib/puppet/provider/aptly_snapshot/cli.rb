require 'puppet/provider'
require 'net/http'
require 'uri'

Puppet::Type.type(:aptly_snapshot).provide(:cli) do

  mk_resource_methods

  def create
    Puppet.info("Creating Aptly Snapshot #{name} from a #{resource[:source_type]}")

    from = case resource[:source_type]
    when 'mirror'
      'from mirror'
    when 'repository'
      'from repo'
    when 'empty'
      'empty'
    else
      raise Puppet::error "#{resource[:source_type]} is not supported"
    end

    run_cmd "aptly snapshot create #{name} #{from} #{resource[:source_name]}"
  end

  def destroy
    Puppet.info("Destroying Aptly Snapshot #{name}")
    run_cmd "aptly snapshot drop #{name}"
  end

  def exists?
    Puppet.debug("Check if #{name} exists")
    run_cmd_no_exception(
      "aptly snapshot show #{name}"
    ) !~ /^ERROR/
  end

  private
  #TODO: put that in lib/puppet_x and refactor provider
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
