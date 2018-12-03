module ApiErrors
  class ApiError < StandardError; end

  class AccessForbidden < ApiError; end
end