require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_publish) do
  @doc = %q{Creates a new Aptly Publish
  }

  ensurable

  newparam(:name, namevar: true) do
    desc "The name of the Aptly snapshot. Example : weekly-update"
  end

  newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc ""
    defaultto true
  end

  newproperty(:source_type) do
    desc "Type of the source for the snapshot : repository or snapshot"
    validate do |value|
      sourceTypes = ['repo', 'snapshot']
      unless sourceTypes.include? value
        raise ArgumentError , "#{value} is not a valid type of source. Types : #{sourceTypes}"
      end
    end
  end

end
