module ActiveRecord
  class Base
    # Establishes a connection to the database that's used by all Active Record objects.
    def self.mysql2_connection(config)      
      config[:username] = 'root' if config[:username].nil?

      if Mysql2::Client.const_defined? :FOUND_ROWS
        config[:flags] = config[:flags] ? config[:flags] | Mysql2::Client::FOUND_ROWS : Mysql2::Client::FOUND_ROWS
      end

      client = Mysql2::Client.new(config.symbolize_keys)
      options = [config[:host], config[:username], config[:password], config[:database], config[:port], config[:socket], 0]
      ConnectionAdapters::Mysql2Adapter.new(client, logger, options, config)
    end
  

    # This method is for running stored procedures.
    #
    # @return [Hash]
    #
    def self.select_sp(sql, name = nil)
      connection = ActiveRecord::Base.connection
      begin
        connection.select_all(sql, name)
      rescue NoMethodError
      ensure
        connection.reconnect! unless connection.active?
      end
    end

  end
end