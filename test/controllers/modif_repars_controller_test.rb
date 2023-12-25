require 'test_helper'

class ModifReparsControllerTest < ActionController::TestCase
  setup do
    @modif_repar = modif_repars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:modif_repars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create modif_repar" do
    assert_difference('ModifRepar.count') do
      post :create, modif_repar: {  }
    end

    assert_redirected_to modif_repar_path(assigns(:modif_repar))
  end

  test "should show modif_repar" do
    get :show, id: @modif_repar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @modif_repar
    assert_response :success
  end

  test "should update modif_repar" do
    patch :update, id: @modif_repar, modif_repar: {  }
    assert_redirected_to modif_repar_path(assigns(:modif_repar))
  end

  test "should destroy modif_repar" do
    assert_difference('ModifRepar.count', -1) do
      delete :destroy, id: @modif_repar
    end

    assert_redirected_to modif_repars_path
  end
end
