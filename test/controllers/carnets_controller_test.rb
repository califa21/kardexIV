require 'test_helper'

class CarnetsControllerTest < ActionController::TestCase
  setup do
    @carnet = carnets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carnets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create carnet" do
    assert_difference('Carnet.count') do
      post :create, carnet: {  }
    end

    assert_redirected_to carnet_path(assigns(:carnet))
  end

  test "should show carnet" do
    get :show, id: @carnet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @carnet
    assert_response :success
  end

  test "should update carnet" do
    patch :update, id: @carnet, carnet: {  }
    assert_redirected_to carnet_path(assigns(:carnet))
  end

  test "should destroy carnet" do
    assert_difference('Carnet.count', -1) do
      delete :destroy, id: @carnet
    end

    assert_redirected_to carnets_path
  end
end
