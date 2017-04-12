require 'puppet/util/execution'

module Puppet_X
  module Aptly
    module Cli
      # Executes an aptly command via the command-line
      #
      # @param object [Symbol] the type of aptly object to work on, aka:
      #   :mirror, :repo, :snapshot, :publish, :package, :db
      #   Defaults to :mirror
      #
      # @param action [String] action to execute on the object example, if you
      #   want to execute an `aptly mirror create`, the action param will be
      #   `create`
      #
      # @param arguments [Array] Array containing the command arguments. The
      #   elements are concatenated in the end to form the command.
      #   Example, in `aptly mirror create debian-main http://ftp.ru.debian -with-udebs=false`
      #   the arguments will be: [ 'debian-main', 'http://ftp.ru.debian']
      #
      # @param flags [Hash] hash containing the flags (global or not) to pass to the
      #   aptly command. The key is the flag name (without the "-"). The value is the flag value.
      #   For more informations about global flags, see: https://www.aptly.info/doc/aptly/flags/
      #
      # @param exceptions [bool] whether or not to raise an exception when the
      #   execution of the command fails. Returns the error message without
      #   raising an exception if false and an exception occurs.
      #
      # @return [String] or an exception in case of error
      def self.execute(options = {})
        uid = options.fetch(:uid)
        gid = options.fetch(:gid)
        object = options.fetch(:object, :mirror)
        action = options.fetch(:action, '')
        exceptions = options.fetch(:exceptions, :true)
        arguments = options.fetch(:arguments, [])
        flags = options.fetch(:flags, {})

        cmd = 'aptly '
        cmd << flags.map do |k, v|
          unless v == 'undef'
            v.to_s == '' ? "-#{k}" : "-#{k}=#{v}".strip
          end
        end.join(' ')

        raise Puppet::Error, "Unknown aptly object: #{object}" unless [:mirror, :repo, :snapshot, :publish, :package, :db].include? object
        cmd << " #{object} #{action} "
        cmd << arguments.delete_if { |val| val == 'undef' }.join(' ')

        begin
          Puppet.debug("Executing: #{cmd}")
          result = Puppet::Util::Execution.execute(cmd, uid: uid, gid: gid, failonfail: true)
        rescue => e
          raise Puppet::Error, e.message if exceptions
          e.message
        end
        result
      end
    end
  end
end
