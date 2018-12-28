require 'htmlbeautifier'
require_relative '../tag_generators/generator_utils'
require_relative 'script_model'

module VnDialogFormatter
  class Renderer

    def initialize(config)
      @config = config
    end

    def render_to_string(model)
      renderer = InternalRenderer.new(model)
      renderer.writer = StringArrayCollector.new
      renderer.text_renderer = TextRenderer.new
      renderer.start
      renderer.output
    end
  end

  private

  class InternalRenderer
    include ParsedScriptModel
    include TagGenerators::TagHelpers
    include TagGenerators::GeneratorUtils

    attr_accessor :writer, :text_renderer
    attr_reader :output

    def initialize(model)
      @model = model
    end

    def start
      cfg_check
      traverse(@model)
      @output = HtmlBeautifier.beautify(writer.out)
    end

    private

    def traverse(root)


      case root
      when ParsedScriptModel::Serif
        category = root.category
        if category == SERIF_DIALOG
          div(:class => "serif") do
            if root.name
              div(:class => "name") {render_text root.name}
            end
            div(:class => "content") {render_text root.first_child}
          end
        else
          if root.name
            div(:class => "no-dialog-name") {render_text root.name}
          end
          div(:class => "no-dialog-serif") {render_text root.first_child}
        end
      when ParsedScriptModel::Branch
        div(:class => "zone") do
          div(:class => "header") do
            span(:class => "content") do
              render_text root.name
            end
          end
          root.children.each do |c|
            traverse c
          end
        end
      when ParsedScriptModel::Event
        div(:class => "event") do
          span(:class => "content") do
            render_text root.content
          end
        end
      when ParsedScriptModel::Note
        div(:class => "notice") do
          span(:class => "content") do
            render_text root.content
          end
        end
      when ParsedScriptModel::Attachment
        category = root.category
        case category
        when ATTACHMENT_DELIMETER
          div(:class => "delimeter")
        when ATTACHMENT_IMAGE
          div(:class => "image") do
            img(:src => root.value)
          end
        when ATTACHMENT_FREE_TEXT
          root.children.each do |c|
            render_text c
          end
        else
          puts "Unknown category of attachment: #{category}"
        end
      when ParsedScriptModel::Script
        div(:class => "script") do
          root.children.each do |c|
            traverse c
          end
        end
      else
        puts "Unknown model element type: #{root.class}"
      end

    end

    def cfg_check
      raise 'Collector is not set' if writer.nil?
    end

    def render_text(text_node)
      writer << text_renderer.render(text_node)
    end

  end

  class StringArrayCollector
    def initialize
      @arr = []
    end

    def << (line)
      @arr << line
    end

    def out
      @arr.join("")
    end

  end

  class TextRenderer

    def render(node)
      if node.kind_of?(ParsedScriptModel::PlainText)
        node.plain_text
      elsif node.kind_of?(ParsedScriptModel::ParsedText)
        render_formatted_text node
      else
        node.to_s
      end
    end

    def render_formatted_text(text)
      ftr = FormattedTextRenderer.new(text.text_root)
      ftr.render
    end

  end

  class FormattedTextRenderer
    include TagGenerators::TagHelpers
    include TagGenerators::GeneratorUtils

    TAG_NAMES = {
      :minds => 'span',
      :emotions => 'em',
      :emphasis => 'strong'
    }.stringify_keys

    ATTRIBUTES = {
      :minds => {:class => 'minds'},
      :emotions => {},
      :emphasis => {}
    }.stringify_keys

    attr_accessor :writer

    def initialize(model)
      @model = model
      @writer = StringArrayCollector.new
    end

    def render
      traverse @model
      output
    end

    def output
      writer.out
    end

    private

    def traverse(root)
    label = root.label
      if label == 'root'
        if root.children.empty?
          writer << root.content
        else
          root.children.each {|c| traverse(c)}
        end
      elsif root.is_node_of_type?(VnDialogFormatter::NODE_WRAP)
        tag_name = TAG_NAMES.fetch(label, 'span')
        attrs = ATTRIBUTES.fetch(label, {:class => label})
        tag(tag_name, attrs.merge('inline' => true)) do
          if root.children.empty?
            writer << root.content
          else
            root.children.each {|c| traverse(c)}
          end
        end
      elsif root.is_node_of_type?(VnDialogFormatter::NODE_PLAIN_TEXT)
        writer << root.content
      else
        puts "Unknown root type: #{root.type}"
      end
    end

  end


end