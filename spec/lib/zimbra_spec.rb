require File.join(File.dirname(__FILE__), '..', 'spec_helper' )


describe Zimbra do
  before(:each) do    
    @mock_dbc = mock("db connection")
    @mock_results = mock("results")
    @mock_results.stub!(:each_hash).and_yield({})
  end
    
  describe "get_volumes" do
    before(:each) do
      @mock_dbc.stub!(:query).and_return(@mock_results)
    end
    
    it "should query the given db connection for volumes" do
      @mock_recordset = mock("recordset")
      @mock_recordset.stub!(:each_hash).and_yield( [] )
      @mock_dbc.should_receive(:query).with( "SELECT id, name, path FROM zimbra.volume" ).and_return(@mock_recordset)
      Zimbra.get_volumes(@mock_dbc)
    end
    
    it "should nicefy the results" do      
      Zimbra::MySqlHelper.should_receive(:nicefy_resultset).with(@mock_results)
      Zimbra.get_volumes(@mock_dbc)
    end
    
    it "should return the nicefied results" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return("foo")
      Zimbra.get_volumes(@mock_dbc).should == "foo"
    end
    
  end
  
  describe "get_users" do
    describe "when include is empty" do
      it "should pass nil to get_user_accounts" do
        Zimbra.should_receive(:get_user_accounts).with( @mock_dbc, nil, nil ).and_return(@mock_results)
        Zimbra.get_users( @mock_dbc, [] )
      end
    end
    describe "when include is not empty" do
      it "should pass an exclude clause to get_user_accounts" do
        Zimbra.should_receive(:get_user_accounts).with( @mock_dbc, "comment IN ( 'test@domain.com' )", nil ).and_return(@mock_results)
        Zimbra.get_users( @mock_dbc, ['test@domain.com'] )
      end
    end
    
    
    describe "when exclude is empty" do
      it "should pass nil to get_user_accounts" do
        Zimbra.should_receive(:get_user_accounts).with( @mock_dbc, nil, nil ).and_return(@mock_results)
        Zimbra.get_users( @mock_dbc, [], [] )        
      end
    end
    describe "when exclude is not empty" do
      it "should pass an exclude clause to get_user_accounts" do
        Zimbra.should_receive(:get_user_accounts).with( @mock_dbc, nil, "comment NOT IN ( 'test@domain.com' )").and_return(@mock_results)
        Zimbra.get_users( @mock_dbc, [], ['test@domain.com'] )
      end
    end
    
    it "should return nicefied results" do
      @mock_results = mock("results")
      Zimbra.stub!(:get_user_accounts).and_return( @mock_results )
      Zimbra::MySqlHelper.should_receive(:nicefy_resultset).with(@mock_results).and_return "foo"
      Zimbra.get_users( @mock_dbc, [], [] ).should == "foo"
    end
      
  end
  
  
  describe "get_user_accounts" do
  end
  
  
end
