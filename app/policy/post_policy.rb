class PostPolicy
  class Scope
    attr_reader :current_user, :scope

    def initialize(current_user:, scope:)
      @current_user = current_user
      @scope = scope
    end

    def listable
      return scope if current_user.is_admin?
      #TODO
    end
  end
  attr_reader :current_user, :resource

  def initialize(current_user:, resource:)
    @current_user = current_user
    @resource = resource
  end

  def able_to_edit?
    current_user.is_admin? or @resource.owner == current_user
  end

  def able_to_remove?
    current_user.is_admin? or @resource.owner == current_user
  end

  def able_to_view?
    true
  end

end