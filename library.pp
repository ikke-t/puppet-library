package { [ 'ruby-dev', 'git', 'make' ]:
        ensure => 'present',
}

package { 'librarian-puppet':
        ensure   => 'installed',
        provider => 'gem',
        require  => Package['ruby-dev', 'git', 'make'],
}

exec { 'init-librarian':
        environment => [ "HOME=/root", "USER=root" ],
        command => '/usr/local/bin/librarian-puppet init',
        cwd => '/etc/puppet',
        creates => '/etc/puppet/Puppetfile',
        require => [ Package['librarian-puppet'], Package['git'] ],
}

if $puppetfile {
        file { '/etc/puppet/Puppetfile':
                ensure => 'present',
                source => $puppetfile,
                require => Exec['init-librarian'],
                notify => Exec['librarian-install-modules'],
        }

        if ($replace == "true") {
                exec { 'replace-existing-library':
                        cwd     => '/etc/puppet',
                        command => '/bin/rm -f /etc/puppet/Puppetfile.lock && /bin/touch /etc/puppet/.Puppetfile.lock.library',
                        creates => '/etc/puppet/.Puppetfile.lock.library',
                        before  => Exec['librarian-install-modules'],
                }
        }

        exec { 'librarian-install-modules':
                environment => [ "HOME=/root", "USER=root" ],
                command => '/usr/local/bin/librarian-puppet install --verbose',
                cwd => '/etc/puppet',
                refreshonly => true,
                require => File['/etc/puppet/Puppetfile'],
        }
}

