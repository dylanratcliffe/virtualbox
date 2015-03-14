Puppet::Type.newtype(:vbox_vm) do
  @doc = "Create a new VirtualBox VM."
  
  # Calling ensurable means that we can use:
  #   ensure => present
  # on this resource
  ensurable

  
  # ... the code ...
end