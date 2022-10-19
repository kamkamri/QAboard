require "test_helper"

class Admin::TreesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_trees_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_trees_new_url
    assert_response :success
  end

  test "should get confirm" do
    get admin_trees_confirm_url
    assert_response :success
  end

  test "should get show" do
    get admin_trees_show_url
    assert_response :success
  end

  test "should get edit" do
    get admin_trees_edit_url
    assert_response :success
  end
end
