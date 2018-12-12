require 'spec_helper'
require "./lib/content_parsers/content_parsers"
require './lib/tag_generators/img_tag'

RSpec.describe TagGenerators::ImgTag do
  let(:result) do
    described_class.new(context_helper).render(tag)
  end
  let(:context_helper) {nil}
  describe 'when attributes [src, id, alt] specified' do
    let(:tag) do
      tag_with_attrs(:src => '/uploads/public/i.jpg', :id => '10', :alt => 'Descr')
    end
    it 'should render all attributes as is' do
      expect(result).to have_tag('div') do
        with_tag 'img', :with => {:id => '10', :alt => 'Descr', :src => '/uploads/public/i.jpg'}
      end
    end
  end

  describe 'when attributes [src, class] specified' do
    let(:tag) do
      tag_with_attrs(:src => '/uploads/public/i.jpg', :class => "img img_responsive")
    end
    it 'should render all attributes as is' do
      expect(result).to have_tag('div', :with => {:class => "img img_responsive"}) do
        with_tag 'img', :with => {:src => '/uploads/public/i.jpg'}
      end
    end
  end

  describe 'when ref attribute is specified' do
    let(:tag) do
      tag_with_attrs(:src => '/uploads/public/i.jpg', :ref_id => '1234')
    end
    let(:context_helper) do
      d = double('Context helper')
      expect(d).to receive(TagGenerators::ImgTag::IMAGE_BY_REF).with('1234', :id).and_return("http://custom_image").once
      d
    end
    it 'should render all attributes as is' do
      expect(result).to have_tag('div') do
        with_tag 'img', :with => {:src => 'http://custom_image'}
      end
      expect(result).not_to have_tag('img[ref]')
    end
  end

  describe 'when referenced image is not found' do
    let(:tag) do
      tag_with_attrs(:src => '/uploads/public/i.jpg', :ref_id => '1234')
    end
    let(:context_helper) do
      d = double('Context helper')
      expect(d).to receive(TagGenerators::ImgTag::IMAGE_BY_REF).with('1234', :id).and_return(nil).once
      d
    end
    describe 'if [src] is specified' do
      let(:tag) do
        tag_with_attrs(:src => '/uploads/public/i.jpg', :ref_id => '1234')
      end
      it 'should render all attributes as is' do
        expect(result).to have_tag('div') do
          with_tag 'img', :with => {:src => '/uploads/public/i.jpg'}
        end
      end
    end
    describe 'if [src] is not specified' do
      let(:tag) {tag_with_attrs(:ref_id => '1234')}
      it 'should throw exception' do
        expect { result }.to raise_error StandardError, /was not found/
      end
    end
  end

  def tag_with_attrs(attrs)
    ContentParsers::Tag.new('img', '', attrs)
  end
end