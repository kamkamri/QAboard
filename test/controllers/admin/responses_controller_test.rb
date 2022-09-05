require "test_helper"

class Admin::ResponsesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get admin_responses_edit_url
    assert_response :success
  end
end
