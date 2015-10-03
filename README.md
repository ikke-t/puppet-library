# puppet-library

This is a simple tool to help installing Puppet modules with [librarian-puppet](https://github.com/rodjek/librarian-puppet). It is designed to be used in a single run bootstap and currently supports only Ubuntu and Fedora.

Puppet is not supported yet in Fedora 22 and above (https://tickets.puppetlabs.com/browse/CPR-167), but this tool should work on it after puppet gets fixed.

Define puppetfile as explained in librarian-puppet's instructions. Example:
```
#!/usr/bin/env ruby
forge "https://forgeapi.puppetlabs.com"
mod "puppetlabs-stdlib"
mod "puppetlabs-apache"
mod "puppetlabs-apt"
```

Write the puppetfile contents to a file and then call puppet apply:
```
FACTER_puppetfile=filename puppet apply library.pp
```
Make sure you have puppet installed before running puppet apply.
