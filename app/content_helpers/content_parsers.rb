module ContentParsers

  @tag_search_regex = '\(\?(?<tag>[a-z_])+(?<params>.*?)--\)'

  def self.tag_search_regex
    ContentParsers::tag_search_regex
  end

  class TagParser
    @@tag_regex = /((?<attr1>[a-z_]+)="(?<val1>.+?[^\\])")|((?<attr2>[a-z_]+)=(?<val2>[^\s"=]+))/

    def parse(tag_string)
      tag = Tag.new
      if tag_string.match(/^\(\?([a-z_]+)\s--\s/)
        tag.name = $~[1]
        tag.content = tag_string[$~.end(0)..-5]
      else
        tag_string.match(/^\(\?([a-z_]+)/)
        tag.name = $~[1]
        left = tag_string[$~.end(1)..-1]
        divider_offset = look_for_divider left
        if divider_offset
          attributes = left[0..divider_offset]
          collect_attributes(attributes, tag)
          left = left[divider_offset..-1]
          unless left == '--)'
            tag.content = left[3..-5]
          end
        else
          raise 'Parsing error: divider -- was not found'
        end
      end
      tag
    end

    private

    def collect_attributes(str, target_hash = Hash.new)
      search_from = 0
      while str.match(@@tag_regex, search_from)
        m = $~
        attr_name = m['attr1']
        attr_value = unescape_quote m['val1']
        unless attr_name
          attr_name = m['attr2']
          attr_value = m['val2']
        end
        target_hash[attr_name] = attr_value
        search_from = m.end(0)
      end
      target_hash
    end

    def unescape_quote(str)
      str && str.gsub(/\\"/, '"')
    end

    def look_for_divider(str)
      in_quote = false
      buff = []
      offset = nil
      i = 0
      while i < str.length
        s = str[i]

        if s == '"'
          if str[i-1] != '\\'
            in_quote = !in_quote
          end
        elsif s == '-'
          unless in_quote
            if buff.empty?
              offset = i
            end
            buff.push s
          end
        else
          buff.clear
        end

        if buff.join('') == '--'
          break
        end
        i += 1
      end
      offset
    end

    class Tag < Hash
      attr_accessor :name, :content

      def initialize
        @content = ''
      end
    end

  end
end