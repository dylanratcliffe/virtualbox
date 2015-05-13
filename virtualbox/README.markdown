#virtualbox

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
    * [Parameters](#parameters)
6. [Limitations](#limitations)
7. [Development](#development)
    * [Testing](#testing)

##Overview

The VirtualBox module allows you to manage VMs and their settings through Puppet.

##Module Description

This module supports many common settings used when managing VMs in Oracle VirtualBox. It allows you to define VMs in code and have their configurations managed.

Note that it will take 2 runs to set up a VM from scratch, one to create the VM and another to set it's settings. There is also a limitation applied by VirtualBox that most settings cannot be changed while the VM is running. In this instance virtual_machine resources will fail with an error message reminding you to turn off the VM so that changes can be made.

##Setup

###Setup Requirements

The VirtualBox module requires Oracle VirtualBox to be installed and working. Note that changes will be applied by the user that Puppet is running as, meaning that you may not see changes in the VirtualBox UI if it is started as a different user. To view the UI as a different user, run the `virtualbox` command under the relevant user.

**Note:** At the moment this module does not manage the installation of VirtualBox, this is something I will probably steal/borrow from somebody else's module at a later date.

##Usage

This module introduces the `virtual_machine` resource type. It represents a single VM under VirtualBox and can manage many of it's settings.

The most basic configuration is as follows:

```puppet
virtual_machine{ 'puppet_test':
  ensure => present
}
```

Create a Windows 8.1 x64 VM with 2GB of RAM and 2 CPUs:

```puppet
virtual_machine { 'puppet_test':
  ensure          => present,
  ostype          => 'Windows81_64',
  memory          => 2048,
  cpus            => 2
}
```

Create an incredibly specific VM:

```puppet
virtual_machine { 'puppet_test':
  ensure          => present,
  ostype          => 'Other',
  register        => true,
  state           => 'running',
  description     => 'Managed by puppet',
  memory          => 512,
  pagefusion      => 'off',
  vram            => 16,
  acpi            => 'on',
  nestedpaging    => 'on',
  largepages      => 'on',
  longmode        => 'off',
  synthcpu        => 'off',
  hardwareuuid    => '3e039b44-0b67-4109-8936-f9e3ac519c9b',
  cpus            => 2,
  cpuexecutioncap => 100,
  monitorcount    => 3,
  accelerate3d    => 'off',
  firmware        => 'BIOS',
  boot1           => 'net',
  boot2           => 'dvd',
  boot3           => 'disk',
  boot4           => 'none',
  io_apic          => 'on',
  nics            => {
    1 => {
      mode  => 'nat',
      type  => 'Am79C973',
      speed => 0
    },
    2 => {
      mode  => 'bridged',
      type  => 'Am79C973',
      speed => 0
    }
  }
}
```


## Parameters

* `ensure`: The standard ensure parameter

* `ostype`: OS Type of the VM, can be one of the following:
    * `Other`
    * `Other_64`
    * `Windows31`
    * `Windows95`
    * `Windows98`
    * `WindowsMe`
    * `WindowsNT4`
    * `Windows2000`
    * `WindowsXP`
    * `WindowsXP_64`
    * `Windows2003`
    * `Windows2003_64`
    * `WindowsVista`
    * `WindowsVista_64`
    * `Windows2008`
    * `Windows2008_64`
    * `Windows7`
    * `Windows7_64`
    * `Windows8`
    * `Windows8_64`
    * `Windows81`
    * `Windows81_64`
    * `Windows2012_64`
    * `Windows10`
    * `Windows10_64`
    * `WindowsNT`
    * `WindowsNT_64`
    * `Linux22`
    * `Linux24`
    * `Linux24_64`
    * `Linux26`
    * `Linux26_64`
    * `ArchLinux`
    * `ArchLinux_64`
    * `Debian`
    * `Debian_64`
    * `OpenSUSE`
    * `OpenSUSE_64`
    * `Fedora`
    * `Fedora_64`
    * `Gentoo`
    * `Gentoo_64`
    * `Mandriva`
    * `Mandriva_64`
    * `RedHat`
    * `RedHat_64`
    * `Turbolinux`
    * `Turbolinux_64`
    * `Ubuntu`
    * `Ubuntu_64`
    * `Xandros`
    * `Xandros_64`
    * `Oracle`
    * `Oracle_64`
    * `Linux`
    * `Linux_64`
    * `Solaris`
    * `Solaris_64`
    * `OpenSolaris`
    * `OpenSolaris_64`
    * `Solaris11_64`
    * `FreeBSD`
    * `FreeBSD_64`
    * `OpenBSD`
    * `OpenBSD_64`
    * `NetBSD`
    * `NetBSD_64`
    * `OS2Warp3`
    * `OS2Warp4`
    * `OS2Warp45`
    * `OS2eCS`
    * `OS2`
    * `MacOS`
    * `MacOS_64`
    * `MacOS106`
    * `MacOS106_64`
    * `MacOS107_64`
    * `MacOS108_64`
    * `MacOS109_64`
    * `DOS`
    * `Netware`
    * `L4`
    * `QNX`
    * `JRockitVE`

* `register`: Weather to register the VM when it is created, I have no idea why you would not do this so it's default is true

* `state`: Either `running` or `stopped`

* `description`: Self explanatory. Defaults to "Managed by Puppet, do not modify settings using the VirtualBox GUI"

* `memory`: Amount of RAM in MB

* `pagefusion`: `on` or `off`

* `vram`: Amount of VRAM in MB

* `acpi`: `on` or `off`

* `nestedpaging`: `on` or `off`

* `largepages`: `on` or `off`

* `longmode`: `on` or `off`

* `synthcpu`: `on` or `off`

* `hardwareuuid`: I don't know why you would want to change this, but you can!

* `cpus`: Number of virtual CPUs

* `cpuexecutioncap`: Sets the maximum % pr physical CPU to use

* `monitorcount`: Number of monitors

* `accelerate3d`: `on` or `off`

* `firmware`: Which firmware to use, possible values:
    * `BIOS`
    * `EFI`
    * `EFI32`
    * `EFI64`

* `boot1`: 1st boot device

* `boot2`: 2nd boot device

* `boot3`: 3rd boot device

* `boot4`: 4th boot device

* `io_apic`: `on` or `off` **Required to be `on` for multiple CPUs**

* `nics`: A hash of the NICs to install on the VM. The hash key is the NIC number and the value is a nested hash of it's settings. These are:
    * `mode`: The mode of the controller, can be:
        * `none`
        * `null`
        * `nat`
        * `bridged`
        * `intnet`
        * `generic`
        * `natnetwork`
    * `type`: Either `Am79C970A` or `Am79C973`
    * `speed`: TODO: I Actually don't know what this does


##Limitations

Most of these are TODO items:
 
 * Does not install VirtualBox

 * Does not manage all settings exposed by the CLI

 * Requires VM to be off to make changes


###Other

Bugs can be reported using JIRA issues

**PUT TRACKER HERE**

##Development

Pull requests are cool

###Testing

**TODO: Add testing**