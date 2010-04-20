require File.join(File.dirname(__FILE__), 'zdb' ) 

module Zimbra
  module Users
    def get_users( db, include=[], exclude=[] )
      exclude_clause = (exclude.empty?) ? nil : "comment NOT IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( exclude )} )"     
      include_clause = (include.empty?) ? nil : "comment IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( include )} )"
      
      all_accounts = ::Zimbra::ZDB.get_user_accounts( db, include_clause, exclude_clause )
    end

    def mailbox_name( user_id )
      "mboxgroup#{user_id}"
    end
    
    module_function :get_users, :mailbox_name
  end

end