require 'spec_helper'

# Gitlab requirements
describe 'gitlab_requirements' do
  let(:facts) {{
    :osfamily  => 'Debian',
    :fqdn      => 'gitlab.fooboozoo.fr',
    :sshrsakey => 'AAAAB3NzaC1yc2EAAAA'
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

  it { should contain_include('redis')}
  it { should contain_include('nginx')}
  it { should contain_include('mysql::server')}

  describe 'ruby class' do
    it { should contain_class('ruby').with(
      :version          => '1:1.9.3',
      :rubygems_update  => 'false'
    )}
    it { should contain_class('ruyb::dev')}
  end

  describe 'git class' do
    it { should contain_class('git')}
  end

  descrive 'mysql database' do
    context 'with default params' do
      it { should contain_class('mysql::db').with(
        :name     => 'gitlab_production',
        :user     => 'baltig',
        :password => 'Cie7cheewei<ngi3',
        :ensure   => 'present',
        :charset  => 'utf8',
        :host     => 'localhost',
      )}
    end
    context 'with specifics params' do
      let(:params) { params_set }
      it { should contain_class('mysql::db').with(
        :name     => 'gitlab',
        :user     => 'gitlab',
        :password => 'changeme',
        :ensure   => 'present',
        :charset  => 'utf8',
        :host     => 'localhost',
      )}
    end
  end

  describe 'anchors' do
    it { should contain_anchor('depends::begin')}
    it { should contain_anchor('depends::end')}
  end

end # gitlab::requirements
