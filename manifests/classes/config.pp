# Class: haproxy::config
#
#
class haproxy::config {
	include augeas
	
	File {
		owner   => root,
		group   => root,
		require => Class["haproxy::install::${haproxy::params::install_mode}"]
	}
	
	if ( $operatingsystem =~ /(?i)(Debian|Ubuntu)/ ) {
		file { "haproxy-default":
			name    => "/etc/default/haproxy",
			ensure  => present,
			mode    => 644
		}
		
		augeas { "enable-haproxy" :
			context => "/files/etc/default/haproxy",
			changes => "set ENABLED 1",
			onlyif  => "get ENABLED != 1",
			require => File["haproxy-default"]
		}
	}
	
	file { "/etc/init.d/haproxy":
		ensure => present,
		owner  => root,
		group  => root,
		mode   => 755,
		source => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => "puppet:///modules/haproxy/haproxy-init.debian",
			/(?i)(RedHat|CentOS)/ => "puppet:///modules/haproxy/haproxy-init.redhat"
		},
		notify => Class["haproxy::service"]
	}
	
	file { $haproxy::params::configdir:
		ensure => directory
	}
	
	file { "haproxy-config":
		name    => "${haproxy::params::configdir}/haproxy.cfg",
		ensure  => present,
		mode    => 644,
		source  => "puppet:///modules/haproxy/haproxy.cfg",
		notify  => Class["haproxy::service"],
		require => File[$haproxy::params::configdir]
	}

	# Augeas lens
	file { "/usr/share/augeas/lenses/haproxy.aug":
		ensure  => present,
		source  => "puppet:///modules/haproxy/haproxy.aug",
		mode    => 644,
		require => Class["augeas"]
	}
}
