require 'puppet/parameter/boolean'

Puppet::Type.newtype(:aptly_mirror) do
  @doc = %q{Creates a new Aptly Mirror
  }

  ensurable

  newparam(:name, namevar: true) do
    desc "The name of the Aptly mirror. Example : debian-main"
  end

  newparam(:force, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc "Force to delete the Apt mirror"
    defaultto true
  end

  newparam(:update, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc "Automatically update the Apt mirror after the creation"
    defaultto true
  end

  newproperty(:location) do
    desc "The URL for the source Debian repository"
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError , "%s is not a valid String" % value
      end
    end
  end

  newproperty(:distribution) do
    desc ""
    validate do |value|
      unless value.instance_of? String
        raise ArgumentError , "%s is not a valid String" % value
      end
    end
    defaultto :undef
  end

  newproperty(:components, :array_matching => :all) do
    desc "List of APT Debian components requested. Example : main"
    defaultto :undef
  end

  newproperty(:architectures, :array_matching => :all) do
    desc ""
    defaultto :undef
  end

  newproperty(:with_sources) do
    desc "Mirror Sources"
    defaultto :false
    newvalues(:true, :false)
  end

  newproperty(:with_udebs) do
    desc "Download .udeb packages"
    defaultto :false
    newvalues(:true, :false)
  end

end
