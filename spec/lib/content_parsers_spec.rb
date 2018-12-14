require 'spec_helper'

require 'faker'
require "./lib/content_parsers/content_parsers"

RSpec.describe ContentParsers::TagParser do
  let(:parsed_tag) do
    ContentParsers::TagParser.new.parse(tag)
  end
  context 'tag has parameters' do
    let(:tag) {'(?img href="http://localhost" ref_id=123 -- Content --)'}
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
    let(:tag) {'(?img -- Content --)'}
    it do
      expect(parsed_tag).to be_empty
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq('Content')
    end
  end
  context 'tag has parameters and no content' do
    let(:tag) {'(?img ref=1234 --)'}
    it do
      expect(parsed_tag).to include("ref" => "1234")
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq('')
    end
  end
  context 'tag has no parameters and no content' do
    let(:tag) {'(?img --)'}
    it do
      expect(parsed_tag).to be_empty
      expect(parsed_tag.name).to eq('img')
      expect(parsed_tag.content).to eq('')
    end
  end
  context 'tag has incorrect format' do

  end

end

RSpec.describe ContentParsers::TagScanner do
  let(:scanner) {ContentParsers::TagScanner.new(text)}

  describe 'tag lookup' do
    describe 'long tag' do
      let(:text) {in_text %Q((?img href="http://localhost" ref_id=123 -- Content --))}
      it {expect {|b| scanner.traverse(&b)}.to yield_control.once}
    end
    describe 'tag with no content' do
      let(:text) {in_text %Q((?img href="http://localhost" ref_id=123 --))}
      it {expect {|b| scanner.traverse(&b)}.to yield_control.once}
    end
    describe 'tag with no args' do
      let(:text) {in_text %Q((?img -- Content --))}
      it {expect {|b| scanner.traverse(&b)}.to yield_control.once}
    end
    describe 'short tag' do
      let(:text) {in_text %Q((?img --))}
      it {expect {|b| scanner.traverse(&b)}.to yield_control.once}
    end
    describe 'multiline tag' do
      let(:text) do
        in_text [
                  '(?img href="http://localhost" quoted="has \" sym"',
                  ' ref_id=123 -- Comment ',
                  'string with -- sym --)'
                ].join("\n")
      end
      it {expect {|b| scanner.traverse(&b)}.to yield_control.once}
    end
  end

  describe 'tag parsing' do
    let(:text) {%Q(some text (?img -- Content --) end)}
    it('yields once') {expect {|b| scanner.traverse(&b)}.to yield_control.once}
    it 'yields with correctly parsed tag' do
      saved_tag = nil
      scanner.traverse do |tag|
        saved_tag = tag
      end
      expect(saved_tag.name).to eq('img')
      expect(saved_tag.start_pos).to eq(10)
      expect(saved_tag.tag_length).to eq(20)
    end
  end

  describe 'tag substitution' do
    describe 'when single line' do
      let(:text) {%Q(some text (?img -- Content --) and (?div -- Content2 --)end)}
      it do
        result = scanner.traverse do |tag|
          "{{#{tag.name}}-{#{tag.content}}}"
        end
        expect(result).to eq('some text {{img}-{Content}} and {{div}-{Content2}}end')
      end
    end
    describe 'when multiline' do
      let(:text) { ['some text (?img -- Content --) and (?div --','Content2 --)end'].join("\n")}
      it do
        result = scanner.traverse do |tag|
          "{{#{tag.name}}-{#{tag.content}}}"
        end
        expect(result).to eq('some text {{img}-{Content}} and {{div}-{Content2}}end')
      end
    end
  end

  describe 'when block tag' do

  end

end

def in_text(tag)
  text = Faker::Lorem.paragraph 3
  insert_in = Random.new().rand(0..text.length - 1)
  text[0..insert_in] + tag + text[insert_in..-1]
end