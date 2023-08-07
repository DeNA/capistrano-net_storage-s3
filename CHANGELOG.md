## 1.0.0 (2023/08/07)

Major Update by @aeroastro

Improvement:

* `--no-progress` option is passed to `aws cp` to keep console quiet (#7)
* README.md has been changed not to `require 'capistrano-net_storage-s3` by bundler (#8)
* Major improvement for `Capistrano::NetStorage` version 1.0.0 (#9, #10, #11)
* GitHub Actions has been introduced (#12)

## 0.2.3 (2017/5/10)

Enhancement:

- Add a config `:net_storage_s3_keep_release` as number to keep archives on S3
(#4)

## 0.2.2 (2017/5/9)

Feature:

- Implement `Capistrano::NetStorage::S3::Broker::AwsCLI#cleanup` to purge old
archives on S3 (#3)

## 0.2.1 (2017/4/21)

Internal Changes (#2):

- `Capistrano::NetStorage::S3::Broker::AwsCLI` :
  - Use `run_locally` instead of `on :local`
  - Trap `SSHKit::StandardError` when finding an archive fails

## 0.2.0 (2017/4/12)

Initial release.
