require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_mirror) do
  @doc = 'Creates a new Aptly Mirror
  '

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the Aptly mirror. Example : debian-main'
  end

  newparam(:force, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Force to delete the Apt mirror'
    defaultto :true
  end

  newparam(:update, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Automatically update the Apt mirror after the creation'
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

  newparam(:location) do
    desc 'The URL for the source Debian repository'
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError, format('%s is not a valid location (should be a string)', value)
      end
    end
    defaultto :undef
  end

  newparam(:distribution) do
    desc 'The distribution to mirror'
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError, format('%s is not a valid distribution (should be a string)', value)
      end
    end
    defaultto :undef
  end

  newparam(:architectures, array_matching: :all) do
    desc 'List of architectures to mirror'
    defaultto :undef
  end

  newparam(:components, array_matching: :all) do
    desc 'List of APT Debian components requested. Example : main'
    defaultto :undef
  end

  newparam(:keyring) do
    desc 'Set path to keyring. Default - /etc/apt/trusted.gpg'
    defaultto "/etc/apt/trusted.gpg"
  end

  newparam(:with_sources, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Whether to mirror the source packages or not'
    defaultto :false
  end

  newparam(:with_udebs, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Whether to download .udeb packages or not'
    defaultto :false
  end
end
