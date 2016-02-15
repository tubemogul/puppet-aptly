# == Class aptly::service
#
# This class is meant to be called from aptly.
# It ensure the service is running.
#
class aptly::service {

  $svc_ensure = $aptly::enable_service ? {
    true  => 'running',
    false => 'stopped',
  }

  $api_ensure = $aptly::enable_api ? {
    true  => 'running',
    false => 'stopped',
  }

  service { 'aptly':
    ensure     => $svc_ensure,
    enable     => $aptly::enable_service,
    hasstatus  => true,
    hasrestart => true,
  }

  service { 'aptly-api':
    ensure     => $api_ensure,
    enable     => $aptly::enable_api,
    hasstatus  => true,
    hasrestart => true,
  }
}
