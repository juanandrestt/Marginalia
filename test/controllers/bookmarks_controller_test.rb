require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  test "should get list:references" do
    get bookmarks_list:references_url
    assert_response :success
  end

  test "should get book:references" do
    get bookmarks_book:references_url
    assert_response :success
  end
end
