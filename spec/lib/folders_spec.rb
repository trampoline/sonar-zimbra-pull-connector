require File.join( File.dirname(__FILE__), '..', 'spec_helper' )

describe Zimbra::Folders do
  describe "get_folders" do
    it "should call get_folder_ids with the db, mailbox name and given folder names" do
      Zimbra::Folders.stub!(:get_folders_under).and_return([])
      Zimbra::Folders.should_receive(:get_folder_ids).with( @mock_dbc, 'mailbox name', ['folder1','folder2'] ).and_return([])
      Zimbra::Folders.get_folders( @mock_dbc, 'mailbox name', ['folder1','folder2'] )
    end
    
    it "should call get_folders_under with db, mailbox_name, folder_ids" do
      Zimbra::Folders.stub!(:get_folder_ids).and_return([1,2,3])
      Zimbra::Folders.should_receive(:get_folders_under).with(@mock_dbc, 'mailbox name', [1,2,3] )
      Zimbra::Folders.get_folders( @mock_dbc, 'mailbox name', ['folder1','folder2'] )
    end
    
  end
  
  describe "get_folder_ids" do
    before(:each) do
      @mock_dbc.stub!(:query)
    end
    
    it "should make an IN clause from the given folder_names" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [] )
      Zimbra::MySqlHelper.should_receive( :array_to_in_clause ).with(['folder1', 'folder2'], true).and_return( "'foo'")
      
      Zimbra::Folders.get_folder_ids( @mock_dbc, 'mailbox', ['folder1', 'folder2'] )
    end
    
    it "should return just the ids of the folders" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [ {'id'=>'row1_id', 'field'=>'value'}, {'id'=>'row2_id', 'field'=>'value2'} ] )
      Zimbra::Folders.get_folder_ids( @mock_dbc, 'mailbox', ['folder1', 'folder2'] ).should == ['row1_id', 'row2_id']
    end
    
  end

  describe "get_folders_under" do
    before(:each) do
      @mock_dbc.stub!(:query)
    end
    
    it "should make an IN clause from the given folder_ids" do
      Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [] )
      Zimbra::MySqlHelper.should_receive( :array_to_in_clause ).with(['id1', 'id2'], false).and_return( "'foo'")
      
      Zimbra::Folders.get_folders_under( @mock_dbc, 'mailbox', ['id1', 'id2'] )
    end
    
    describe "when no sub folders are found" do
      it "should return the given folder_ids" do
        Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [] )
        Zimbra::Folders.get_folders_under( @mock_dbc, 'mailbox', ['id1', 'id2'] ).should == ['id1', 'id2']
      end
    end
    
    describe "when sub folders are found" do
      it "should look for more sub folders passing the ids of the sub folders" do
        Zimbra::MySqlHelper.stub!(:nicefy_resultset).and_return( [ {'id'=>'row1_id', 'field'=>'value'}, {'id'=>'row2_id', 'field'=>'value2'} ], [] )
        
        Zimbra::Folders.get_folders_under( @mock_dbc, 'mailbox', ['folder1', 'folder2'] ).should == ['folder1', 'folder2', 'row1_id', 'row2_id']
      end
    end
    
    
  end
end
