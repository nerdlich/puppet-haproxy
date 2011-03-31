# Class: haproxy::config::augeas
#
#
class haproxy::config::augeas {
	include augeas
	
	File {
		owner   => root,
		group   => root,
		require => Class["haproxy::config"]
	}
		
	file { "${haproxy::params::configdir}/haproxy.cfg":
		ensure  => present,
		mode    => 644,
		notify  => Class["haproxy::service"]
	}

	# Augeas lens
	file { "/usr/share/augeas/lenses/contrib/haproxy.aug":
		ensure  => present,
		source  => "puppet:///modules/haproxy/haproxy.aug",
		mode    => 644,
		require => Class["augeas"]
	}
	
	Haproxy::Augeas {
		require => [ Class["haproxy::config"], File["/usr/share/augeas/lenses/contrib/haproxy.aug"] ],
		notify  => Class["haproxy::service"]
	}
	
	haproxy::augeas { "managed-by-puppet":
		changes => [
			"ins #comment before global",
			"set global/#comment 'file managed by puppet'"
		],
		require => Haproxy::Augeas["global"]
	}
	
	haproxy::augeas { "global":
		section => "global",
		changes => [
			"set log[1] '127.0.0.1 local0'",
			"set log[2] '127.0.0.1 local1 notice'",
			"set maxconn 4096",
			"set user ${haproxy::params::user}",
			"set group ${haproxy::params::group}",
			"clear daemon"
		]
	}
	
	haproxy::augeas { "defaults":
		section => "defaults",
		changes => [
			"set log global",
			"set mode http",
			"set retries 3",
			"set maxconn 2000",
			"set contimeout 5000",
			"set clitimeout 50000",
			"set srvtimeout 50000"
		],
		require => Haproxy::Augeas["global"]
	}
}