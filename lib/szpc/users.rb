require File.join(File.dirname(__FILE__), 'zdb' ) 

module Zimbra
  module Users
    def get_users( db, include=[], exclude=[] )
      exclude_clause = (exclude.empty?) ? nil : "comment NOT IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( exclude )} )"     
      include_clause = (include.empty?) ? nil : "comment IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( include )} )"
      
      all_accounts = ::Zimbra::ZDB.get_user_accounts( db, include_clause, exclude_clause )
    end

    def mailbox_group( user )
      "mboxgroup#{user['group_id']}"
    end

    def mailbox_id( user)
      "#{user['id']}"
    end
    
    module_function :get_users, :mailbox_group, :mailbox_id
  end

end
