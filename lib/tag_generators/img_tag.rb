require_relative 'generator_utils'

module TagGenerators
  class ImgTag
    NON_HTML_ATTRS = ['ref_id']
    IMAGE_BY_REF = :image_url_by
    CONTEXT_HELPER_METHODS = [IMAGE_BY_REF]

    def self.context_helper_methods
      CONTEXT_HELPER_METHODS
    end

    def initialize(context_helper = nil)
      @context_helper = context_helper
    end

    def render(tag)
      raise ArgumentError, 'Tag is nil' if tag.nil?


      attrs = {}
      attrs.merge!(filter_attrs(tag, NON_HTML_ATTRS, 'class'))
      if tag.key?('ref_id')
        img_src = look_for_image(tag['ref_id'])
        if img_src
          attrs['src'] = img_src
        elsif !(attrs.has_key?('src') && attrs['src'])
          raise "Image with ref=#{tag['ref']} was not found and no fallback image in 'src' specified"
        end
      end
      ["<div#{render_attrs tag.slice('class')}>",
        "    <img#{render_attrs attrs} />",
       "</div>"].join("\n")
    end

    private

    include TagGenerators::GeneratorUtils

    def look_for_image(ref)
      return nil if @context_helper.nil?
      return nil unless @context_helper.respond_to? :image_url_by
      @context_helper.send(:image_url_by, ref, :id)
    end
  end
end