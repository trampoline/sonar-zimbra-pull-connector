require File.join( File.dirname(__FILE__), '..', '..', 'spec_helper' )

describe Zimbra::Mail do

  before(:each) do
    
  end
  
  describe "headers" do
    
    it "should return a string" do
      content = sample_mail( 'email_1.in' )
      Zimbra::Mail.headers(content).should be_a_kind_of(String)
    end
    
    describe "returned content" do
      it "should be truncated at the first double newline" do
        content = sample_mail( 'email_1.in' )
        Zimbra::Mail.headers(content).should_not match( /\n\n.*/ )
      end
    end
  end
  
  describe "strip_subject" do
    it "should return a string" do
      content = sample_mail( 'email_1.in' )
      Zimbra::Mail.strip_subject(content).should be_a_kind_of(String)
    end
    
    it "should remove any subject line" do
      content = sample_mail( 'email_1.in' )
      Zimbra::Mail.strip_subject(content).should_not match( /\nsubject:[^\n]+/i )
    end
    
    describe "when subject wraps onto multiple lines" do
      it "should remove any following continuation lines" do
        content = sample_mail( 'email_with_multiple_line_subject.in' )
        Zimbra::Mail.strip_subject(content).should_not match( /\nsubject:[^\n]+/i )
        
        Zimbra::Mail.strip_subject(content).should_not include( "subject line 2" )
        Zimbra::Mail.strip_subject(content).should_not include( "subject line 3" )
        Zimbra::Mail.strip_subject(content).should_not include( "subject line 4" )
      end
    end
  end
  
  describe "various edge cases" do
    before(:each) do
      @files = ["calendar_invitation.rfc822", "email_3.in", "email_4.in", "email_5.in",
        "email_with_base64_encoded_header_fields.in",
        "email_with_more_than_1000_lines.in",
        "email_with_multiple_line_subject.in",
        "email_with_no_body.in",
        "email_with_subject_error.rfc822",
        "huge_mail_1.in",
        "nonsense_email.in",
        "text_html_mime_message.in"
      ]
    end
    
    it "should work with each edge case" do
      @files.each do |file|
        content = sample_mail(file)
        Zimbra::Mail.headers( content ).should_not match( /\n\n.*/ )
        Zimbra::Mail.strip_subject(content).should_not match( /\nsubject:[^\n]+/i )
      end
    end
    
  end
  
end
