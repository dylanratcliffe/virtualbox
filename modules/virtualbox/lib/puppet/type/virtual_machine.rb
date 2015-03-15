Puppet::Type.newtype(:virtual_machine) do
  @doc = "Create a new VirtualBox VM."
  
  # Calling ensurable means that we can use:
  #   ensure => present
  # on this resource
  ensurable

  # ... the code ...
  newparam(:name, :namevar => true) do
  	desc "The name of the VM, must not contain spaces"
  	validate do |value|
  	  unless value =~ /[.\S]+/
  	  	raise ArgumentError, "%s is not a valid name" % value
  	  end
  end

  newproperty(:groups, :array_matching => :all) do # :array_matching defaults to :first
    desc "Groups that the VM will belong to. (Optional)"
  end

  newproperty(:ostype) do
  	desc "OS type of the VM (Optional)"
  	# TODO: Find out what the valid values are and do some validation
  end

  newproperty(:register) do
  	desc "Weather or not to register the new Vm with VirtualBox (Optional)"
    # TODO: Make this default to true
    newvalue(:true)
    newvalue(:false)
  end

  newproperty(:basefolder) do
  	desc "Location for the VM (Optional)"
  end

  newproperty(:uuid) do
  	desc "UUID of the new VM (Optional)"
  end
end