require 'rails_helper'

describe 'posts/display' do

  let(:presenter) {
    PostsController::ViewModel.new(create(:post))
  }

  it 'should render the display page with correct dom elements' do
    @post = presenter
    render
    expect(rendered).to have_selector('#post-title')
    expect(rendered).to have_selector('#post-content')
  end
end