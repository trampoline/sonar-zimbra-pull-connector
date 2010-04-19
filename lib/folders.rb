
module Zimbra
  module Folders
    FOLDER_NAMES_WE_WANT = [ 
      "Inbox",
      "Sent",
      "Sent Messages"   # for mac clients
    ]
    TYPES = { :FOLDER => 1, :MAIL => 5 }
    
    def get_folders( db, mailbox_name, folder_names=FOLDER_NAMES_WE_WANT )
      folder_ids = get_folder_ids( db, mailbox_name, folder_names )
      
      get_folders_under( db, mailbox_name, folder_ids )
    end

  private 
    def get_folder_ids( db, mailbox_name, folder_names )
      sql = "SELECT id FROM #{mailbox_name}.mail_item WHERE type = #{::Zimbra::TYPES[:FOLDER]} AND name IN ( #{::Zimbra::MySqlHelper.array_to_in_clause(folder_names, true)} )"
      rows = ::Zimbra::MySqlHelper.nicefy_resultset( db.query( sql ) )
      rows.map{ |r| r['id'] }
    end
    
    def get_folders_under( db, mailbox_name, folder_ids )
      sql = "SELECT id FROM #{mailbox_name}.mail_item WHERE type = #{::Zimbra::TYPES[:FOLDER]} AND parent_id IN (#{::Zimbra::MySqlHelper.array_to_in_clause( folder_ids, false )} )"
      rows = ::Zimbra::MySqlHelper.nicefy_resultset( db.query( sql ) )
      return folder_ids if rows.length == 0
      
      new_ids = rows.map{ |r| r['id'] }
      
      folder_ids += get_folders_under( db, mailbox_name, new_ids )
      folder_ids
    end
    
    
    module_function :get_folders, :get_folder_ids, :get_folders_under
  end
end