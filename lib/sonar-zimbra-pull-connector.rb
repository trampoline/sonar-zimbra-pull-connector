require 'mysql_helper'
require 'folders'

module Zimbra

  FOLDER_NAMES_WE_WANT = [ 
    "Inbox",
    "Sent",
    "Sent Messages"   # for mac clients
  ]
  TYPES = { :FOLDER => 1, :MAIL => 5 }
  
  def get_volumes( db )
    rows= ::Zimbra::MySqlHelper.nicefy_resultset( db.query( "SELECT id, name, path FROM zimbra.volume" ) ) 
  end
  
  
  def get_users( db, include=[], exclude=[] )
    exclude_clause = (exclude.empty?) ? nil : "comment NOT IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( exclude )} )"     
    include_clause = (include.empty?) ? nil : "comment IN ( #{::Zimbra::MySqlHelper.array_to_in_clause( include )} )"
    
    all_accounts = get_user_accounts( db, include_clause, exclude_clause )
  end
  
  

private 

  def get_user_accounts( db, include_clause, exclude_clause )
    where = ['id > 0', include_clause, exclude_clause].compact.join(" AND ")
    
    accounts = db.query( "SELECT id, group_id, comment FROM zimbra.mailbox WHERE #{where} ORDER BY comment" )
    ::Zimbra::MySqlHelper.nicefy_resultset(accounts )
  end
  
  
  module_function :get_volumes, :get_users, :get_user_accounts
end
