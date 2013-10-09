# Module:: gitlab-requirements
# Manifest:: init.pp
#
# Author:: Sebastien Badia (<seb@sebian.fr>)
# Date:: 2013-06-18 01:48:08 +0200
# Maintainer:: Sebastien Badia (<seb@sebian.fr>)
#

# Class:: gitlab_requirements
#
#
class depends($gitlab_dbname, $gitlab_dbuser, $gitlab_dbpwd) {
  include redis
  include nginx
  include mysql::server

  class { 'ruby':
    version         => '1:1.9.3',
    rubygems_update => false;
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

  anchor { 'depends::begin': }
  anchor { 'depends::end': }

  Anchor['depends::begin'] ->
  Class['redis'] -> Class['nginx'] -> Class['ruby'] -> Class['ruby::dev'] ->
  Class['mysql::server'] -> Mysql::Db[$gitlab_dbname] ->
  Anchor['depends::end']
}
