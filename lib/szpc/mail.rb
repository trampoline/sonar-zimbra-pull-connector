module Zimbra
  module Mail
  
    def headers( content )
      content.split(/\r\n\r\n|\n\n/).first + "\r\n\r\n"
    end
    
    def strip_subject(content)
      # "Subject:" followed by anything NON-GREEDY
      # with a positive look-ahead assertion (== non-capturing match) that it is followed by
      # EITHER
      #   newline then anything except end-of-string, another newline, or whitespace, then a colon (i.e. another header)
      # OR
      #   two newlines (i.e. start of body)
      # OR
      #   end of string
      # /im = case insensitive and multiline (ie '.' will match newline)
      # NOTE - rfc822 is very explicit about line endings being CRLF ( == \r\n)!
      re = /(^subject:).*?(?=\n[^:\z\n\s]+:|\n\n|\r\n\r\n|\z)/im
      content.gsub(re, '\1')
    end
    
    
    module_function :headers, :strip_subject
  end
end
