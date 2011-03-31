define haproxy::set ($ensure) {
	haproxy::augeas { $name:
		changes => "set '${name}' '${ensure}'"
	}
}
