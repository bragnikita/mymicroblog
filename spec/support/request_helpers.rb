module RequestHelpers

  def get_body
    JSON.parse(response.body, :symbolize_names => true)
  end

end