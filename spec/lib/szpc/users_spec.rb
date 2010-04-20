require File.join( File.dirname(__FILE__), '..', '..', 'spec_helper' )

describe Zimbra::Users do
  before(:each) do    
    @mock_dbc = mock("db connection")
    @mock_results = mock("results")
    @mock_results.stub!(:each_hash).and_yield({})
  end
    
  
  describe "get_users" do
    describe "when include is empty" do
      it "should pass nil to get_user_accounts" do
        Zimbra::ZDB.should_receive(:get_user_accounts).with( @mock_dbc, nil, nil ).and_return(@mock_results)
        Zimbra::Users.get_users( @mock_dbc, [] )
      end
    end
    describe "when include is not empty" do
      it "should pass an exclude clause to get_user_accounts" do
        Zimbra::ZDB.should_receive(:get_user_accounts).with( @mock_dbc, "comment IN ( 'test@domain.com' )", nil ).and_return(@mock_results)
        Zimbra::Users.get_users( @mock_dbc, ['test@domain.com'] )
      end
    end
    
    
    describe "when exclude is empty" do
      it "should pass nil to get_user_accounts" do
        Zimbra::ZDB.should_receive(:get_user_accounts).with( @mock_dbc, nil, nil ).and_return(@mock_results)
        Zimbra::Users.get_users( @mock_dbc, [], [] )        
      end
    end
    
    describe "when exclude is not empty" do
      it "should pass an exclude clause to get_user_accounts" do
        Zimbra::ZDB.should_receive(:get_user_accounts).with( @mock_dbc, nil, "comment NOT IN ( 'test@domain.com' )").and_return(@mock_results)
        Zimbra::Users.get_users( @mock_dbc, [], ['test@domain.com'] )
      end
    end
      
  end
  
  
  describe "mailbox_name" do
    it "should return a string" do
      Zimbra::Users.mailbox_name( "test" ).should be_a_kind_of(String)
    end
    
    describe "returned string" do
      it "should be 'mboxgroup' followed by the user id" do
        Zimbra::Users.mailbox_name( "test" ).should == 'mboxgrouptest'
      end
    end
  end
end
