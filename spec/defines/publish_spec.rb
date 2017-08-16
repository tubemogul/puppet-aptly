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
        name: '2016-07-30-daily-snapshot',
        prefix: 'test-prefix',
        architectures: ['amd64'],
        label: 'Debian-Security'
      }
    end

    it 'call the aptly_publish provider' do
      is_expected.to contain_aptly_publish('2016-07-30-daily-snapshot').\
        with_ensure('present').\
        with_uid('450').\
        with_gid('450').\
        with_source_type('snapshot').\
        with_prefix('test-prefix').\
        with_architectures(['amd64']).\
        with_label('Debian-Security')
    end
  end
end
