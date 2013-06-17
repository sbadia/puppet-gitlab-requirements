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
class gitlab_requirements {
  include 'ssh'
  include 'redis'
  include 'git'


} # Class:: gitlab_requirements
