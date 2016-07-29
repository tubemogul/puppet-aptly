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
      #   execution of the command fails.
      #
      # @return [String] or an exception in case of error 
      def execute(object = :mirror, action = '', arguments = [], flags = {}, exceptions = :true)

        cmd = 'aptly '
        cmd << flags.map{|k,v| "-#{k} #{v}"}.join(' ')

        raise Puppet::Error, "Unknown aptly object: #{object}" unless [:mirror, :repo, :snapshot, :publish, :package, :db].include object
        cmd << "#{object} #{action} "
        cmd << arguments.join(' ')

        begin
          result = Puppet::Util::Execution.execute(cmd)
        rescue
          raise Puppet::Error, e.message if exceptions
        end
        result
      end

    end
  end
end
