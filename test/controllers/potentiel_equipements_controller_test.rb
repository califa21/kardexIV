require 'test_helper'

class PotentielEquipementsControllerTest < ActionController::TestCase
  setup do
    @potentiel_equipement = potentiel_equipements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:potentiel_equipements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create potentiel_equipement" do
    assert_difference('PotentielEquipement.count') do
      post :create, potentiel_equipement: {  }
    end

    assert_redirected_to potentiel_equipement_path(assigns(:potentiel_equipement))
  end

  test "should show potentiel_equipement" do
    get :show, id: @potentiel_equipement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @potentiel_equipement
    assert_response :success
  end

  test "should update potentiel_equipement" do
    patch :update, id: @potentiel_equipement, potentiel_equipement: {  }
    assert_redirected_to potentiel_equipement_path(assigns(:potentiel_equipement))
  end

  test "should destroy potentiel_equipement" do
    assert_difference('PotentielEquipement.count', -1) do
      delete :destroy, id: @potentiel_equipement
    end

    assert_redirected_to potentiel_equipements_path
  end
end
