Puppet::Type.type(:virtual_machine).provide(:virtualbox_vm, :parent => Puppet::Provider::Virtualbox) do
  desc "Manage Virtual Box"
    # This line of code will use some cool Puppet black magic straight out of Haiti
    # to create a method named the same as the symbolised key, in our case: vboxmanage()
    # This method will than take parameters and use them to execue vboxmanage, how cool
    # is that?
    commands :vboxmanage => 'vboxmanage'

    def exists?
    end

    def create
      ## Create the command variables
      # This always exists
      name_flag = '--name'
      groups_flag = nil
      ostype_flag = nil
      register_flag = nil
      basefolder_flag = nil
      uuid_flag = nil

      ## Set them based on the given params
      groups_flag = '--groups' if resource[:groups]
      ostype_flag = '--ostype' if resource[:ostype]
      register_flag = '--register' if resource[:register]
      basefolder_flag = '--basefolder' if resource[:basefolder]
      uuid_flag = '--uuid' if resource[:uuid]

      # Construct command sections
      if resource[:register]
      	registerflag = '--register'
      else
      	registerflag = nil
      end

      vboxmanage(['createvm', '--name', resource[:name],])
    end

    def destroy
        
    end
end