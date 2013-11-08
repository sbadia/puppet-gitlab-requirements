require 'spec_helper'

# Gitlab requirements
describe 'gitlab_requirements' do
  let(:facts) {{
    :osfamily         => 'Debian',
    :operatingsystem  => 'Debian',
    :kernel           => 'Linux',
    :lsbdistcodename  => 'wheezy',
    :fqdn             => 'gitlab.fooboozoo.fr',
    :sshrsakey        => 'AAAAB3NzaC1yc2EAAAA'
  }}

  ## Parameter set
  # a non-default common parameter set
  let :params_set do
    {
      :gitlab_dbname          => 'gitlab_production',
      :gitlab_dbuser          => 'baltig',
      :gitlab_dbpwd           => 'Cie7cheewei<ngi3',
    }
  end

  it { should include_class('redis')}
  it { should include_class('nginx')}
  it { should include_class('mysql::server')}

  describe 'ruby class' do
    it { should contain_class('ruby').with(
      :version          => '1:1.9.3',
      :rubygems_update  => 'false'
    )}
    it { should contain_class('ruby::dev')}
  end

  describe 'git class' do
    it { should contain_class('git')}
  end

  describe 'anchors' do
    it { should contain_anchor('depends::begin')}
    it { should contain_anchor('depends::end')}
  end

end # gitlab::requirements
