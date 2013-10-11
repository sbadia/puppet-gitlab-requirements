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

  class { 'ruby':
    version         => '1:1.9.3',
    rubygems_update => false;
  }

  class { 'ruby::dev': }

  class { 'git': }

  mysql::db {
    $gitlab_dbname:
      ensure   => 'present',
      charset  => 'utf8',
      user     => $gitlab_dbuser,
      password => $gitlab_dbpwd,
      host     => 'localhost',
      grant    => ['all'],
      # See http://projects.puppetlabs.com/issues/17802 (thanks Elliot)
  }

  anchor { 'depends::begin': }
  anchor { 'depends::end': }

  Anchor['depends::begin'] ->
  Class['redis'] -> Class['nginx'] -> Class['ruby'] -> Class['ruby::dev'] ->
  Class['git'] -> Class['mysql::server'] -> Mysql::Db[$gitlab_dbname] ->
  Anchor['depends::end']
}
