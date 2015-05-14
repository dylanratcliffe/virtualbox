require 'spec_helper'
provider_class = Puppet::Type.type(:virtual_machine).provider(:virtualbox_vm)
describe provider_class do
  let :resource do
      Puppet::Type::Virtual_machine.new(
      {
        :name => 'dont_use_this_name_god_damnit',
        :ostype => 'Other'
        })
  end
  let :provider do
      provider_class.new(resource)
  end
  context 'When adding' do
    # This one will not raise an exception but will also not 
    # return anything at all which makes the testing framework 
    # derp real hard, refactor
    it 'should be able to create a basic vm' do
      expect(provider.create).to match(/Virtual machine 'dont_use_this_name_god_damnit' is created and registered/)
    end

    it 'should detect that basic vm has been created' do
      expect(provider.exists?).to be_truthy
    end
  end

  context "When modifying" do
    it 'should be able to set the ostype' do
      value = 'DOS'
      expect(provider.ostype=value).to eq(value)
      expect(provider.ostype).to eq(value)
    end

    it 'should be able to manage the state' do
      expect(provider.state).to eq('poweroff')
      expect(provider.state='running').to eq('running')
      expect(provider.state='poweroff').to eq('poweroff')
    end

    it 'should be able to manage the description' do
      expect(provider.description).to match(/something/)
      expect(provider.description='test').to be_nil
      expect(provider.description).to match(/test/)
    end

    it 'should be able to manage the memory' do
      expect(provider.memory).to eq("128")
      expect(provider.memory='1024').to eq("1024")
      expect(provider.memory).to eq("1024")
    end

  end

  context "When deleting" do
    it 'should then be able to delete that basic VM' do
      expect(provider.destroy).to eq(true)
    end
  end
end
