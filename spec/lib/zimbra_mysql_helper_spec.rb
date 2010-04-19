require File.join(File.dirname(__FILE__), '..', 'spec_helper' )


describe Zimbra::MySqlHelper do

  describe "db_connection" do
    it "should call Mysql.real_connect" do
      Mysql.should_receive( :real_connect )
      Zimbra::MySqlHelper.db_connection( :foo=>'bar' )
    end
    
    describe "arguments" do
      it "should pass :host from options as first arg" do
        Mysql.should_receive( :real_connect ).with('my host', anything, anything, anything, anything, anything)
        Zimbra::MySqlHelper.db_connection( :host=>'my host' )
      end
      
      it "should pass :username from options as second arg" do
        Mysql.should_receive( :real_connect ).with(anything, 'my username', anything, anything, anything, anything)
        Zimbra::MySqlHelper.db_connection( :username=>'my username' )
      end
      
      it "should pass :password from options as third arg" do
        Mysql.should_receive( :real_connect ).with(anything, anything, 'my password', anything, anything, anything)
        Zimbra::MySqlHelper.db_connection( :password=>'my password' )
      end
      
      it "should pass nil as fourth arg" do
        Mysql.should_receive( :real_connect ).with(anything, anything, anything, nil, anything, anything )
        Zimbra::MySqlHelper.db_connection( :password=>'my password' )
      end
      
      it "should pass an integer from options[:port] as fifth arg" do
        Mysql.should_receive( :real_connect ).with(anything, anything, anything, nil, 1234, anything )
        Zimbra::MySqlHelper.db_connection( :port=>'1234' )
      end
      
      it "should pass :socket from options as sixth arg" do
        Mysql.should_receive( :real_connect ).with(anything, anything, anything, nil, anything, '/my/socket/' )
        Zimbra::MySqlHelper.db_connection( :socket=>'/my/socket/' )
      end
      
    end
    
  end
  
end
