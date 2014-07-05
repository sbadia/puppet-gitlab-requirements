# == Class: gitlab_requirements
#
# Install all reguirements needed by gitlab
# See puppet-gitlab module.
#
# === Parameters:
#
# [*gitlab_dbname*]
#  (optional) Gitlab database name
#   Defaults to 'gitlab'
#
# [*gitlab_dbuser*]
#  (optional) Gitlab database user
#   Defaults to 'gitlab'
#
# [*gitlab_dbpwd*]
#  (optional) Gitlab database password
#   Defaults to 'changeme'
#
# === Authors:
#
# Andrew Tomaka <atomaka@gmail.com>
# Sebastien Badia <seb@sebian.fr>
#
class gitlab_requirements(
  $gitlab_dbname = 'gitlab',
  $gitlab_dbuser = 'gitlab',
  $gitlab_dbpwd  = 'changeme') {
  include redis
  include nginx
  include mysql::server
  include git
  include logrotate

  mysql::db {
    $gitlab_dbname:
      user     => $gitlab_dbuser,
      password => $gitlab_dbpwd,
  }

  anchor { 'gitlab_requirements::begin': }
  anchor { 'gitlab_requirements::end': }

  Anchor['gitlab_requirements::begin'] ->
  Class['logrotate'] ->
  Class['redis'] ->
  Class['nginx'] ->
  Class['git'] ->
  Class['mysql::server'] ->
  Mysql::Db[$gitlab_dbname] ->
  Anchor['gitlab_requirements::end']

}
