require 'mysql_helper'

module Zimbra
  
  def get_zimbra_volumes( db )
    rows= nicefy_resultset( db.query( "SELECT id, name, path FROM zimbra.volume" ) ) 
  end
  
  def get_users( db )
    exclude_clause = ""
    unless OPTIONS[:exclude].to_s.empty?
      list = OPTIONS[:exclude].to_s.split(",").map{ |m| "'#{m.gsub(/\\/, '\&\&').gsub(/'/, "''")}'" }.join(',')
      exclude_clause = " AND comment NOT IN ( #{list} ) " 
    end
    
    include_clause = ""
    unless OPTIONS[:include].to_s.empty?
      list = OPTIONS[:include].to_s.split(",").map{ |m| "'#{m.gsub(/\\/, '\&\&').gsub(/'/, "''")}'" }.join(',')
      include_clause = " AND comment IN ( #{list} ) " 
    end
    
    all_accounts = db.query( "SELECT id, group_id, comment FROM zimbra.mailbox WHERE id > 0 #{include_clause} #{exclude_clause} ORDER BY comment" )
    log "got #{all_accounts.num_rows} accounts"
    nicefy_resultset(all_accounts )
  end

end
