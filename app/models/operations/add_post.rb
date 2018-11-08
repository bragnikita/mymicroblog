module Operations
  class AddPost
    attr_reader :attributes, :post
    attr_accessor :user_id

    def initialize(attributes = {})
      @attributes = attributes
      @user_id = attributes[:user_id]
    end

    def call!
      self.call
    end

    def call
      @post = Post.new(attributes.slice(:title, :excerpt, :slug, :published_at, :post_type))
      @post.owner_id = user_id ? user_id : User.admin_id
      if attributes[:contents]
        attributes[:contents].each_pair do |role, content|
          content_text = content[:content]
          filtered_content = translate_source(content)
          @post.contents.build({
                                 content: content_text,
                                 filtered_content: filtered_content,
                                 role: role,
                                 content_format: content[:content_format]
                               })
        end
      else
        @post.contents.build({role: 'main'})
      end
      @post.save
      self
    end

    def result
      Result.new(@post)
    end

    private

    def translate_source(content)
      # TODO
      content[:content]
    end

    class Result
      attr_accessor :post

      def initialize(object)
        @post = object
      end

      def ok?
        post.valid?
      end

      def error?
        !post.valid?
      end
    end
  end

end