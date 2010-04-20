require File.join(File.dirname(__FILE__), 'zdb' ) 

module Zimbra
  module Folders
    FOLDER_NAMES_WE_WANT = [ 
      "Inbox",
      "Sent",
      "Sent Messages"   # for mac clients
    ]
    TYPES = { :FOLDER => 1, :MAIL => 5 }
    
    def get_folders( db, mailbox_name, folder_names=FOLDER_NAMES_WE_WANT )
      folder_ids = ::Zimbra::ZDB.get_folder_ids( db, mailbox_name, folder_names )
      
      get_folders_under( db, mailbox_name, folder_ids )
    end
    
    def get_mails_from_folders( db, mailbox_name, folder_ids, volumes, min_date = nil )
      rows = ::Zimbra::ZDB.get_mails_from_folders( db, mailbox_name, folder_ids, volumes, min_date = nil )
      rows.each{ |r| r['relative_path'] = get_relative_path( r['mailbox_id'], r['id'], r['mod_content'] ) }
      rows.each{ |r| r['absolute_path'] = File.join( volumes.select{ |v| v['id'] == r['volume_id'] }[0]['path'], r['relative_path'] )  }
    end

    def get_relative_path( mailbox_id, mail_id, mod_content )
      # Zimbra balances directories for mailboxes, and for files within each mailbox,
      # by bitshifting the id to the right by 12 bits
      # see http://wiki.zimbra.com/index.php?title=Account_mailbox_database_structure
      mailbox_dir = File.join(  (mailbox_id.to_i >> 12).to_s, mailbox_id.to_s, "msg")
      mail_dir = (mail_id.to_i >> 12).to_s
      mail_path = File.join( mailbox_dir, mail_dir )
      
      mail_filename = mail_id.to_s + "-" + mod_content.to_s + ".msg"
      File.join( mail_path, mail_filename )
    end

  private 
    
    def get_folders_under( db, mailbox_name, folder_ids )
      rows = ::Zimbra::ZDB.get_folders_under( db, mailbox_name, folder_ids )
      return folder_ids if rows.length == 0
      
      new_ids = rows.map{ |r| r['id'] }
      
      folder_ids += get_folders_under( db, mailbox_name, new_ids )
      folder_ids
    end
    
    
    module_function :get_folders, :get_folders_under
    module_function :get_mails_from_folders, :get_relative_path
  end
end