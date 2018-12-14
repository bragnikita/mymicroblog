require 'spec_helper'
require "./lib/tag_generators/generator_factory"

RSpec.describe TagGenerators::NameBasedFactory do
  subject {described_class.new}
  let(:lookup) {subject.lookup(tag)}
  let(:tag) {'img'}

  describe 'when tag is implemented' do
    it {expect(lookup.class.name).to eq("TagGenerators::ImgTag")}
  end
  describe 'when tag is implemented and loaded' do
    it do
      5.times do
        expect(subject.lookup(tag).class.name).to eq("TagGenerators::ImgTag")
      end
    end
  end
  describe 'when tag is not implemented' do
    let(:tag) { 'sometag' }
    it do
      5.times do
        generator = subject.lookup(tag)
        expect(subject.is_fallback(generator)).to eq(true)
      end
    end
  end

end