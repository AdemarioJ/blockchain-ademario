require 'test_helper'

class BlockchainControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get blockchain_index_url
    assert_response :success
  end

  test "should get new" do
    get blockchain_new_url
    assert_response :success
  end

  test "should get create" do
    get blockchain_create_url
    assert_response :success
  end

  test "should get show" do
    get blockchain_show_url
    assert_response :success
  end

end
