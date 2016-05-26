class profile::base {
  include ::ssh

  file { '/etc/motd':
    ensure => file,
    mode => 755,
    source => "puppet:///modules/profile/etc/motd",
  }  
}
