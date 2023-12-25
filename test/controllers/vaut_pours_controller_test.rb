require 'test_helper'

class VautPoursControllerTest < ActionController::TestCase
  setup do
    @vaut_pour = vaut_pours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vaut_pours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vaut_pour" do
    assert_difference('VautPour.count') do
      post :create, vaut_pour: {  }
    end

    assert_redirected_to vaut_pour_path(assigns(:vaut_pour))
  end

  test "should show vaut_pour" do
    get :show, id: @vaut_pour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vaut_pour
    assert_response :success
  end

  test "should update vaut_pour" do
    patch :update, id: @vaut_pour, vaut_pour: {  }
    assert_redirected_to vaut_pour_path(assigns(:vaut_pour))
  end

  test "should destroy vaut_pour" do
    assert_difference('VautPour.count', -1) do
      delete :destroy, id: @vaut_pour
    end

    assert_redirected_to vaut_pours_path
  end
end
