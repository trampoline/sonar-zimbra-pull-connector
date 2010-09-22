require File.join(File.dirname(__FILE__), 'mysql_helper' ) 

module Zimbra
  module ZDB
    def execute( db, sql )
       ::Zimbra::MySqlHelper.nicefy_resultset( db.query( sql ) )    
     end
     
    def get_mails_from_folders( db, user, folder_ids, volumes, min_date = nil )
      sql = <<-SQL
        SELECT id, size, volume_id, mailbox_id, mod_content, date, '' AS relative_path , '' AS absolute_path
        FROM #{Zimbra::Users.mailbox_group(user)}.mail_item 
        WHERE mailbox_id=#{::Zimbra::Users.mailbox_id(user)} 
          AND type = #{::Zimbra::Folders::TYPES[:MAIL]} 
          AND folder_id IN (#{folder_ids.join(', ')} )
      SQL
      unless min_date.nil?
        sql += " AND date > #{min_date.tv_sec}"
      end
      
      rows = execute(db, sql)
    end
    
    def get_folder_ids( db, user, folder_names )
      sql = "SELECT id FROM #{Zimbra::Users.mailbox_group(user)}.mail_item WHERE mailbox_id=#{::Zimbra::Users.mailbox_id(user)} AND type = #{::Zimbra::Folders::TYPES[:FOLDER]} AND name IN ( #{::Zimbra::MySqlHelper.array_to_in_clause(folder_names, true)} )"
      rows = execute( db, sql ) 
      rows.map{ |r| r['id'] }
    end
    
    def get_folders_under( db, user, folder_ids )
      sql = "SELECT id FROM #{Zimbra::Users.mailbox_group(user)}.mail_item WHERE mailbox_id=#{::Zimbra::Users.mailbox_id(user)} AND type = #{::Zimbra::Folders::TYPES[:FOLDER]} AND parent_id IN (#{::Zimbra::MySqlHelper.array_to_in_clause( folder_ids, false )} )"
      rows = execute( db, sql ) 
    end
    
    def get_volumes( db )
      rows= execute( db, "SELECT id, name, path FROM zimbra.volume" ) 
    end
    
    def get_user_accounts( db, include_clause, exclude_clause )
      where = ['id > 0', include_clause, exclude_clause].compact.join(" AND ")
      
      accounts = execute( db, "SELECT id, group_id, comment FROM zimbra.mailbox WHERE #{where} ORDER BY comment" )
    end
    
    module_function :execute
    module_function :get_mails_from_folders, :get_folder_ids, :get_folders_under, :get_volumes, :get_user_accounts
  end
end
