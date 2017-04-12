require 'capistrano/net_storage/s3/base'
require 'capistrano/net_storage/s3/error'
require 'capistrano/net_storage/s3/config'
require 'capistrano/net_storage/s3/broker/aws_cli'
require 'capistrano/net_storage/s3/transport'
require 'capistrano/net_storage/s3/version'

Capistrano::NetStorage::S3.setup!(config: Capistrano::NetStorage::S3::Config.new)
