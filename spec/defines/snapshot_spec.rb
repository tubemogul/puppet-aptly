require 'spec_helper'

describe 'aptly::snapshot' do
  context 'basic snapshot' do
    let(:title) { '2016-07-30-daily' }
    let(:params) do
      {
        source_type: 'repository',
        source_name: 'debian-main'
      }
    end

    it 'should call the aptly_snapshot provider' do
      should contain_aptly_snapshot('2016-07-30-daily')\
        .with_ensure('present')\
        .with_source_type('repository')\
        .with_source_name('debian-main')
    end
  end
end
