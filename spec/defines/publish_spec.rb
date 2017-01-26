require 'spec_helper'

describe 'aptly::publish' do
  context 'basic publish' do
    let(:title) { '2016-07-30-daily' }
    let(:params) do
      {
        uid: '450',
        gid: '450',
        source_type: 'snapshot',
        distribution: 'jessie-2016-07-30-daily-snapshot',
        name: '2016-07-30-daily-snapshot'
      }
    end

    it 'call the aptly_publish provider' do
      is_expected.to contain_aptly_publish('2016-07-30-daily-snapshot').\
        with_ensure('present').\
        with_uid('450').\
        with_gid('450').\
        with_source_type('snapshot')
    end
  end
end
