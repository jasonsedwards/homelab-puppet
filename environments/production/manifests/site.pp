# Global exec to avoid using exec path everywhere. http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin" ] }

Package {
    allow_virtual => true,
}

node default {
    hiera_include('classes')
}
