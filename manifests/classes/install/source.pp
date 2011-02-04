# Class: haproxy::install::source
#
#
class haproxy::install::source {
	include buildenv::c
	include buildenv::packages::libpcre3
	
	common::archive { "haproxy-${haproxy::params::version}":
		ensure   => present,
		url      => "http://haproxy.1wt.eu/download/1.4/src/haproxy-${haproxy::params::version}.tar.gz",
		timeout  => 600,
		target   => "${haproxy::params::unpack_root}",
		notify	 => Exec["make-haproxy"]
	}

	exec { "make-haproxy":
		command     => "/usr/bin/make TARGET=linux26 ARCH=${architecture} USE_PCRE=1",
		cwd         => "${haproxy::params::unpack_root}/haproxy-${haproxy::params::version}",
		creates     => "${haproxy::params::unpack_root}/haproxy-${haproxy::params::version}/haproxy",
		refreshonly => true,
		notify		=> Exec["make-install-haproxy"],
		require     => [ Common::Archive["haproxy-${haproxy::params::version}"], Class["buildenv::c"], Class["buildenv::packages::libpcre3"] ]
	}

	exec { "make-install-haproxy":
		command     => "/usr/bin/make install PREFIX=/usr DOCDIR=/usr/share/doc/haproxy ",
		cwd         => "${haproxy::params::unpack_root}/haproxy-${haproxy::params::version}",
		creates     => "/usr/sbin/haproxy",
		refreshonly => true,
		require     => Exec["make-haproxy"]
	}
}