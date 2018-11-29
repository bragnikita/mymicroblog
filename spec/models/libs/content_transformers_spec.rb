# require 'rails_helper'

require('./app/models/libs/content_transformers')

include Libs::ContentTransformers

RSpec.describe Libs::ContentTransformers::TransformerChainFactory, type: :model do

  describe 'User API' do
    let(:factory) do
      TransformerChainFactory.new
    end

    it 'responds to "create"' do
      expect(factory).to respond_to('create')
    end
    it 'returns TransformersChain' do
      chain = factory.create('markdown')
      expect(chain).to be_truthy
      expect(chain).to be_kind_of(TransformersChain)
    end
    it 'returns ArgumentsError if argument is not specified' do
      # noinspection RubyArgCount
      expect { factory.create(nil) }.to raise_error(error=ArgumentError, message="Transformer name is not specified")
    end
    it 'returns ArgumentsError if argument is not string' do
      expect { factory.create({}) }.to raise_error(error=ArgumentError, message="Wrong format type")
    end
  end

  describe 'Transformer chain building' do
    let(:chain) do
      TransformerChainFactory.new.create('markdown')
    end

    it 'creates chain with markdown transformer' do
      expect(chain.print_chain).to include(MarkdownTransformer.name)
    end
  end
end


RSpec.shared_examples 'transformer API' do
  it 'responds to process' do
    expect(transformer).to respond_to('process')
  end
end

RSpec.describe MarkdownTransformer, type: :model do
  let(:transformer) do
    MarkdownTransformer.new
  end

  it_behaves_like 'transformer API'

  describe 'source converation' do
    let(:markdown) do
      %q(
# Greeting
text *bold* text
      )
    end
    let(:html) do
      transformer.process(markdown)
    end

    it 'returns text' do
      expect(html).not_to be_nil
      expect(html).to be_kind_of(String)
    end

    it 'returns HTML' do
      expect(html.gsub(/[\n]/,'').strip).to eq(%q(<h1 id="greeting">Greeting</h1><p>text <em>bold</em> text</p>))
    end
  end
end
