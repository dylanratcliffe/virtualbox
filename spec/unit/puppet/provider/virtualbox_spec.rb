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
      value = 'Windows8_64'
      expect(provider.ostype=value).to eq(value)
      expect(provider.ostype).to eq(value)
    end

    it 'should be able to manage the state' do
      expect(provider.state).to eq('poweroff')
      expect(provider.state='running').to eq('running')
      expect(provider.state='poweroff').to eq('poweroff')
    end

    it 'should be able to manage the description' do
      expect(provider.description).to be_nil
      expect(provider.description='test').to eq('test')
      expect(provider.description).to eq('test')
    end

    it 'should be able to manage the memory' do
      expect(provider.memory).to eq("128")
      expect(provider.memory='1024').to eq("1024")
      expect(provider.memory).to eq("1024")
    end

    it 'should be able to manage pagefusion' do
      expect(provider.pagefusion).to eq("off")
      # TODO: Pagefusion does not work on mac, need to work out how to make testes
      # robust enough to deal with this
      #expect(provider.pagefusion='on').to eq("on")
    end

    it 'should be able to manage the vram' do
      expect(provider.vram).to eq("8")
      expect(provider.vram='128').to eq("128")
      expect(provider.vram).to eq("128")
    end

    it 'should be able to manage acpi' do
      expect(provider.acpi).to eq("on")
      expect(provider.acpi='off').to eq("off")
      expect(provider.acpi).to eq("off")
    end

    it 'should be able to manage nestedpaging' do
      expect(provider.nestedpaging).to eq("on")
      expect(provider.nestedpaging='off').to eq("off")
      expect(provider.nestedpaging).to eq("off")
    end

    it 'should be able to manage largepages' do
      expect(provider.largepages).to eq("on")
      expect(provider.largepages='off').to eq("off")
      expect(provider.largepages).to eq("off")
    end

    it 'should be able to manage longmode' do
      expect(provider.longmode).to eq("off")
      expect(provider.longmode='on').to eq("on")
      expect(provider.longmode).to eq("on")
    end

    it 'should be able to manage synthcpu' do
      expect(provider.synthcpu).to eq("off")
      expect(provider.synthcpu='on').to eq("on")
      expect(provider.synthcpu).to eq("on")
    end

    it 'should be able to manage hardwareuuid' do
      expect(provider.hardwareuuid='de305d54-75b4-431b-adb2-eb6b9e546014').to eq("de305d54-75b4-431b-adb2-eb6b9e546014")
      expect(provider.hardwareuuid).to eq("de305d54-75b4-431b-adb2-eb6b9e546014")
    end

    it 'should be able to manage cpus' do
      expect(provider.cpus).to eq("1")
      expect(provider.cpus='2').to eq("2")
      expect(provider.cpus).to eq("2")
    end

    it 'should be able to manage cpuexecutioncap' do
      expect(provider.cpuexecutioncap).to eq("100")
      expect(provider.cpuexecutioncap='50').to eq("50")
      expect(provider.cpuexecutioncap).to eq("50")
    end

    it 'should be able to manage monitorcount' do
      expect(provider.monitorcount).to eq("1")
      expect(provider.monitorcount='4').to eq("4")
      expect(provider.monitorcount).to eq("4")
    end

    it 'should be able to manage accelerate3d' do
      expect(provider.accelerate3d).to eq("off")
      expect(provider.accelerate3d='on').to eq("on")
      expect(provider.accelerate3d).to eq("on")
    end

    it 'should be able to manage firmware' do
      expect(provider.firmware).to eq("BIOS")
      expect(provider.firmware='EFI').to eq("EFI")
      expect(provider.firmware='EFI64').to eq("EFI64")
      expect(provider.firmware='EFI32').to eq("EFI32")
      expect(provider.firmware).to eq("EFI32") 
    end

    it 'should be able to manage boot1' do
      expect(provider.boot1).to eq("floppy")
      expect(provider.boot1='none').to eq("none")
      expect(provider.boot1='dvd').to eq("dvd")
      expect(provider.boot1='disk').to eq("disk")
      expect(provider.boot1='floppy').to eq("floppy")
      expect(provider.boot1='net').to eq("net")
      expect(provider.boot1).to eq("net")
    end

    it 'should be able to manage boot2' do
      expect(provider.boot1).to eq("net")
      expect(provider.boot1='none').to eq("none")
      expect(provider.boot1='dvd').to eq("dvd")
      expect(provider.boot1='disk').to eq("disk")
      expect(provider.boot1='floppy').to eq("floppy")
      expect(provider.boot1='net').to eq("net")
      expect(provider.boot1).to eq("net")
    end

    it 'should be able to manage boot3' do
      expect(provider.boot1).to eq("net")
      expect(provider.boot1='none').to eq("none")
      expect(provider.boot1='dvd').to eq("dvd")
      expect(provider.boot1='disk').to eq("disk")
      expect(provider.boot1='floppy').to eq("floppy")
      expect(provider.boot1='net').to eq("net")
      expect(provider.boot1).to eq("net")
    end

    it 'should be able to manage boot4' do
      expect(provider.boot1).to eq("net")
      expect(provider.boot1='none').to eq("none")
      expect(provider.boot1='dvd').to eq("dvd")
      expect(provider.boot1='disk').to eq("disk")
      expect(provider.boot1='floppy').to eq("floppy")
      expect(provider.boot1='net').to eq("net")
      expect(provider.boot1).to eq("net")
    end

    it 'should be able to manage a single NIC with only a mode' do
      nic_value = {
        1 => {
          'mode' => 'nat'
        }
      }
      expect(provider.nics=nic_value).to eq(nic_value)
    end

    it 'should be able to manage a single NIC with only a type' do
      nic_value = {
        1 => {
          'type' => 'Am79C973'
        }
      }
      expect(provider.nics=nic_value).to eq(nic_value)
    end

    it 'should be able to manage a single NIC with only a speed' do
      nic_value = {
        1 => {
          'speed' => 1000
        }
      }
      expect(provider.nics=nic_value).to eq(nic_value)
    end

  end

  context "When deleting" do
    it 'should then be able to delete that basic VM' do
      expect(provider.destroy).to eq(true)
    end
  end
end
