require File.join( File.dirname(__FILE__), '..', '..', 'spec_helper' )

describe Zimbra::ZDB do
    before(:each) do
      @mock_dbc = mock("db connection")
      @mock_dbc.stub!(:query)
    end
    
  describe "get_folder_ids" do
    it "should make an IN clause from the given folder_names" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [] )
      Zimbra::MySqlHelper.should_receive( :array_to_in_clause ).with(['folder1', 'folder2'], true).and_return( "'foo'")
      
      Zimbra::ZDB.get_folder_ids( @mock_dbc, {}, ['folder1', 'folder2'] )
    end
    
    it "should return just the ids of the folders" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [ {'id'=>'row1_id', 'field'=>'value'}, {'id'=>'row2_id', 'field'=>'value2'} ] )
      Zimbra::ZDB.get_folder_ids( @mock_dbc, {}, ['folder1', 'folder2'] ).should == ['row1_id', 'row2_id']
    end
    
  end

  
  describe "get_user_accounts" do
    before(:each) do      
      Zimbra::MySqlHelper.stub!(:nicefy_resultset)
    end
    
    describe "when include_clause and exclude_clause are nil" do
      it "should make a where clause of 'id > 0' " do
        @mock_dbc.should_receive(:query).with( "SELECT id, group_id, comment FROM zimbra.mailbox WHERE id > 0 ORDER BY comment" )
        Zimbra::ZDB.send(:get_user_accounts, @mock_dbc, nil, nil)
      end
    end
    
    describe "when include_clause is not nil" do
      it "should make a where clause of 'id > 0 AND include_clause" do
        @mock_dbc.should_receive(:query).with( "SELECT id, group_id, comment FROM zimbra.mailbox WHERE id > 0 AND foo = bar ORDER BY comment" )
        Zimbra::ZDB.send(:get_user_accounts, @mock_dbc, 'foo = bar', nil)
      end
    end
    
    describe "when exclude_clause is not nil" do
      it "should make a where clause of 'id > 0 AND exclude_clause" do
        @mock_dbc.should_receive(:query).with( "SELECT id, group_id, comment FROM zimbra.mailbox WHERE id > 0 AND foo = bar ORDER BY comment" )
        Zimbra::ZDB.send(:get_user_accounts, @mock_dbc, nil, 'foo = bar')
      end
    end
    
    describe "when include_clause and exclude_clause are both not nil" do
      it "should make a where clause of 'id > 0 AND include_clause AND exclude_clause" do
        @mock_dbc.should_receive(:query).with( "SELECT id, group_id, comment FROM zimbra.mailbox WHERE id > 0 AND foo = bar AND foo2 = bar2 ORDER BY comment" )
        Zimbra::ZDB.send(:get_user_accounts, @mock_dbc, 'foo = bar', 'foo2 = bar2')
      end
    end
    
    it "should return nicefied results" do
      @mock_results = mock("results")
      @mock_dbc.stub!(:query).and_return( @mock_results )
      Zimbra::MySqlHelper.should_receive(:nicefy_resultset).with(@mock_results).and_return "foo"
      Zimbra::ZDB.get_user_accounts( @mock_dbc, nil, nil ).should == "foo"
    end
  end
  
  describe "get_volumes" do
    before(:each) do
      @mock_dbc.stub!(:query).and_return(@mock_results)
    end
    
    it "should query the given db connection for volumes" do
      @mock_recordset = mock("recordset")
      @mock_recordset.stub!(:each_hash).and_yield( [] )
      @mock_dbc.should_receive(:query).with( "SELECT id, name, path FROM zimbra.volume" ).and_return(@mock_recordset)
      Zimbra::ZDB.get_volumes(@mock_dbc)
    end
    
    it "should nicefy the results" do      
      Zimbra::MySqlHelper.should_receive(:nicefy_resultset).with(@mock_results)
      Zimbra::ZDB.get_volumes(@mock_dbc)
    end
    
    it "should return the nicefied results" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return("foo")
      Zimbra::ZDB.get_volumes(@mock_dbc).should == "foo"
    end
    
  end
  
end
