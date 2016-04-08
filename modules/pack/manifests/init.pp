class pack {
  Package { ensure => 'installed' }
  Exec { path => '/usr/bin/' }

  $reversing = ['radare2', 'gdb']
  $binary_analysis = ['binwalk', 'strace', 'ltrace', 'exiv2', 'elfkickers']
  $net = ['lsof', 'wget', 'curl', 'gnu-netcat', 'nmap']
  $utils = ['vim', 'checksec', 'git', 'net-tools', 'tmux']
  $emulation = ['qemu']
  $languages = ['python', 'python-pip', 'ipython2']
  $crypto = ['john']

  package { $reversing: }
  package { $binary_analysis: }
  package { $net: }
  package { $utils: }
  package { $emulation: }
  package { $languages: }
  package { $crypto: }

  exec { 'dotfiles':
    command => 'git clone https://www.github.com/metiu07/dotfiles /home/vagrant/dotfiles/',
    user    => 'vagrant',
    creates => '/home/vagrant/dotfiles'
  }

  file { '/home/vagrant/dotfiles':
    ensure  => directory,
    recurse => true,
    owner   => 'vagrant',
  }

  exec { 'install-dotfiles':
    user    => 'vagrant',
    command => '/home/vagrant/dotfiles/install.sh'
  }

  exec { 'mkdir':
    command => 'mkdir /vagrant/dev',
    creates => '/vagrant/dev',
    user    => 'vagrant'
  }

  file { '/home/vagrant/dev/':
    ensure => 'link',
    target => '/vagrant/dev'
  }

}
