module Operations
  class UpdatePost

    attr_accessor :filter_factory

    def initialize
      @filter_factory = nil
    end

    def for_user(user)
      if user.kind_of?(User)
        @user_id = user.id
      else
        @user_id = user
      end
      self
    end

    def from_params(parameters)
      @id = parameters[:id]
      @mass_update = parameters.slice(:title, :slug, :excerpt, :post_type)
      @contents = parameters[:contents]
      self
    end

    def call!
      begin
        @result = self.doWork
        if @result.nil?
          @result = OperationResult.ok(@model)
        elsif !@result.kind_of?(OperationResult)
          @result = OperationResult.ok(@model)
        end
        self
      ensure
        unless @result
          @result = OperationResult.failed("Operations execution was interrupted with an exception")
        end
      end
    end

    def call
      begin
        @result = self.doWork
        unless @result.kind_of?(OperationResult)
          @result = OperationResult.ok(@model)
        end
      rescue Exception => e
        @result = OperationResult.failed(e, @model)
      end
      self
    end

    def doWork
      @model = Post.update(@id, @mass_update)
      unless @model.valid?
        raise "Could not update the post #{@model.id}"
      end
      if @contents
        @contents.each_pair do |role, content|
          source_content = content[:content]
          filtered_content = filter_factory.nil? ?
                               source_content :
                               filter_factory
                                 .create(content[:content_format])
                                 .filter(source_content)
          @model.content_for_or_create!(role).update!({content: source_content, filtered_content: filtered_content, content_format: content[:content_format]})
        end
      end
    end

    def result
      if @result.nil?
        raise 'Operation was not called yet'
      end
      @result
    end
  end


end

class OperationResult
  attr_accessor :model, :result, :message

  def self.failed(explain, model = nil)
    message = explain
    if explain.kind_of?(Exception)
      message = explain.message
    end
    OperationResult.new(false, model: model, message: message)
  end

  def self.ok(model)
    OperationResult.new(true, model: model)
  end


  def initialize(result = true, **args)
    @result = result
    @model = args[:model]
    @message = args[:message]
  end

  def ok?
    @result
  end

  def failed?
    !self.ok?
  end

  def error
    {
      message: @message
    }
  end
end