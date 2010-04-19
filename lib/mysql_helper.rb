require 'mysql'

module Zimbra

  module MySqlHelper
    
    def db_connection( options )
      Mysql.real_connect(options[:host], options[:username], options[:password], nil, options[:port].to_i, options[:socket])
    end
    
    # take a raw mysql resultset and make it into an array of hashes so we can do things like
    # results[12]['id']
    def nicefy_resultset( resultset )
      column_names = resultset.fetch_fields.map{ |f| f.name }
      
      array_of_hashes = []
      resultset.each_hash do |row_hash|
        array_of_hashes << row_hash
      end
      array_of_hashes
    end
    
    module_function :db_connection, :nicefy_resultset
    
  end
  
end