module Zimbra
  module Mail
  
    def headers( content )
      content.split("\n\n").first
    end
    
    def strip_subject(content)
      # "Subject:" followed by anything NON-GREEDY
      # with a positive look-ahead assertion that it is followed by
      # EITHER
      #   newline then anything except end-of-string, another newline, or whitespace, then a colon (i.e. another header)
      # OR
      #   two newlines (i.e. start of body)
      # OR
      #   end of string
      # /im = case insensitive and multiline (ie '.' will match newline)
      re = /(^subject:).*?(?=\n[^:\z\n\s]+:|\n\n|\z)/im
      content.gsub(re, '\1')
    end
    
    
    module_function :headers, :strip_subject
  end
end
