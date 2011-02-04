# Class: haproxy::params
#
#
class haproxy::params {
	$install_mode = $haproxy_install_mode ? {
		"package" => "package",
		"source"  => "source",
		default   => "package"
	}
	
	$version = $install_mode ? {
		"package" => $haproxy_version ? {
			""      => "latest",
			default => $haproxy_version
		},
		"source"  => $haproxy_version ? {
			""      => "1.4.10",
			default => $haproxy_version
		}
	}
	
	$unpack_root = $haproxy_unpack_root ? {
		""      => "/usr/src",
		default => $haproxy_unpack_root
	}
	
	$configdir = $haproxy_configdir ? {
		""      => "/etc/haproxy",
		default => $haproxy_configdir
	}
}
