require 'active_support/core_ext/string/inflections'

module TagGenerators

  class NameBasedFactory

    def initialize
      @generator_classes_cache = {}
    end

    def lookup(name)
      raise 'Tag name is empty' unless name
      if @generator_classes_cache.has_key? name
        generator_class = @generator_classes_cache[name]
        if generator_class.nil?
          return fallback name
        end
        create_generator generator_class
      else
        begin
          require_relative "#{name}_tag"
          generator_class = "TagGenerators::#{name.capitalize}Tag".constantize
          @generator_classes_cache[name] = generator_class
        rescue NameError, LoadError => e
          @generator_classes_cache[name] = nil
        end
        if generator_class.nil?
          return fallback name
        end
        create_generator generator_class
      end
    end

    def is_fallback(generator)
      generator && generator.kind_of?(DefaultFallbackGenerator)
    end

    private

    def fallback(tag_name)
      DefaultFallbackGenerator.new(context)
    end

    def create_generator(generator_class)
      generator_class.new(context)
    end

    def context
      #TODO
      EmptyContext.new
    end

  end

  private

  class EmptyContext

  end

  class DefaultFallbackGenerator

    def initialize(context)

    end

    def render(val)
      ""
    end
  end

end