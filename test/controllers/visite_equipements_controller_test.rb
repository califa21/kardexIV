require 'test_helper'

class VisiteEquipementsControllerTest < ActionController::TestCase
  setup do
    @visite_equipement = visite_equipements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visite_equipements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visite_equipement" do
    assert_difference('VisiteEquipement.count') do
      post :create, visite_equipement: {  }
    end

    assert_redirected_to visite_equipement_path(assigns(:visite_equipement))
  end

  test "should show visite_equipement" do
    get :show, id: @visite_equipement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @visite_equipement
    assert_response :success
  end

  test "should update visite_equipement" do
    patch :update, id: @visite_equipement, visite_equipement: {  }
    assert_redirected_to visite_equipement_path(assigns(:visite_equipement))
  end

  test "should destroy visite_equipement" do
    assert_difference('VisiteEquipement.count', -1) do
      delete :destroy, id: @visite_equipement
    end

    assert_redirected_to visite_equipements_path
  end
end
