Puppet::Type.type(:virtual_machine).provide(:virtualbox_vm, :parent => Puppet::Provider::Virtualbox) do
  desc "Manage Virtual Box"
    # This line of code will use some cool Puppet black magic straight out of Haiti
    # to create a method named the same as the symbolised key, in our case: vboxmanage()
    # This method will than take parameters and use them to execue vboxmanage, how cool
    # is that?
    commands :vboxmanage => 'vboxmanage'

    def exists?
      # The logic here is that calling this will throw an exception if it
      # does not exist and if it does the resulting string or array or 
      # whatever will be cast into a true. Would be good if there was a 
      # way to test it, maybe I could put in a bunch of debugging??
      vboxmanage(['showvminfo', resource[:name]])
    end

    def create
      ## Create the command variables
      # This always exists
      name_flag = '--name'
      #groups_flag = nil
      ostype_flag = nil
      register_flag = nil
      basefolder_flag = nil
      uuid_flag = nil

      ## Set them based on the given params
      #groups_flag = '--groups' if resource[:groups]
      ostype_flag = '--ostype' if resource[:ostype]
      register_flag = '--register' if resource[:register]
      basefolder_flag = '--basefolder' if resource[:basefolder]
      uuid_flag = '--uuid' if resource[:uuid]

      begin
        # Execute vboxmanage to create the vm
        output = vboxmanage(['createvm',
          name_flag, resource[:name],
          #groups_flag, resource[:groups],
          ostype_flag, resource[:ostype],
          register_flag,
          basefolder_flag, resource[:basefolder],
          uuid_flag, resource[:uuid]])      
      rescue Puppet::ExecutionFailure => e
        Puppet.debug("#vboxmanage had an error -> #{e.inspect}")
        throw e
      end
    end

    def destroy
      # The lack of boolean casting here is based on the same logic as
      # the exists? thing
      vboxmanage(['unregistervm', resource[:name], '--delete'])
    end

    def ostype
    end

    # This gets all the info from the vm and returns it in a hash
    # to see an example run: vboxmanage showvminfo <vm_name> --machinereadable
    def get_vm_info(name)
      output = vboxmanage('showvminfo', name, '--machinereadable')

      # Split this on the '=' sign
      split_output = []
      output.each do |line|
      	split_output << line.split('=')
      end

      # Map the array to a hash
      info_hash = Hash[split_output.map {|key, value| [key, value]}]

      # Remove any literal quotes
      info_hash.each do |key, value|
      	info_hash[key] = value.tr("\"","")
      end

      info_hash
    end
end