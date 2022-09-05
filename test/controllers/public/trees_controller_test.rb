require "test_helper"

class Public::TreesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_trees_index_url
    assert_response :success
  end

  test "should get new" do
    get public_trees_new_url
    assert_response :success
  end

  test "should get confirm" do
    get public_trees_confirm_url
    assert_response :success
  end

  test "should get show" do
    get public_trees_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_trees_edit_url
    assert_response :success
  end
end
