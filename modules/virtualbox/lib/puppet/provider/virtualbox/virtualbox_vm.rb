Puppet::Type.type(:virtual_machine).provide(:virtualbox_vm, :parent => Puppet::Provider::Virtualbox) do
  desc "Manage Virtual Box"

    def create
        File.open(@resource[:name], "w") { |f| f.puts "" } # Create an empty file
    end

    def destroy
        File.unlink(@resource[:name])
    end

    def exists?
        File.exists?(@resource[:name])
    end
end