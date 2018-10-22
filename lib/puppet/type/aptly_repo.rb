require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_repo) do
  @doc = 'Creates a new Aptly repo
  '

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the Aptly repo. Example : frontend_apps'
  end

  newparam(:force, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Force to drop the Apt repository even if it used as source of some snapshot'
    defaultto :true
  end

  newparam(:uid) do
    desc 'UID of the OS user which will run the cli'
    defaultto '450'
  end

  newparam(:gid) do
    desc 'GID of the OS user which will run the cli'
    defaultto '450'
  end

  newparam(:config_filepath) do
    desc 'Path of the configuration file to be used by the aptly service.'
    defaultto '/etc/aptly.conf'
  end

  newparam(:default_distribution) do
    desc 'Default distribution when publishing'
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError, format('%s is not a valid distribution (should be a string)', value)
      end
    end
    defaultto ''
  end

  newparam(:default_component) do
    desc 'Default component when publishing. Example : main'
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError, format('%s is not a valid component (should be a string)', value)
      end
    end
    defaultto 'main'
  end
end
