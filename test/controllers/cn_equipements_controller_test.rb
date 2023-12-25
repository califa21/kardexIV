require 'test_helper'

class CnEquipementsControllerTest < ActionController::TestCase
  setup do
    @cn_equipement = cn_equipements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cn_equipements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cn_equipement" do
    assert_difference('CnEquipement.count') do
      post :create, cn_equipement: {  }
    end

    assert_redirected_to cn_equipement_path(assigns(:cn_equipement))
  end

  test "should show cn_equipement" do
    get :show, id: @cn_equipement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cn_equipement
    assert_response :success
  end

  test "should update cn_equipement" do
    patch :update, id: @cn_equipement, cn_equipement: {  }
    assert_redirected_to cn_equipement_path(assigns(:cn_equipement))
  end

  test "should destroy cn_equipement" do
    assert_difference('CnEquipement.count', -1) do
      delete :destroy, id: @cn_equipement
    end

    assert_redirected_to cn_equipements_path
  end
end
