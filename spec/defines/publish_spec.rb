require 'spec_helper'

describe 'aptly::publish' do
  context 'basic publish' do
    let(:title) { '2016-07-30-daily' }
    let(:params) do
      {
        source_type: 'snapshot',
        source_name: '2016-07-30-daily-snapshot'
      }
    end

    it 'should call the aptly_publish provider' do
      is_expected.to contain_aptly_publish('2016-07-30-daily-snapshot')\
        .with_ensure('present')\
        .with_source_type('snapshot')
    end
  end
end
