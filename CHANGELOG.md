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
