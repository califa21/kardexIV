require 'test_helper'

class TypeEquipementsControllerTest < ActionController::TestCase
  setup do
    @type_equipement = type_equipements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:type_equipements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create type_equipement" do
    assert_difference('TypeEquipement.count') do
      post :create, type_equipement: {  }
    end

    assert_redirected_to type_equipement_path(assigns(:type_equipement))
  end

  test "should show type_equipement" do
    get :show, id: @type_equipement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @type_equipement
    assert_response :success
  end

  test "should update type_equipement" do
    patch :update, id: @type_equipement, type_equipement: {  }
    assert_redirected_to type_equipement_path(assigns(:type_equipement))
  end

  test "should destroy type_equipement" do
    assert_difference('TypeEquipement.count', -1) do
      delete :destroy, id: @type_equipement
    end

    assert_redirected_to type_equipements_path
  end
end
