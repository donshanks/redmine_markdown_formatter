require 'rdiscount'
require 'coderay'

module RedmineMarkdownFormatter
  class WikiFormatter
    def initialize(text)
      @text = text
    end

    def to_html(&block)
      html = markdown( coderay(@text) )
      html.gsub(/<a\s/, "<a class='external'") # Add the `external` class to every link
    rescue => e
      return("<pre>problem parsing wiki text: #{e.message}\n"+
             "original text: \n"+
             @text+
             "</pre>")
    end

    def markdown( text )
      RDiscount.new(text, :smart).to_html
    end

    def coderay( text )
      text.gsub(/\<code( lang="(.+?)")?\>(.+?)\<\/code\>/m) do
        CodeRay.scan($3.strip, $2).div(:line_numbers => :inline, :line_number_anchors => false, :wrap => :span)
      end
    end
  end
end
