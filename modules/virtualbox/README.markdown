#virtualbox

####Table of Contents

1. [Overview - What is the firewall mogitdule?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with firewall](#setup)
    * [What firewall Affects](#what-firewall-affects)
    * [Setup Requirements](#setup-requirements)
    * [Beginning with firewall](#beginning-with-firewall)
    * [Upgrading](#upgrading)
4. [Usage - Configuration and customization options](#usage)
    * [Default rules - Setting up general configurations for all firewalls](#default-rules)
    * [Application-Specific Rules - Options for configuring and managing firewalls across applications](#application-specific-rules)
    * [Additional Uses for the Firewall Module](#other-rules)
5. [Reference - An under-the-hood peek at what the module is doing](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
    * [Tests - Testing your configuration](#tests)

##Overview

The VirtualBox module allows you to manage VMs and their settings through Puppet.

##Module Description

This module supports many common settings used when managing VMs in Oracle VirtualBox. It allows you to define VMs in code and have their configurations managed.

Note that it will take 2 runs to set up a VM from scratch, one to creadste the VM and another to set it's settings. There is also a limitation applied by VirtualBox that most settings cannot be changed while the VM is running. In this instance virtual_machine resources will fail with an error message reminding you to turn off the VM so that changes can be made.

##Setup

###Setup Requirements

The VirtualBox module requires Oracle VirtualBox to be installed and working. Note that changes will be applied by the user that Puppet is running as, meaning that you may not see changes in the VirtualBox UI if it is started as a different user. To view the UI as a different user, run the `virtualbox` command under the relevant user.

**Note:** At the moment this module does not manage the installation of VirtualBox, this is something I will probabaly steal/borrow from somebody else's module at a later date.

##Usage

This module introduces the `virtual_machine` resource type. It represents a single VM under VirtualBox and can manage many of it's settings.

The most basic configuration is as follows:

```puppet
virtual_machine{ "vm_name":
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

## Parameters

* `address_type`: The ability to match on source or destination address type.

* `connection_limiting`: Connection limiting features.

* `dnat`: Destination NATing.

* `hop_limiting`: Hop limiting features.

* `icmp_match`: The ability to match ICMP types.

* `interface_match`: Interface matching.

* `iprange`: The ability to match on source or destination IP range.

* `ipsec_dir`: The ability to match IPsec policy direction.

* `ipsec_policy`: The ability to match IPsec policy.

* `iptables`: The provider provides iptables features.

* `isfirstfrag`: The ability to match the first fragment of a fragmented ipv6 packet.

* `isfragment`: The ability to match fragments.

* `ishasmorefrags`: The ability to match a non-last fragment of a fragmented ipv6 packet.

* `islastfrag`: The ability to match the last fragment of an ipv6 packet.

* `log_level`: The ability to control the log level.

* `log_prefix`: The ability to add prefixes to log messages.

* `mark`: The ability to match or set the netfilter mark value associated with the packet.

* `mask`:  The ability to match recent rules based on the ipv4 mask.

* `owner`: The ability to match owners.

* `pkttype`: The ability to match a packet type.

* `rate_limiting`: Rate limiting features.

* `recent_limiting`: The netfilter recent module.

* `reject_type`: The ability to control reject messages.

* `snat`: Source NATing.

* `socket`: The ability to match open sockets.

* `state_match`: The ability to match stateful firewall states.

* `tcp_flags`: The ability to match on particular TCP flag settings.

* `netmap`: The ability to map entire subnets via source or destination nat rules.

#### Parameters

* `action`: This is the action to perform on a match. Valid values for this action are:
  * 'accept': The packet is accepted.
  * 'reject': The packet is rejected with a suitable ICMP response.
  * 'drop': The packet is dropped.

   If you specify no value it will simply match the rule but perform no action unless you provide a provider-specific parameter (such as `jump`).

* `burst`: Rate limiting burst value (per second) before limit checks apply. Values must match '/^\d+$/'. Requires the `rate_limiting` feature.

* `chain`: Name of the chain to use. You can provide a user-based chain or use one of the following built-in chains:'INPUT','FORWARD','OUTPUT','PREROUTING', or 'POSTROUTING'. The default value is 'INPUT'. Values must match '/^[a-zA-Z0-9\-_]+$/'. Requires the `iptables` feature.

 * `checksum_fill`: When using a `jump` value of 'CHECKSUM' this boolean will make sure that a checksum is calculated and filled in a packet that lacks a checksum. Valid values are true or false. Requires the `iptables` feature.

* `connlimit_above`: Connection limiting value for matched connections above n. Values must match '/^\d+$/'. Requires the `connection_limiting` feature.

* `connlimit_mask`: Connection limiting by subnet mask for matched connections. Apply a subnet mask of /0 to /32 for IPv4, and a subnet mask of /0 to /128 for IPv6. Values must match '/^\d+$/'. Requires the `connection_limiting` feature.

* `connmark`: Match the Netfilter mark value associated with the packet. Accepts values `mark/mask` or `mark`. These will be converted to hex if they are not hex already. Requires the `mark` feature.

* `ctstate`: Matches a packet based on its state in the firewall stateful inspection table, using the conntrack module. Valid values are: 'INVALID', 'ESTABLISHED', 'NEW', 'RELATED'. Requires the `state_match` feature.

* `destination`: The destination address to match. For example: `destination => '192.168.1.0/24'`. You can also negate a mask by putting ! in front. For example: `destination  => '! 192.168.2.0/24'`. The destination can also be an IPv6 address if your provider supports it.

  For some firewall providers you can pass a range of ports in the format: 'start number-end number'. For example, '1-1024' would cover ports 1 to 1024.

* `dport`: The destination port to match for this filter (if the protocol supports ports). Will accept a single element or an array. For some firewall providers you can pass a range of ports in the format: 'start number-end number'. For example, '1-1024' would cover ports 1 to 1024.

* `dst_range`: The destination IP range. For example: `dst_range => '192.168.1.1-192.168.1.10'`.

  The destination IP range is must in 'IP1-IP2' format. Values in the range must be valid IPv4 or IPv6 addresses. Requires the `iprange` feature.

* `dst_type`: The destination address type. For example: `dst_type => 'LOCAL'`.

  Valid values are:

  * 'UNSPEC': an unspecified address
  * 'UNICAST': a unicast address
  * 'LOCAL': a local address
  * 'BROADCAST': a broadcast address
  * 'ANYCAST': an anycast packet
  * 'MULTICAST': a multicast address
  * 'BLACKHOLE': a blackhole address
  * 'UNREACHABLE': an unreachable address
  * 'PROHIBIT': a prohibited address
  * 'THROW': an unroutable address
  * 'XRESOLVE: an unresolvable address

  Requires the `address_type` feature.

* `ensure`: Ensures that the resource is present. Valid values are 'present', 'absent'. The default is 'present'.

* `gid`: GID or Group owner matching rule. Accepts a string argument only, as iptables does not accept multiple gid in a single statement. Requires the `owner` feature.

* `hop_limit`: Hop limiting value for matched packets. Values must match '/^\d+$/'. Requires the `hop_limiting` feature.

* `icmp`: When matching ICMP packets, this indicates the type of ICMP packet to match. A value of 'any' is not supported. To match any type of ICMP packet, the parameter should be omitted or undefined. Requires the `icmp_match` feature.

* `iniface`: Input interface to filter on. Values must match '/^!?\s?[a-zA-Z0-9\-\._\+\:]+$/'.  Requires the `interface_match` feature.  Supports interface alias (eth0:0) and negation.

* `ipsec_dir`: Sets the ipsec policy direction. Valid values are 'in', 'out'. Requires the `ipsec_dir` feature.

* `ipsec_policy`: Sets the ipsec policy type. Valid values are 'none', 'ipsec'. Requires the `ipsec_policy` feature.

* `ipset`: Matches IP sets. Value must be 'ipset_name (src|dst|src,dst)' and can be negated by putting ! in front. Requires ipset kernel module.

* `isfirstfrag`: If true, matches when the packet is the first fragment of a fragmented ipv6 packet. Cannot be negated. Supported by ipv6 only. Valid values are 'true', 'false'. Requires the `isfirstfrag` feature.

* `isfragment`: If 'true', matches when the packet is a tcp fragment of a fragmented packet. Supported by iptables only. Valid values are 'true', 'false'. Requires features `isfragment`.

* `ishasmorefrags`: If 'true', matches when the packet has the 'more fragments' bit set. Supported by ipv6 only. Valid values are 'true', 'false'. Requires the `ishasmorefrags` feature.

* `islastfrag`: If true, matches when the packet is the last fragment of a fragmented ipv6 packet. Supported by ipv6 only. Valid values are 'true', 'false'. Requires the `islastfrag`.

* `jump`: The value for the iptables `--jump` parameter. Any valid chain name is allowed, but normal values are: 'QUEUE', 'RETURN', 'DNAT', 'SNAT', 'LOG', 'MASQUERADE', 'REDIRECT', 'MARK'.

  For the values 'ACCEPT', 'DROP', and 'REJECT', you must use the generic `action` parameter. This is to enforce the use of generic parameters where possible for maximum cross-platform modeling.

  If you set both `accept` and `jump` parameters, you will get an error, because only one of the options should be set. Requires the `iptables` feature.

* `limit`: Rate limiting value for matched packets. The format is: 'rate/[/second/|/minute|/hour|/day]'. Example values are: '50/sec', '40/min', '30/hour', '10/day'. Requires the  `rate_limiting` feature.

* `line`: Read-only property for caching the rule line.

* `log_level`: When combined with `jump => 'LOG'` specifies the system log level to log to. Requires the `log_level` feature.

* `log_prefix`: When combined with `jump => 'LOG'` specifies the log prefix to use when logging. Requires the `log_prefix` feature.

* `mask`: Sets the mask to use when `recent` is enabled. Requires the `mask` feature.

* `name`: The canonical name of the rule. This name is also used for ordering, so make sure you prefix the rule with a number. For example:

```puppet
firewall { '000 this runs first':
  # this rule will run first
}
firewall { '999 this runs last':
  # this rule will run last
}
 ```

  Depending on the provider, the name of the rule can be stored using the comment feature of the underlying firewall subsystem. Values must match '/^\d+[[:alpha:][:digit:][:punct:][:space:]]+$/'.

* `outiface`: Output interface to filter on. Values must match '/^!?\s?[a-zA-Z0-9\-\._\+\:]+$/'.  Requires the `interface_match` feature.  Supports interface alias (eth0:0) and negation.

* `physdev_in`: Match if the packet is entering a bridge from the given interface. Values must match '/^[a-zA-Z0-9\-\._\+]+$/'.

* `physdev_out`: Match if the packet is leaving a bridge via the given interface. Values must match '/^[a-zA-Z0-9\-\._\+]+$/'.

* `physdev_is_bridged`: Match if the packet is transversing a bridge. Valid values are true or false.

* `pkttype`: Sets the packet type to match. Valid values are: 'unicast', 'broadcast', and'multicast'. Requires the `pkttype` feature.

* `port`: The destination or source port to match for this filter (if the protocol supports ports). Will accept a single element or an array. For some firewall providers you can pass a range of ports in the format: 'start number-end number'. For example, '1-1024' would cover ports 1 to 1024.

* `proto`: The specific protocol to match for this rule. This is 'tcp' by default. Valid values are:
  * 'tcp'
  * 'udp'
  * 'icmp'
  * 'ipv6-icmp'
  * 'esp'
  * 'ah'
  * 'vrrp'
  * 'igmp'
  * 'ipencap'
  * 'ospf'
  * 'gre'
  * 'all'

* `provider`: The specific backend to use for this firewall resource. You will seldom need to specify this --- Puppet will usually discover the appropriate provider for your platform. Available providers are ip6tables and iptables. See the [Providers](#providers) section above for details about these providers.

 * `random`: When using a `jump` value of 'MASQUERADE', 'DNAT', 'REDIRECT', or 'SNAT', this boolean will enable randomized port mapping. Valid values are true or false. Requires the `dnat` feature.

* `rdest`: If boolean 'true', adds the destination IP address to the list. Valid values are true or false. Requires the `recent_limiting` feature and the `recent` parameter.

* `reap`: Can only be used in conjunction with the `rseconds` parameter. If boolean 'true', this will purge entries older than 'seconds' as specified in `rseconds`. Valid values are true or false. Requires the `recent_limiting` feature and the `recent` parameter.

* `recent`: Enable the recent module. Valid values are: 'set', 'update', 'rcheck', or 'remove'. For example:

```puppet
# If anyone's appeared on the 'badguy' blacklist within
# the last 60 seconds, drop their traffic, and update the timestamp.
firewall { '100 Drop badguy traffic':
  recent   => 'update',
  rseconds => 60,
  rsource  => true,
  rname    => 'badguy',
  action   => 'DROP',
  chain    => 'FORWARD',
}
# No-one should be sending us traffic on eth0 from localhost
# Blacklist them
firewall { '101 blacklist strange traffic':
  recent      => 'set',
  rsource     => true,
  rname       => 'badguy',
  destination => '127.0.0.0/8',
  iniface     => 'eth0',
  action      => 'DROP',
  chain       => 'FORWARD',
}
```

  Requires the `recent_limiting` feature.

* `reject`: When combined with `jump => 'REJECT'`, you can specify a different ICMP response to be sent back to the packet sender. Requires the `reject_type` feature.

* `rhitcount`: Used in conjunction with `recent => 'update'` or `recent => 'rcheck'`. When used, this will narrow the match to happen only when the address is in the list and packets greater than or equal to the given value have been received. Requires the `recent_limiting` feature and the `recent` parameter.

* `rname`: Specify the name of the list. Takes a string argument. Requires the `recent_limiting` feature and the `recent` parameter.

* `rseconds`: Used in conjunction with `recent => 'rcheck'` or `recent => 'update'`. When used, this will narrow the match to only happen when the address is in the list and was seen within the last given number of seconds. Requires the `recent_limiting` feature and the `recent` parameter.

* `rsource`: If boolean 'true', adds the source IP address to the list. Valid values are 'true', 'false'. Requires the `recent_limiting` feature and the `recent` parameter.

* `rttl`: May only be used in conjunction with `recent => 'rcheck'` or `recent => 'update'`. If boolean 'true', this will narrow the match to happen only when the address is in the list and the TTL of the current packet matches that of the packet that hit the `recent => 'set'` rule. If you have problems with DoS attacks via bogus packets from fake source addresses, this parameter may help. Valid values are 'true', 'false'. Requires the `recent_limiting` feature and the `recent` parameter.

* `set_mark`: Set the Netfilter mark value associated with the packet. Accepts either  'mark/mask' or 'mark'. These will be converted to hex if they are not already. Requires the `mark` feature.

* `socket`: If 'true', matches if an open socket can be found by doing a socket lookup on the packet. Valid values are 'true', 'false'. Requires the `socket` feature.

* `source`: The source address. For example: `source => '192.168.2.0/24'`. You can also negate a mask by putting ! in front. For example: `source => '! 192.168.2.0/24'`. The source can also be an IPv6 address if your provider supports it.

* `sport`: The source port to match for this filter (if the protocol supports ports). Will accept a single element or an array. For some firewall providers you can pass a range of ports in the format:'start number-end number'. For example, '1-1024' would cover ports 1 to 1024.

* `src_range`: The source IP range. For example: `src_range => '192.168.1.1-192.168.1.10'`. The source IP range must be in 'IP1-IP2' format. Values in the range must be valid IPv4 or IPv6 addresses. Requires the `iprange` feature.

* `src_type`: Specify the source address type. For example: `src_type => 'LOCAL'`.

  Valid values are:

  * 'UNSPEC': an unspecified address.
  * 'UNICAST': a unicast address.
  * 'LOCAL': a local address.
  * 'BROADCAST': a broadcast address.
  * 'ANYCAST': an anycast packet.
  * 'MULTICAST': a multicast address.
  * 'BLACKHOLE': a blackhole address.
  * 'UNREACHABLE': an unreachable address.
  * 'PROHIBIT': a prohibited address.
  * 'THROW': an unroutable address.
  * 'XRESOLVE': an unresolvable address.

  Requires the `address_type` feature.

* `stat_every`: Match one packet every nth packet. Requires `stat_mode => 'nth'`

* `stat_mode`: Set the matching mode for statistic matching. Supported modes are `random` and `nth`.

* `stat_packet`: Set the initial counter value for the nth mode. Must be between 0 and the value of `stat_every`. Defaults to 0. Requires `stat_mode => 'nth'`

* `stat_probability`: Set the probability from 0 to 1 for a packet to be randomly matched. It works only with `stat_mode => 'random'`.

* `state`: Matches a packet based on its state in the firewall stateful inspection table. Valid values are: 'INVALID', 'ESTABLISHED', 'NEW', 'RELATED'. Requires the `state_match` feature.

* `table`: Table to use. Valid values are: 'nat', 'mangle', 'filter', 'raw', 'rawpost'. By default the setting is 'filter'. Requires the `iptables` feature.

* `tcp_flags`: Match when the TCP flags are as specified. Set as a string with a list of comma-separated flag names for the mask, then a space, then a comma-separated list of flags that should be set. The flags are: 'SYN', 'ACK', 'FIN', 'RST', 'URG', 'PSH', 'ALL', 'NONE'.

   Note that you specify flags in the order that iptables `--list` rules would list them to avoid having Puppet think you changed the flags. For example, 'FIN,SYN,RST,ACK SYN' matches packets with the SYN bit set and the ACK, RST and FIN bits cleared. Such packets are used to request TCP connection initiation. Requires the `tcp_flags` feature.

* `todest`: When using `jump => 'DNAT'`, you can specify the new destination address using this parameter. Requires the `dnat` feature.

* `toports`: For DNAT this is the port that will replace the destination port. Requires the `dnat` feature.

* `tosource`: When using `jump => 'SNAT'`, you can specify the new source address using this parameter. Requires the `snat` feature.

* `to`: When using `jump => 'NETMAP'`, you can specify a source or destination subnet to nat to. Requires the `netmap` feature`.

* `uid`: UID or Username owner matching rule. Accepts a string argument only, as iptables does not accept multiple uid in a single statement. Requires the `owner` feature.

###Type: firewallchain

Enables you to manage rule chains for firewalls.

Currently this type supports only iptables, ip6tables, and ebtables on Linux. It also provides support for setting the default policy on chains and tables that allow it.

**Autorequires**: If Puppet is managing the iptables or iptables-persistent packages, and the provider is iptables_chain, the firewall resource will autorequire those packages to ensure that any required binaries are installed.

####Providers

`iptables_chain` is the only provider that supports firewallchain.

####Features

* `iptables_chain`: The provider provides iptables chain features.
* `policy`: Default policy (inbuilt chains only).

####Parameters

* `ensure`: Ensures that the resource is present. Valid values are 'present', 'absent'.

* `ignore`: Regex to perform on firewall rules to exempt unmanaged rules from purging (when enabled). This is matched against the output of iptables-save. This can be a single regex or an array of them. To support flags, use the ruby inline flag mechanism: a regex such as '/foo/i' can be written as '(?i)foo' or '(?i:foo)'. Only when purge is 'true'.

  Full example:
```puppet
firewallchain { 'INPUT:filter:IPv4':
  purge  => true,
  ignore => [
    # ignore the fail2ban jump rule
    '-j fail2ban-ssh',
    # ignore any rules with "ignore" (case insensitive) in the comment in the rule
    '--comment "[^"](?i:ignore)[^"]"',
    ],
}
```

* `name`: Specify the canonical name of the chain. For iptables the format must be {chain}:{table}:{protocol}.

* `policy`: Set the action the packet will perform when the end of the chain is reached. It can only be set on inbuilt chains ('INPUT', 'FORWARD', 'OUTPUT', 'PREROUTING', 'POSTROUTING'). Valid values are:

  * 'accept': The packet is accepted.
  * 'drop': The packet is dropped.
  * 'queue': The packet is passed userspace.
  * 'return': The packet is returned to calling (jump) queue or to the default of inbuilt chains.

* `provider`: The specific backend to use for this firewallchain resource. You will seldom need to specify this --- Puppet will usually discover the appropriate provider for your platform. The only available provider is:

  `iptables_chain`: iptables chain provider

    * Required binaries: `ebtables-save`, `ebtables`, `ip6tables-save`, `ip6tables`, `iptables-save`, `iptables`.
    * Default for `kernel` == `linux`.
    * Supported features: `iptables_chain`, `policy`.

* `purge`: Purge unmanaged firewall rules in this chain. Valid values are 'false', 'true'.

###Fact: ip6tables_version

A Facter fact that can be used to determine what the default version of ip6tables is for your operating system/distribution.

###Fact: iptables_version

A Facter fact that can be used to determine what the default version of iptables is for your operating system/distribution.

###Fact: iptables_persistent_version

Retrieves the version of iptables-persistent from your OS. This is a Debian/Ubuntu specific fact.

##Limitations

###SLES

The `socket` parameter is not supported on SLES.  In this release it will cause
the catalog to fail with iptables failures, rather than correctly warn you that
the features are unusable.

###Oracle Enterprise Linux

The `socket` and `owner` parameters are unsupported on Oracle Enterprise Linux
when the "Unbreakable" kernel is used. These may function correctly when using
the stock RedHat kernel instead. Declaring either of these parameters on an
unsupported system will result in iptable rules failing to apply.

###Other

Bugs can be reported using JIRA issues

<http://tickets.puppetlabs.com>

##Development

Puppet Labs modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great. We can’t access the huge number of platforms and myriad of hardware, software, and deployment configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our modules work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)

For this particular module, please also read CONTRIBUTING.md before contributing.

Currently we support:

* iptables
* ip6tables
* ebtables (chains only)

###Testing

Make sure you have:

* rake
* bundler

Install the necessary gems:

    bundle install

And run the tests from the root of the source code:

    rake test

If you have a copy of Vagrant 1.1.0 you can also run the system tests:

    RS_SET=ubuntu-1404-x64 rspec spec/acceptance
    RS_SET=centos-64-x64 rspec spec/acceptance