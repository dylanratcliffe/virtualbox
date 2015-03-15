Puppet::Type.newtype(:virtual_machine) do
  @doc = "Create a new VirtualBox VM."
  
  # Calling ensurable means that we can use:
  #   ensure => present
  # on this resource
  ensurable

  # ... the code ...
  newparam(:name, :namevar => true) do
  	desc "The name of the VM, must not contain spaces"
  	newvalues(/[.\S]+/)
  	
  end

  newproperty(:groups, :array_matching => :all) do # :array_matching defaults to :first
    desc "Groups that the VM will belong to. (Optional)"
    # This little gem makes sure that when we are comparing the arrays
    # to see if they match up, we sort them first so that puppet doesn't
    # freak the fuck out
    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:ostype) do
  	desc "OS type of the VM (Optional)"
  	# TODO: Find out what the valid values are and do some validation
  end

  newproperty(:register) do
  	desc "Weather or not to register the new Vm with VirtualBox (Optional)"
    defaultto :true
    newvalues(:true, :false)
  end

  newproperty(:basefolder) do
    # TODO: Add path validation
  	desc "Location for the VM (Optional)"
  end

  newproperty(:uuid) do
  	desc "UUID of the new VM (Optional)"
  end
end