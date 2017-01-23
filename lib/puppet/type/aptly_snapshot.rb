require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_snapshot) do
  @doc = 'Creates a new Aptly Snapshot
  '

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the Aptly snapshot. Example : weekly-update'
  end

  newparam(:force, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc ''
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
    desc 'Type of the source for the snapshot : mirror, repo, or empty. Defaults to repository.'
    newvalues(:mirror, :repository, :empty)
    defaultto :repository
  end

  newparam(:source_name) do
    desc ''
  end

  newparam(:description) do
    desc ''
  end

  newparam(:snapshots) do
    desc ''
  end

  newparam(:package_refs) do
    desc ''
  end
end
