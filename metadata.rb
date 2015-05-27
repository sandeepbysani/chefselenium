name 'selenium'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Installs/Configures Selenium'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.2.5'

supports 'centos'
supports 'redhat'
supports 'ubuntu'
supports 'windows'

suggests 'windows', '~> 1.0'
suggests 'nssm', '~> 1.0'
