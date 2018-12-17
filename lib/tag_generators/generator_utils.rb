require 'active_support/all'

module TagGenerators
  module GeneratorUtils
    def render_attrs(attributes = {})
      return if attributes.empty?
      output = "".dup
      sep = " "
      attributes.each_pair do |key, value|
        unless value.nil?
          output << sep
          output << render_attr(key, value)
        end
      end
      output unless output.empty?
    end

    def render_attr(key, value)
      value = escape_attr_value value
      %(#{key}="#{value.gsub('"', '&quot;')}")
    end

    def filter_attrs(hash, *keys)
      flatten_keys = keys.flatten
      hash.reject do |k|
        flatten_keys.include? k
      end
    end

    def escape_attr_value(value)
      ERB::Util.unwrapped_html_escape(value)
    end
  end

  module TagHelpers

    def writer
      @writer ||= ""
    end

    def div(attrs = {}, &block)
      tag("div", {'inline' => false}.merge(attrs), &block)
    end

    def span(attrs = {})
      tag("span", {'inline' => true}.merge(attrs))
    end

    def img(attrs = {})
      tag("img", {'inline' => false}.merge(attrs))
    end

    def tag(tag_name = "div", attrs)
      block = attrs.fetch('inline', false)
      attrs.delete('inline')
      writer << "<#{tag_name}#{render_attrs(attrs)}"
      if block_given?
        writer << " >"
        writer << "\n    " if block
        writer << yield
        writer << "\n" if block
        writer << "</#{tag_name}>"
      else
        writer << " />"
      end
      writer
    end

  end
end