require 'kramdown'

module Libs
  module ContentTransformers

    class TransformerChainFactory

      def initialize
        @registred_transformer_factories = []
        @registred_transformer_factories << MarkdownTransformerFactory.new
      end

      def create(format, **args)
        raise ArgumentError, 'Transformer name is not specified' unless format
        raise ArgumentError, 'Wrong format type' unless format.kind_of?(String)

        chain = TransformersChain.new
        chain_definition = format.strip.downcase.split(':')
        chain_definition.each do |definition|
          @registred_transformer_factories.find_all{|f| f.matches?(definition)}.each{|f| chain.add(f.build)}
        end
        chain
      end

    end

    class TransformersChain
      def initialize
        @chain = []
      end

      def add(transformer)
        @chain << transformer
      end

      def call(input)
        @chain.inject(input) do |res, transformer|
          transformer.process(res)
        end
      end

      def print_chain
        @chain.map{|t| t.class.name}.join(', ')
      end

    end

    class TransformerFactoryBase
      def matches?(request)
        false
      end

      def build
        raise NotImplementedError, 'build() is not implemented in ' + self.class.name
      end
    end

    class MarkdownTransformerFactory < TransformerFactoryBase
      def matches?(request)
        !!(request.strip.downcase =~ /^markdown/)
      end

      def build
        MarkdownTransformer.new
      end
    end

    class MarkdownTransformer

      def process(source)
        Kramdown::Document.new(source).to_html
      end
    end


  end
end