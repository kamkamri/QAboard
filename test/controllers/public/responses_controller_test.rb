require "test_helper"

class Public::ResponsesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get public_responses_edit_url
    assert_response :success
  end
end
