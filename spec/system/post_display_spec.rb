require 'rails_helper'
require 'capybara/dsl'

RSpec.describe "displaying the post", type: :system do
  let!(:post) {
    Operations::AddPost.new(
      attributes_for(:post).merge(
        :content => attributes_for(:post_content)[:content]
      )).call.result.post
  }

  it "displays all elements", :process_js => true do
    visit "/p/#{post.slug}"

    expect(page).to have_selector('#post-title')
    expect(page).to have_selector('#post-content')
  end
end

feature "Post creation" do

  given(:post) {
    attributes_for(:post, content: '<h2>New post</h2><p>My genius post</p>')
  }

  background do

  end

  scenario "post with unique slug" do
    visit '/posts/new'

    fill_in 'title', with: post.title
    fill_in 'text', with: post.content
    fill_in 'excerpt', with: post.excerpt
    fill_in 'slug', with: post.slug

    click_button 'send'

    expect(page).to assert_current_path("/p/#{slug}")
    expect(page.find('#title')).to have_text(post.title)
    expect(page.find('#text')).to have_text('My genius post', exact: false)
  end
end