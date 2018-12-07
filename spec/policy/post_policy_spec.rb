require 'rails_helper'

RSpec.describe PostPolicy do
  subject { described_class.new(current_user: user, resource: post)}
  let(:public_post) { create(:post, owner: owner)}
  let(:private_post) { create(:post, owner: owner)}

  context 'when user is the posts`s owner' do
    let(:user) { create(:nikita) }
    let(:owner) { user }
    let(:post) { private_post }

    it do
      expect(subject).to be_able_to_edit
      expect(subject).to be_able_to_view
      expect(subject).to be_able_to_remove
    end
  end

  context 'when user is not the posts`s owner' do
    let(:owner) { create(:alex)}
    let(:user) { create(:nikita)}
    context 'if the post is public' do
      let(:post) { public_post }
      it {expect(subject).to be_able_to_view}
    end
    context 'if the post is private', pending: 'access levels are not implemented yet' do
      let(:post) { private_post }
      it {expect(subject).to_not be_able_to_view}
    end
  end

  context 'when user is an admin and not owner of the post' do
    let(:user) { create(:admin) }
    let(:owner) { create(:nikita) }
    let(:post) { private_post }
    it do
      expect(subject).to be_able_to_edit
      expect(subject).to be_able_to_view
      expect(subject).to be_able_to_remove
    end
  end

  context 'when user is anonymous user', pending: 'concept of anonymous user is not developed yet' do
    context 'if the post is public' do
      it {expect(subject).to be_able_to_view}
    end
    context 'if the post is private' do
      it {expect(subject).to_not be_able_to_view}
    end
  end
end