module VnDialogFormatter

  module TreeModel
    class Node

      attr_reader :children, :type
      attr_accessor :parent, :lineno


      def initialize(type = self.class.name)
        @children = []
        @type = type
      end

      def is_node_of_type?(type)
        self.type == type
      end

      def << (child)
        return if child.nil?
        children << child
        if child.kind_of? Node
          child.parent = self
        end
      end

      def [] (index)
        children[index]
      end

      def to_s
        "#{self.type}[#{self.lineno}]"
      end
    end
  end
  module BasicScriptModel
    ATTACHMENT_IMAGE = "ATTACHMENT_IMAGE"
    LOCATION_CHANGE = "LOCATION_CHANGE"
    EVENT = "EVENT"
    BRANCH = "BRANCH"
    SCRIPT_BODY = "SCRIPT_BODY"
    DIALOG_SERIF = "DIALOG_SERIF"
    NON_DIALOG_SERIF = "NON_DIALOG_SERIF"
    DIRECT_COPY = "DIRECT_COPY"
    DELIMETER = "DELIMETER"
    TEXT_NODE = "TEXT_NODE"

    class ScriptNode < TreeModel::Node

    end

    class TextNode
      attr_accessor :value, :lineno

      def initialize(text, lineno)
        @value = text
        @lineno = lineno
      end

      def is_node_of_type?(type)
        type == BasicScriptModel::TEXT_NODE
      end

      def to_s
        "TEXT_NODE [#{self.lineno}]  (#{self.value})"
      end
    end

  end

  module ParsedScriptModel

    class Script < TreeModel::Node
      # attr_reader :rendering_props
    end

    class ScriptNode < TreeModel::Node

    end

    class Serif < ScriptNode
      attr_accessor :serif_type, :name
    end

    class Branch < ScriptNode
      attr_accessor :name
    end

    class Event < ScriptNode
      attr_accessor :event_type, :content
    end

    class Note < ScriptNode
      attr_accessor :note_type, :content
    end

    class Attachment < ScriptNode
      attr_accessor :attachment_type, :value
    end

    class MultilineText
      attr_accessor :lines

      def initialize
        @lines = []
      end
    end

    class PlainText
      attr_accessor :plain_text

      def intialize(text = "")
        @plain_text = text
      end
    end
  end
  # SCRIPT_BLOCK = "script_block"
  # SCRIPT = "script"
  # ATTACHMENT_DIRECT_COPY = "attachment_direct_copy"
  # ATTACHMENT_IMAGE = "attachment_image"
  #
  # DIALOG_SERIF = "dialog_serif"
  # BLACK_SCREEN_SERIF = "black_screen_serif"
  #
  # TYPE_COMMON_EVENT = "type commmon event"
  #
  #
  # class Node
  #   @node_type = SCRIPT_BLOCK
  #   attr_reader :children
  #   attr_accessor :parent
  #
  #   def initialize
  #     @children = []
  #     @parent = nil
  #   end
  #
  #   def << (child)
  #     children << child
  #     child.parent = self
  #   end
  #
  #   def is_node_of_type?(type)
  #     self.node_type == type
  #   end
  #
  #   def node_type
  #     self.class.type
  #   end
  #
  #   class << self
  #     def node_type
  #       @node_type
  #     end
  #   end
  #
  # end
  #
  # class ScriptBody < Node
  #   @node_type = "SCRIPT"
  # end
  #
  # class TextNode < Node
  #   @node_type = "TEXT_NODE"
  # end
  #
  # class Serif < Node
  #   @node_type = "SERIF_NODE"
  #   attr_accessor :name
  # end
  #
  # class Attachment < Node
  #   @node_type = "ATTACHMENT_NODE"
  #
  #   attr_accessor :type
  #
  #   def initialize(type)
  #     @type = type
  #   end
  # end
  #
  # class Note < Node
  #   attr_accessor :type
  # end
  #
  # class Branch < Node
  #   attr_accessor :name
  #
  #   def initialize(name)
  #     @name = name
  #   end
  # end
  #
  # class Event < Node
  #   @type = "EVENT"
  #   attr_accessor :text, :type
  #
  #   def initialize(text, type)
  #     @text = text
  #     @type = type
  #   end
  # end

end