require 'rails_helper'
require 'capybara/dsl'

RSpec.describe "displaying the post", type: :system do
  let!(:post) {
    Operations::AddPost.new(
      attributes_for(:post).merge(
        :contents => {main: attributes_for(:post_content)}
      )).call!.result.post
  }

  it "displays all elements" do
    visit "/p/#{post.slug}"

    expect(page).to have_selector('#post-title')
    expect(page).to have_selector('#post-content')
  end
end

feature "Post creation", type: :system do

  given(:post_text) {
    '<h2>New post</h2><p>My genius post</p>'
  }
  given(:post) {
    attributes_for(:post)
  }

  background do

  end

  scenario "post with unique slug", :process_js => true do
    visit '/posts/new'

    fill_in 'title', with: post[:title]
    fill_in 'contents.main.content', with: post_text
    fill_in 'excerpt', with: post[:excerpt]
    fill_in 'slug', with: post[:slug]

    click_button 'publish'

    expect(page).to have_current_path("/p/#{post[:slug]}")
    expect(page.find('#post-title')).to have_text(post[:title])
    expect(page.find('#post-content')).to have_text('My genius post', exact: false)
  end

end

feature "Edit post", type: :system do

  given(:post_text) {
    '<h2>New post</h2><p>My genius post</p>'
  }
  given(:post) {
    attributes_for(:post)
  }
  given!(:post_id) {
    Operations::AddPost.new(
      title: post[:title],
      excerpt: post[:excerpt],
      slug: post[:slug],
      contents: {main: {content: post_text}},
    ).call!.result.post.id
  }

  background do

  end

  scenario "post was opened for editing", :process_js => true do
    visit "/post/#{post_id}/edit"

    # wait_until { page.find('html')[:class].include?('ajax-active') }

    expect(page.has_field?('title', with: post[:title])).to be_truthy
    expect(page.has_field?('excerpt', with: post[:excerpt])).to be_truthy
    expect(page.has_field?('slug', with: post[:slug])).to be_truthy
    expect(page.find('[name="contents.main.content"]').has_text?('My genius post')).to be_truthy
  end

end