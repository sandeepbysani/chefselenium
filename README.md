# Selenium Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/selenium.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-selenium.svg?style=flat-square)][travis]
[![GitHub Issues](http://img.shields.io/github/issues/dhoer/chef-selenium.svg?style=flat-square)][github]

[supermarket]: https://supermarket.chef.io/cookbooks/selenium
[travis]: https://travis-ci.org/dhoer/chef-selenium
[github]: https://github.com/dhoer/chef-selenium/issues

This cookbook installs and configures Selenium and WebDriver components (http://www.seleniumhq.org/).

This cookbook comes with the following Resource/Providers:

- **[selenium_hub](https://github.com/dhoer/chef-selenium#selenium_hub)** - Installs and configures selenium-grid hubs.
- **[selenium_node](https://github.com/dhoer/chef-selenium#selenium_node)** - Installs and configures selenium-grid
nodes
with support for [ChromeDriver](http://chromedriver.storage.googleapis.com/index.html),
[FirefoxDriver](https://code.google.com/p/selenium/wiki/FirefoxDriver),
[HtmlUnitDriver](https://code.google.com/p/selenium/wiki/HtmlUnitDriver), and
[InternetExplorerDriver](https://code.google.com/p/selenium/wiki/InternetExplorerDriver).
- **[selenium_phantomjs](https://github.com/dhoer/chef-selenium#selenium_phantomjs)** - Installs and configures
[PhantomJS](http://phantomjs.org/) as a selenium-grid node or as a standalone server via
[GhostDriver](https://github.com/detro/ghostdriver).

#### Roadmap

Add support for the following (any volunteers?):

- Mac OS X platform
- [Appium](http://appium.io)

## Requirements

Chef 11 or greater

### Platforms

- CentOS, RedHat
- Ubuntu
- Windows

### Cookbooks

These cookbooks are referenced with suggests, so be sure to depend on cookbooks that apply:

- windows
- nssm - Required for Windows services only (e.g. Hub, PhantomJS, and HtmlUnit running in background)

## Usage

See [selenium_test](https://github.com/dhoer/chef-selenium/tree/master/test/fixtures/cookbooks/selenium_test)
cookbook for working cross platform examples. Note that the provided examples in this cookbook have passwords
unencrypted for simplicity.

## selenium_hub

Installs and configures selenium-grid hubs.

#### Requirements

- Java must be installed outside of this cookbook.

### Example

##### Install selenium-grid hub

```ruby
selenium_hub 'selenium_hub' do
  action :install
end
```

#### Attributes

This is a partial list of attributes available.  See
[hub](https://github.com/dhoer/chef-selenium/blob/master/resources/hub.rb)
resource for the complete listing of attributes.

- `name` - Name attribute. The name of the service.
- `host` - Hostname. Defaults to `null`.
- `port` - Port.  Defaults to `4444`.

## selenium_node

Installs and configures selenium-grid nodes with support for
[ChromeDriver](http://chromedriver.storage.googleapis.com/index.html),
[FirefoxDriver](https://code.google.com/p/selenium/wiki/FirefoxDriver),
[HtmlUnitDriver](https://code.google.com/p/selenium/wiki/HtmlUnitDriver), and
[InternetExplorerDriver](https://code.google.com/p/selenium/wiki/InternetExplorerDriver).

#### Requirements

- Java must be installed outside of this cookbook.
- Browsers (e.g., chrome, firefox, etc...) must be installed outside of this cookbook.
- Linux nodes without a physical monitor require a headless display
(e.g., [xvfb](https://supermarket.chef.io/cookbooks/xvfb), [x11vnc](https://supermarket.chef.io/cookbooks/x11vnc),
etc...) and must be installed and configured outside this cookbook.
- Windows nodes (with the exception of HtmlUnitDriver) must run in the foreground and that requires a username
and password for auto-logon. Note that the password is stored unencrypted under windows registry:
`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.


### Example

##### Install selenium-grid node with Chrome, Firefox, HtmlUnit and Internet Explorer capability

```ruby
selenium_node 'selenium_node' do
  username 'Administrator' if platform?('windows')
  password 'password' if platform?('windows')
  capabilities [
    {
      browserName: 'chrome',
      maxInstances: 5,
      seleniumProtocol: 'WebDriver'
    },
    {
      browserName: 'firefox',
      maxInstances: 5,
      seleniumProtocol: 'WebDriver'
    },
    {
      browserName: 'htmlunit',
      maxInstances: 1,
      platform: 'ANY',
      seleniumProtocol: 'WebDriver'
    },
    {
      browserName: 'internet explorer',
      maxInstances: 1,
      seleniumProtocol: 'WebDriver'
    }
  ]
  action :install
end
```

#### Attributes

This is a partial list of attributes available.  See
[node](https://github.com/dhoer/chef-selenium/blob/master/resources/node.rb)
resource for the complete listing of attributes.

- `name` - Name attribute. The name of the service or Windows foreground startup script.
- `host` - Hostname. Defaults to `null`.
- `port` - Port.  Defaults to `5555`.
- `hubHost` - Selenium-grid hub hostname. Defaults to `ip`.
- `hubPort` - Selenium-grid hub port. Defaults to `4444`.
- `capabilities` - The following drivers are supported and installed based on
[capabilities](https://code.google.com/p/selenium/wiki/DesiredCapabilities):
    - [ChromeDriver](http://chromedriver.storage.googleapis.com/index.html) -
Installed if capabilities contains browser name `chrome`
    - [FirefoxDriver](https://code.google.com/p/selenium/wiki/FirefoxDriver) - Pre-installed with Selenium server
    - [HtmlUnitDriver](https://code.google.com/p/selenium/wiki/HtmlUnitDriver) - Pre-installed with Selenium server
    - [InternetExplorerDriver](https://code.google.com/p/selenium/wiki/InternetExplorerDriver) - 32-bit or 64-bit
installed if capabilities contains browser name `internet explorer`
- Windows only - Set both username and password to run service in foreground or leave nil to run service in background:
    - `username` - Windows account username. Defaults to `nil`.
    - `password` - Windows account password. Defaults to `nil`. Note that the password is stored unencrypted under
    windows registry: `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.
    - `domain` - Windows account domain. Optional.  Defaults to `nil`.


## selenium_phantomjs

Installs and configures [PhantomJS](http://phantomjs.org/) as a selenium-grid node or as a standalone server via
[GhostDriver](https://github.com/detro/ghostdriver).

#### Requirements

- [PhantomJS](http://phantomjs.org/) must be installed outside of this cookbook.
- Windows nodes have the option to run in the foreground and that requires a username and password for auto-logon.
Note that the password is stored unencrypted under windows registry:
`HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.

#### Examples

##### Install PhantomJS as a selenium-grid node

```ruby
selenium_phantomjs 'selenium_phantomjs' do
  action :install
end
```

##### Install PhantomJS as a standalone server by setting webdriverSeleniumGridHub to false

```ruby
selenium_phantomjs 'selenium_phantomjs_nogrid' do
  webdriverSeleniumGridHub false
  action :install
end
```

#### Attributes

This is a partial list of attributes available. See
[phantomjs](https://github.com/dhoer/chef-selenium/blob/master/resources/phantomjs.rb)
resource for the complete listing of attributes.

- `name` - Name attribute. The name of the service or Windows foreground startup script.
- `webdriver` - Webdriver ip:port.  Defaults to `#{node['ipaddress']}:8910`.
- `webdriverSeleniumGridHub` -  Webdriver selenium-grid hub url.  Set to `false` to install PhantomJS as a standalone
service. Defaults to `http://#{node['ipaddress']}:4444`.
- Windows only - Set both username and password to run service in foreground or leave nil to run service in background:
    - `username` - Windows account username. Defaults to `nil`.
    - `password` - Windows account password. Defaults to `nil`. Note that the password is stored unencrypted under
    windows registry: `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`.
    - `domain` - Windows account domain. Optional.  Defaults to `nil`.

## ChefSpec Matchers

The Selenium cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test 
your own cookbooks.

Example Matcher Usage

```ruby
expect(chef_run).to install_selenium_hub('resource_name').with(
  port: '4444'
)
```
      
Selenium Cookbook Matchers

- install_selenium_hub(resource_name)
- install_selenium_node(resource_name)
- install_selenium_phantomjs(resource_name)

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/chef-selenium).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-selenium/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-selenium/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-selenium/blob/master/LICENSE.md) file for details.
