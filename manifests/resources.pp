# == Class aptly::resources
#
# This class is called from the aptly main class to setup mirror/repo resources
#
class aptly::resources(
  $repos   = $::aptly::repos,
  $mirrors = $::aptly::mirrors
) {
  unless empty($repos) {
    create_resources('aptly::repo', $repos)
  }

  unless empty($mirrors) {
    create_resources('aptly::mirror', $mirrors)
  }
}
