require "test_helper"

class VerifcnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @verifcn = verifcns(:one)
  end

  test "should get index" do
    get verifcns_url
    assert_response :success
  end

  test "should get new" do
    get new_verifcn_url
    assert_response :success
  end

  test "should create verifcn" do
    assert_difference('Verifcn.count') do
      post verifcns_url, params: { verifcn: {  } }
    end

    assert_redirected_to verifcn_url(Verifcn.last)
  end

  test "should show verifcn" do
    get verifcn_url(@verifcn)
    assert_response :success
  end

  test "should get edit" do
    get edit_verifcn_url(@verifcn)
    assert_response :success
  end

  test "should update verifcn" do
    patch verifcn_url(@verifcn), params: { verifcn: {  } }
    assert_redirected_to verifcn_url(@verifcn)
  end

  test "should destroy verifcn" do
    assert_difference('Verifcn.count', -1) do
      delete verifcn_url(@verifcn)
    end

    assert_redirected_to verifcns_url
  end
end
