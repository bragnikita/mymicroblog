module ApiErrors
  class ApiError < StandardError; end

  class AccessForbidden < ApiError; end

  class AuthorizationRequired < ApiError; end
end