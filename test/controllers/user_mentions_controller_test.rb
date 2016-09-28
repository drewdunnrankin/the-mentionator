require 'test_helper'

class UserMentionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_mention = user_mentions(:one)
  end

  test "should get index" do
    get user_mentions_url
    assert_response :success
  end

  test "should get new" do
    get new_user_mention_url
    assert_response :success
  end

  test "should create user_mention" do
    assert_difference('UserMention.count') do
      post user_mentions_url, params: { user_mention: { mentions: @user_mention.mentions, username: @user_mention.username } }
    end

    assert_redirected_to user_mention_url(UserMention.last)
  end

  test "should show user_mention" do
    get user_mention_url(@user_mention)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_mention_url(@user_mention)
    assert_response :success
  end

  test "should update user_mention" do
    patch user_mention_url(@user_mention), params: { user_mention: { mentions: @user_mention.mentions, username: @user_mention.username } }
    assert_redirected_to user_mention_url(@user_mention)
  end

  test "should destroy user_mention" do
    assert_difference('UserMention.count', -1) do
      delete user_mention_url(@user_mention)
    end

    assert_redirected_to user_mentions_url
  end
end
