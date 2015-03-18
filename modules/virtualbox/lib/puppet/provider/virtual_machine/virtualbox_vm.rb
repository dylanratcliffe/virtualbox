Puppet::Type.type(:virtual_machine).provide(:virtualbox_vm) do
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
      begin
      	vboxmanage(['showvminfo', resource[:name]])
      	exist = true
      rescue Puppet::ExecutionFailure => e
      	# If there is an exception return false
      	exist = false
      end
      exist
    end

    def create
      ## Create the command variables
      # This always exists
      name_flag = '--name'
      #groups_flag = nil

      params_array = []

      ## Add params to the array only if they exist
      params_array << 'createvm'
      params_array << name_flag
      params_array << resource[:name]
      params_array << '--ostype' if resource[:ostype] != nil
      params_array << resource[:ostype] if resource[:ostype] != nil
      params_array << '--register' if resource[:register] != nil
      params_array << '--basefolder' if resource[:basefolder] != nil
      params_array << resource[:basefolder] if resource[:basefolder] != nil
      params_array << '--uuid' if resource[:uuid] != nil
      params_array << resource[:uuid] if resource[:uuid] != nil

      begin
        # Execute vboxmanage to create the vm
        output = vboxmanage(params_array)      
      rescue Puppet::ExecutionFailure => e
        Puppet.debug("#vboxmanage had an error -> #{e.inspect}")
        throw e
      end
      output
    end

    def destroy
      # The lack of boolean casting here is based on the same logic as
      # the exists? thing
      begin
        vboxmanage(['unregistervm', resource[:name], '--delete'])
      	destroyed = true
      rescue Puppet::ExecutionFailure => e
      	# If there is an exception return false
      	destroyed = false
      end
      destroyed
    end

    def ostype
      # This is going to be ballbreaker as VirtualBox returns the 
      # friendly name of the ostype when we set it using the proper name
      
      # This is a massive array converting the names from friendly to useful
      friendly_names = { "Other/Unknown" => "Other",
        "Other/Unknown (64-bit)" => "Other_64",
        "Windows 3.1" => "Windows31",
        "Windows 95" => "Windows95",
        "Windows 98" => "Windows98",
        "Windows ME" => "WindowsMe",
        "Windows NT 4" => "WindowsNT4",
        "Windows 2000" => "Windows2000",
        "Windows XP (32 bit)" => "WindowsXP",
        "Windows XP (64 bit)" => "WindowsXP_64",
        "Windows 2003 (32 bit)" => "Windows2003",
        "Windows 2003 (64 bit)" => "Windows2003_64",
        "Windows Vista (32 bit)" => "WindowsVista",
        "Windows Vista (64 bit)" => "WindowsVista_64",
        "Windows 2008 (32 bit)" => "Windows2008",
        "Windows 2008 (64 bit)" => "Windows2008_64",
        "Windows 7 (32 bit)" => "Windows7",
        "Windows 7 (64 bit)" => "Windows7_64",
        "Windows 8 (32 bit)" => "Windows8",
        "Windows 8 (64 bit)" => "Windows8_64",
        "Windows 8.1 (32 bit)" => "Windows81",
        "Windows 8.1 (64 bit)" => "Windows81_64",
        "Windows 2012 (64 bit)" => "Windows2012_64",
        "Windows 10 (32 bit)" => "Windows10",
        "Windows 10 (64 bit)" => "Windows10_64",
        "Other Windows (32 bit)" => "WindowsNT",
        "Other Windows (64-bit)" => "WindowsNT_64",
        "Linux 2.2" => "Linux22",
        "Linux 2.4 (32 bit)" => "Linux24",
        "Linux 2.4 (64 bit)" => "Linux24_64",
        "Linux 2.6 / 3.x (32 bit)" => "Linux26",
        "Linux 2.6 / 3.x (64 bit)" => "Linux26_64",
        "Arch Linux (32 bit)" => "ArchLinux",
        "Arch Linux (64 bit)" => "ArchLinux_64",
        "Debian (32 bit)" => "Debian",
        "Debian (64 bit)" => "Debian_64",
        "openSUSE (32 bit)" => "OpenSUSE",
        "openSUSE (64 bit)" => "OpenSUSE_64",
        "Fedora (32 bit)" => "Fedora",
        "Fedora (64 bit)" => "Fedora_64",
        "Gentoo (32 bit)" => "Gentoo",
        "Gentoo (64 bit)" => "Gentoo_64",
        "Mandriva (32 bit)" => "Mandriva",
        "Mandriva (64 bit)" => "Mandriva_64",
        "Red Hat (32 bit)" => "RedHat",
        "Red Hat (64 bit)" => "RedHat_64",
        "Turbolinux (32 bit)" => "Turbolinux",
        "Turbolinux (64 bit)" => "Turbolinux_64",
        "Ubuntu (32 bit)" => "Ubuntu",
        "Ubuntu (64 bit)" => "Ubuntu_64",
        "Xandros (32 bit)" => "Xandros",
        "Xandros (64 bit)" => "Xandros_64",
        "Oracle (32 bit)" => "Oracle",
        "Oracle (64 bit)" => "Oracle_64",
        "Other Linux (32 bit)" => "Linux",
        "Other Linux (64-bit)" => "Linux_64",
        "Oracle Solaris 10 5/09 and earlier (32 bit)" => "Solaris",
        "Oracle Solaris 10 5/09 and earlier (64 bit)" => "Solaris_64",
        "Oracle Solaris 10 10/09 and later (32 bit)" => "OpenSolaris",
        "Oracle Solaris 10 10/09 and later (64 bit)" => "OpenSolaris_64",
        "Oracle Solaris 11 (64 bit)" => "Solaris11_64",
        "FreeBSD (32 bit)" => "FreeBSD",
        "FreeBSD (64 bit)" => "FreeBSD_64",
        "OpenBSD (32 bit)" => "OpenBSD",
        "OpenBSD (64 bit)" => "OpenBSD_64",
        "NetBSD (32 bit)" => "NetBSD",
        "NetBSD (64 bit)" => "NetBSD_64",
        "OS/2 Warp 3" => "OS2Warp3",
        "OS/2 Warp 4" => "OS2Warp4",
        "OS/2 Warp 4.5" => "OS2Warp45",
        "eComStation" => "OS2eCS",
        "Other OS/2" => "OS2",
        "Mac OS X (32 bit)" => "MacOS",
        "Mac OS X (64 bit)" => "MacOS_64",
        "Mac OS X 10.6 Snow Leopard (32 bit)" => "MacOS106",
        "Mac OS X 10.6 Snow Leopard (64 bit)" => "MacOS106_64",
        "Mac OS X 10.7 Lion (64 bit)" => "MacOS107_64",
        "Mac OS X 10.8 Mountain Lion (64 bit)" => "MacOS108_64",
        "Mac OS X 10.9 Mavericks (64 bit)" => "MacOS109_64",
        "DOS" => "DOS",
        "Netware" => "Netware",
        "L4" => "L4",
        "QNX" => "QNX",
        "JRockitVE" => "JRockitVE"
      }

      # Grab the settings from the VM
      settings = get_vm_info(resource[:name])
      # Get the friendly name
      friendly_name = settings['ostype']
      # Convert it to the actual name
      ostype = friendly_names[friendly_name]
      # Return it
      ostype
    end

    def ostype=(value)
      vboxmanage('modifyvm', resource[:name], '--ostype', value)
    end

    # This only deals with two states; running and poweroff
    # I realise that there is more states but I would be surprised
    # if people wanted to manage them
    def state
      running_vms = vboxmanage('list', 'runningvms')
      state = 'poweroff'
      if running_vms.kind_of?(Array)
        running_vms.each do |vm|
          if vm.include? resource[:name]
            state = 'running'
          end
        end
      else
      	if running_vms.include? resource[:name]
      	  state = 'running'
      	end
      end
      state
    end

    def state=(value)
      if value =~ /running/
        vboxmanage(['startvm', resource[:name], '--type', 'headless'])
      elsif value =~ /poweroff/
        vboxmanage(['controlvm', resource[:name], 'poweroff'])
      end
    end

    def description
      get_setting('description')
    end

    def description=(value)
      modifyvm('description', value)
    end

    def memory
      get_setting('memory')
    end

    def memory=(value)
      modifyvm('memory', value)
    end

    def pagefusion
      get_setting('pagefusion')
    end

    def pagefusion=(value)
      modifyvm('pagefusion', value)
    end

    def vram
      get_setting('vram')
    end

    def vram=(value)
      modifyvm('vram', value)
    end

    def acpi
      get_setting('acpi')
    end

    def acpi=(value)
      modifyvm('acpi', value)
    end

    private

    def get_setting(setting)
      settings = get_vm_info(resource[:name])
      setting = settings[setting]
    end

    # This is just a wrapper for get_vm_info specific to the modifyvm command
    def modifyvm(parameter, value)
      begin
        vboxmanage('modifyvm', resource[:name], "--#{parameter}", value)
      # If I could find a better exception here would be great,
      # something atht is a bit more specific
      rescue Puppet::ExecutionFailure => e
      	throw "VM is running, changes will not be made until it is stopped"
      end
    end
    
    # This gets all the info from the vm and returns it in a hash
    # to see an example run: vboxmanage showvminfo <vm_name> --machinereadable
    def get_vm_info(name)
      output = vboxmanage('showvminfo', name, '--machinereadable')
      # Split this on the '=' sign
      split_output = []
      output = output.split("\n")
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