require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_snapshot) do
  @doc = %q{Creates a new Aptly Snapshot
  }

  ensurable

  newparam(:name, namevar: true) do
    desc "The name of the Aptly snapshot. Example : weekly-update"
  end

  newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc ""
    defaultto true
  end

  newparam(:source_type) do
    desc "Type of the source for the snapshot : mirror, repo or snapshot"
    validate do |value|
      sourceTypes = ['mirror', 'repository', 'snapshot', 'empty']
      unless sourceTypes.include? value
        raise ArgumentError , "#{value} is not a valid type of source. Types : #{sourceTypes}"
      end
    end
  end

  newparam(:source_name) do
    desc ""
  end

  newparam(:description) do
    desc ""
  end

  newparam(:snapshots) do
    desc ""
  end

  newparam(:package_refs) do
    desc ""
  end
end
