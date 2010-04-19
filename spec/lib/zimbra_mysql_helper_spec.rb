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
    
    it "should return the result of Mysql.real_connect" do
      Mysql.stub!(:real_connect).and_return( :foo=>'bar' )
      Zimbra::MySqlHelper.db_connection( {} ).should == {:foo=>'bar'}
    end
    
      
  end
  
  describe "column_names" do
    before(:each) do
      @mock_field_1 = mock('field_1')
      @mock_field_2 = mock('field_2')
      @mock_field_1.stub!(:name).and_return("field 1")
      @mock_field_2.stub!(:name).and_return("field 2")
      @mock_fields = [@mock_field_1, @mock_field_2]
      
      @resultset = mock("resultset")
      @resultset.stub!(:fetch_fields).and_return( @mock_fields )
    end
    
    it "should return an array of field names as strings" do
      columns = Zimbra::MySqlHelper.column_names(@resultset)
      columns.should respond_to(:[])
      columns.each do |s|
        s.should be_a_kind_of(String)
      end
    end
    
    describe "returned array" do
      it "should be in the same order as the given resultset" do
        columns = Zimbra::MySqlHelper.column_names(@resultset)
        columns.should == [ 'field 1', 'field 2' ]
      end
    end
    
  end
  
  describe "nicefy_resultset" do
    before(:each) do
      @mock_resultset = mock("resultset")
      @row1 = {'field1'=>'r1_value1', 'field2'=>'r1_value2'}
      @row2 = {'field1'=>'r2_value1', 'field2'=>'r2_value2'}
      
      @mock_resultset.stub!(:each_hash).and_yield( @row2 )
    end
        
    it "should return one element for each row" do
      Zimbra::MySqlHelper.nicefy_resultset(@mock_resultset).should == [@row2]
    end
    
    describe "each element" do
      it "should have a key for each field name" do
        Zimbra::MySqlHelper.nicefy_resultset(@mock_resultset)[0].keys.should==["field1","field2"]
      end
      
      it "should have the correct value for each field" do
        rows = Zimbra::MySqlHelper.nicefy_resultset(@mock_resultset)
        rows[0]["field1"].should == "r2_value1"
        rows[0]["field2"].should == "r2_value2"
      end
    end
    
  end

  describe "array_to_in_clause" do
    before(:each) do
      @array = ['cheese', 'fish', 'donkeys']
    end
    
    it "should return a string" do
      Zimbra::MySqlHelper.array_to_in_clause( @array ).should be_a_kind_of(String)
    end
    
    describe "returned string" do  
      before(:each) do  
        @r = Zimbra::MySqlHelper.array_to_in_clause( @array )
      end
      
      it "should be a comma-separated list" do
        @r.scan(',').size.should == 2
      end
      
      it "should have one element for each array element" do
        @r.split(',').size.should == @array.size
      end
      
      it "should encase each element in single quotes" do
        @r.split(',').each do |element|
          element[0].should == 39
          element[element.size - 1].should == 39
        end
      end
      
    end
    
  end
  
end
