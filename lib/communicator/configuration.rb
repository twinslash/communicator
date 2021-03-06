require 'yaml'

module Communicator
  class Configuration
    attr_accessor :server, :role, :secret_key, :project, :events, :listeners, :redis, :logger

    def initialize(options = {})
      set_options(options)
    end

    def configure_with= (yaml_file_path)
      set_options(configure_with_yaml(yaml_file_path))
    end

    private

    def set_options(options = {})
      options.each {|k,v| self.public_send("#{k}=", v) if self.respond_to?("#{k}=") }
    end

    def configure_with_yaml(yaml_file_path)
      begin
        config = YAML.load_file(yaml_file_path)
      rescue Errno::ENOENT
        logger && logger.error("YAML configuration file couldn't be found. Using defaults."); return
      rescue Psych::SyntaxError
        logger && logger.error("YAML configuration file contains invalid syntax. Using defaults."); return
      end
      config || {}
    end
  end
end
