require 'mysql_helper'
require 'folders'
require 'zdb'

module Zimbra

  def get_users( db, include=[], exclude=[] )
    exclude_clause = (exclude.empty?) ? nil : "comment NOT IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( exclude )} )"     
    include_clause = (include.empty?) ? nil : "comment IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( include )} )"
    
    all_accounts = ::Zimbra::ZDB.get_user_accounts( db, include_clause, exclude_clause )
  end
  
  module_function :get_users
end
