require 'spec_helper'

describe 'aptly::repo' do
  context 'basic repo' do
    let(:title) { 'my_custom_repo' }
    let(:params) do
      {
        uid: '450',
        gid: '450',
        default_component: 'stable',
        default_distribution: 'xenial'
      }
    end

    it 'should call the aptly_repo provider' do
      is_expected.to contain_aptly_repo('my_custom_repo')\
        .with_ensure('present')\
        .with_uid('450')\
        .with_gid('450')\
        .with_default_component('stable')\
        .with_default_distribution('xenial')
    end
  end
end
