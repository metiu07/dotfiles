file { "/etc/resolv.conf":
  ensure  => present,
  content => "nameserver 8.8.8.8"
}

include pack
