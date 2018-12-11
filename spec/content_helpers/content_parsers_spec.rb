require 'spec_helper'

require "./app/content_helpers/content_parsers"

RSpec.describe ContentParsers::TagParser do
  let(:parsed_tag) do
    ContentParsers::TagParser.new.parse(tag)
  end
  context 'tag has parameters' do
    let(:tag) { '(?img href="http://localhost" ref_id=123 -- Content --)'}
    it do
      expect(parsed_tag).to include(
                              "ref_id" => "123",
                              "href" => "http://localhost"
                            )
      expect(parsed_tag.name).to eq('img')
    end
  end
  context 'multiline tag with dangerous symbols' do
    let(:tag) do
      [
        '(?img href="http://localhost" quoted="has \" sym"',
        ' ref_id=123 -- Comment ',
        'string with -- sym --)'
      ].join("\n")
    end
    it do
      expect(parsed_tag).to include(
                              "ref_id" => "123",
                              "quoted" => 'has " sym',
                              "href" => "http://localhost"
                            )
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq(['Comment ', 'string with -- sym'].join("\n"))
    end
  end
  context 'tag has no parameters' do
    let(:tag) { '(?img -- Content --)'}
    it do
      expect(parsed_tag).to be_empty
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq('Content')
    end
  end
  context 'tag has parameters and no content' do
    let(:tag) { '(?img ref=1234 --)'}
    it do
      expect(parsed_tag).to include("ref" => "1234")
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq('')
    end
  end
  context 'tag has no parameters and no content' do
    let(:tag) { '(?img --)'}
    it do
      expect(parsed_tag).to be_empty
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq('')
    end
  end
  context 'tag has incorrect format' do

  end

end