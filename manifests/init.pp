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

  case $::operatingsystem {
    ubuntu: {
      class { 'ruby':
        ruby_package     => 'ruby1.9.3',
        rubygems_package => 'rubygems1.9.1',
        rubygems_update  => false,
      }
      exec { 'ruby-version':
        command => '/usr/bin/update-alternatives --set ruby /usr/bin/ruby1.9.1',
        user    => root,
        require => Package['ruby1.9.3'],
        before  => Class['Ruby::Dev'],
      }
      exec { 'gem-version':
        command => '/usr/bin/update-alternatives --set gem /usr/bin/gem1.9.1',
        user    => root,
        require => Package['ruby1.9.3'],
        before  => Class['Ruby::Dev'],
      }
    }
    default: {
      class { 'ruby':
        version         => '1:1.9.3',
        rubygems_update => false;
      }
    }
  }

  class { 'ruby::dev': }

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

  anchor { 'gitlab_requirements::begin': }
  anchor { 'gitlab_requirements::end': }

  Anchor['gitlab_requirements::begin'] ->
  Class['redis'] ->
  Class['nginx'] ->
  Class['ruby'] ->
  Class['ruby::dev'] ->
  Class['git'] ->
  Class['logrotate'] ->
  Class['mysql::server'] ->
  Mysql::Db[$gitlab_dbname] ->
  Anchor['gitlab_requirements::end']

}
