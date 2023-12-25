require 'test_helper'

class EquipementVautPoursControllerTest < ActionController::TestCase
  setup do
    @equipement_vaut_pour = equipement_vaut_pours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:equipement_vaut_pours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create equipement_vaut_pour" do
    assert_difference('EquipementVautPour.count') do
      post :create, equipement_vaut_pour: {  }
    end

    assert_redirected_to equipement_vaut_pour_path(assigns(:equipement_vaut_pour))
  end

  test "should show equipement_vaut_pour" do
    get :show, id: @equipement_vaut_pour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @equipement_vaut_pour
    assert_response :success
  end

  test "should update equipement_vaut_pour" do
    patch :update, id: @equipement_vaut_pour, equipement_vaut_pour: {  }
    assert_redirected_to equipement_vaut_pour_path(assigns(:equipement_vaut_pour))
  end

  test "should destroy equipement_vaut_pour" do
    assert_difference('EquipementVautPour.count', -1) do
      delete :destroy, id: @equipement_vaut_pour
    end

    assert_redirected_to equipement_vaut_pours_path
  end
end
