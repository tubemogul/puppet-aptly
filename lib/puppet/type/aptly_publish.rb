require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_publish) do
  @doc = 'Provides an overlay over the aptly publish command
  '

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the Aptly snapshot. Example : weekly-update'
  end

  newparam(:force, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Force the action. For example, it will force-drop when using aptly publish drop.'
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

  newparam(:source_type) do
    desc 'Type of the source for the snapshot : repository or snapshot'
    newvalues(:repo, :snapshot)
    defaultto :snapshot
  end

  newparam(:distribution) do
    desc 'Distribution name to publish'
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError, '%s is not a valid distribution (should be a string)' % value
      end
    end
    defaultto ''
  end
end
