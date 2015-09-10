# Appium Mobile Grid Example

## Getting Started

Assumptions:
  * You have Android Studios installed.
  * You have npm & Appium installed. https://www.npmjs.com/package/appium
  * You're running this on a mac. Though, this shouldn't be too different to run on other platforms.
  * You have Homebrew installed. http://brew.sh/
  * You have android emulators setup or connected devices with usb debug enabled.

To set up:

* Ensure you running at least Ruby version 2.0 or above. You can check this by
  running:

  `ruby -v`

  If you have an older version of Ruby installed, consider using
  [rbenv](https://github.com/sstephenson/rbenv) for installing a newer version
  of Ruby.

* Install Bundler:

  `gem install bundler`

* Run bundle install:

  `bundle install`

* Install Allure Report: https://github.com/allure-framework/allure-cli

  `brew tap allure-framework/allure`
  
  `brew install allure-cli`

## Running Specs

* Start emulators or connect devices!

To run specs in parallel: 

  `rake android[parallel]`

To run specs distributed:

  `rake android[distribute]`
