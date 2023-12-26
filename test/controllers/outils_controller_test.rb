require "test_helper"

class OutilsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @outil = outils(:one)
  end

  test "should get index" do
    get outils_url
    assert_response :success
  end

  test "should get new" do
    get new_outil_url
    assert_response :success
  end

  test "should create outil" do
    assert_difference('Outil.count') do
      post outils_url, params: { outil: {  } }
    end

    assert_redirected_to outil_url(Outil.last)
  end

  test "should show outil" do
    get outil_url(@outil)
    assert_response :success
  end

  test "should get edit" do
    get edit_outil_url(@outil)
    assert_response :success
  end

  test "should update outil" do
    patch outil_url(@outil), params: { outil: {  } }
    assert_redirected_to outil_url(@outil)
  end

  test "should destroy outil" do
    assert_difference('Outil.count', -1) do
      delete outil_url(@outil)
    end

    assert_redirected_to outils_url
  end
end
