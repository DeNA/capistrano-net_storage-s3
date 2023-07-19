[![Gem Version](https://badge.fury.io/rb/capistrano-net_storage-s3.svg)](https://badge.fury.io/rb/capistrano-net_storage-s3)
[![Build Status](https://travis-ci.org/DeNADev/capistrano-net_storage-s3.svg?branch=master)](https://travis-ci.org/DeNADev/capistrano-net_storage-s3)
# Capistrano::NetStorage::S3

**Capistrano::NetStorage::S3** is a transport plugin of
[Capistrano::NetStorage](https://github.com/DeNADev/capistrano-net_storage) to deploy application
via [Amazon S3](https://aws.amazon.com/s3/).  
And Capistrano::NetStorage is a plugin of [Capistrano](http://capistranorb.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-net_storage-s3', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-net_storage-s3

## Configuration

Set Capistrano variables by `set name, value`.

 Name | Default | Description
------|---------|------------
 `:net_storage_transport` | NO DEFAULT | Set `Capistrano::NetStorage::S3::Transport`
 `:net_storage_s3_bucket` | NO DEFAULT | S3 bucket name
 `:net_storage_s3_broker` | `:aws_cli` | Type of transportation broker
 `:net_storage_s3_aws_access_key_id` | `ENV['AWS_ACCESS_KEY_ID']` | AWS Access Key ID
 `:net_storage_s3_aws_secret_access_key` | `ENV['AWS_SECRET_ACCESS_KEY']` | AWS Secret Access Key
 `:net_storage_s3_aws_session_token` | `ENV['AWS_SESSION_TOKEN']` | AWS Session Token
 `:net_storage_s3_aws_region` | `ENV['AWS_DEFAULT_REGION']` | AWS Region
 `:net_storage_s3_aws_profile` | `ENV['AWS_DEFAULT_PROFILE']` | AWS Profile
 `:net_storage_s3_aws_config_file` | `ENV['AWS_CONFIG_FILE']` | AWS Config File
 `:net_storage_s3_archives_directory` | `nil` | Directory for application archives in S3 bucket
 `:net_storage_s3_keep_releases` | `:keep_releases` | Number to keep archives in S3
 `:net_storage_s3_max_retry` | `3` | Max retry times for S3 operations

See also
[the configuration section of Capistrano::NetStorage](https://github.com/DeNADev/capistrano-net_storage#configuration).

## Usage

Edit Capfile:

```ruby
# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
require "capistrano/net_storage/plugin"
install_plugin Capistrano::NetStorage::Plugin

# Load transport plugin for Capistrano::NetStorage
require 'capistrano/net_storage/s3'
```

Edit your `config/deploy.rb`:

```ruby
set :net_storage_transport, Capistrano::NetStorage::S3::Transport
set :net_storage_config_files, Pathname('path/to/config').glob('*.yml')
set :net_storage_s3_bucket, 'example-bucket'
```

## Example

You can see typical usage of this library by
[capistrano-net_storage_demo](https://github.com/DeNADev/capistrano-net_storage_demo/tree/net_storage-s3).

## License

Available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Copyright (c) 2017 DeNA Co., Ltd., IKEDA Kiyoshi

